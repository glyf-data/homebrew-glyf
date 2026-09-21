class Glyf < Formula
  include Language::Python::Virtualenv

  desc "Visualization build tool for data pipelines: dbt artifacts to static dashboards"
  homepage "https://github.com/glyf-data/glyf"
  url "https://files.pythonhosted.org/packages/9e/6f/7626a105114b133d6b04d9258c1a53dc950634654a19cdc3ec91912c8d59/glyf_core-0.9.0.tar.gz"
  sha256 "6cb0ebf4f9adfebfd06cf709d8d63e1dc5d47d2cc416ef44961e3d08789b1f22"
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
