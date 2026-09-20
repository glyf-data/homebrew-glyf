class Glyf < Formula
  include Language::Python::Virtualenv

  desc "Visualization build tool for data pipelines: dbt artifacts to static dashboards"
  homepage "https://github.com/glyf-data/glyf"
  url "https://files.pythonhosted.org/packages/e1/11/4a0c5359c94170dac75b20a1f25e5b42907f1602eaa4d7b173c26f97a230/glyf_core-0.8.0.tar.gz"
  sha256 "204cc6d2787984f484bee1d0a23ab0b73918ed2afbe955cb85d6e3c996a76d1a"
  license "Apache-2.0"

  depends_on "python@3.13"

  # glyf-core depends on pyarrow, duckdb, vl-convert-python and the ADBC
  # driver manager.
  # Building those from source, as virtualenv_install_with_resources would,
  # needs Arrow C++, a Rust toolchain and a long compile; upstream publishes
  # wheels for every platform this formula supports, so install those instead.
  # The sdist above is fetched only to pin the version and its checksum.
  # Homebrew's venv.pip_install forces --no-deps --no-binary=:all:, so pip is
  # driven directly here. virtualenv_create builds the venv with
  # --system-site-packages and --without-pip, so pip comes from python@3.13
  # and installs into the venv because the venv interpreter runs it.
  def install
    virtualenv_create(libexec, "python3.13")
    system libexec/"bin/python", "-m", "pip", "install",
           "--only-binary=:all:", "--ignore-installed", "--no-compile",
           "glyf-core==#{version}"
    bin.install_symlink libexec/"bin/glyf"
  end

  test do
    assert_match "glyf #{version}", shell_output("#{bin}/glyf --version")
    system bin/"glyf", "--help"
  end
end
