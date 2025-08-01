class RadarScanCli < Formula
  desc "Fast local secret scanning with Vault Radar, Markdown reports, and CI/CD support"
  homepage "https://github.com/raymonepping/radar-scan-cli"
  url "https://github.com/raymonepping/homebrew-radar-scan-cli/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "e9bf9e5224d22e1f19cb350099eb13d7796bfa9c0d930f5a7b3cd83b038bee44"
  license "MIT"
  version "1.0.10"

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
