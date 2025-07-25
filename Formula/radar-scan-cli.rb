class BrewBrainCli < Formula

  desc "Audit, document, and manage your Homebrew CLI arsenal with one meta-tool"
  homepage "https://github.com/raymonepping/brew_brain_cli"
  url "https://github.com/raymonepping/homebrew-brew-brain-cli/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "addb730ea38233fbff8c4165d2e747ba535c746fc88fa8ad2cfd88684a0d07d4"
  license "MIT"
  version "1.4.4"

  depends_on "bash"
  depends_on "jq"

  def install
    bin.install "bin/brew_brain" => "brew_brain"
    pkgshare.install %w[lib tpl]
  end

  def caveats
    <<~EOS
      To get started, run:
        brew_brain --help

      This CLI helps audit, document, and version-manage your custom Homebrew CLI arsenal.

      Example usage:
        brew_brain --output markdown --output-file arsenal
        brew_brain checkup
    EOS
  end

  test do
    assert_match "brew_brain", shell_output("#{bin}/brew_brain --help")
  end
end
