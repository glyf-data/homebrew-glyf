class Glyf < Formula
  include Language::Python::Virtualenv

  desc "Visualization build tool for data pipelines: dbt artifacts to static dashboards"
  homepage "https://github.com/glyf-data/glyf"
  url "https://files.pythonhosted.org/packages/fc/6b/64798ff1980c27c0a5e4a3c1804a44cd26ccc041c44a7f6fa30a51f4151c/glyf_core-0.15.0.tar.gz"
  sha256 "d2275813518d224beb0440f0d02594b6cd94af017ae142fcd5ac63eab4e7d2e7"
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
