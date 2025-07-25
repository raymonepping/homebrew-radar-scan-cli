class RadarScanCli < Formula
  desc "Fast local secret scanning with Vault Radar, Markdown reports, and CI/CD support"
  homepage "https://github.com/raymonepping/radar-scan-cli"
  url "https://github.com/raymonepping/homebrew-radar-scan-cli/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "<put_your_tarball_sha256_here>"
  license "MIT"
  version "1.1.6"

  depends_on "bash"
  depends_on "jq"

  def install
    bin.install "bin/radar_scan.sh" => "radar_scan"
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
