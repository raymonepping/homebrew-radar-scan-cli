class RadarScanCli < Formula
  desc "Fast local secret scanning with Vault Radar, Markdown reports, and CI/CD support"
  homepage "https://github.com/raymonepping/radar-scan-cli"
  url "https://github.com/raymonepping/homebrew-radar-scan-cli/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "8b829a2dbd51683f52becf494b6056e178bdd3dfbc6952034a0fe6f30d51d77e"
  license "MIT"
  version "1.0.2"

  depends_on "bash"
  depends_on "jq"

  def install
    bin.install "bin/radar_scan" => "radar_scan"
    pkgshare.install %w[lib tpl]
  end

  def caveats
    <<~EOS
      To get started, run:
        radar_scan --help

      Example usage:
        radar_scan --type file README.md --format md
        radar_scan --type repo my_repos.json --format csv

      All scans are local — your code is never uploaded.
      Markdown and CSV output supported for CI/CD.
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/radar_scan --help")
  end
end
