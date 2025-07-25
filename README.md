# 🚨 radar-scan-cli: Battle-Tested Vault Radar CLI for DevOps & Compliance

Effortlessly scan your code, repos, images, or folders for secrets & sensitive data — powered by [HashiCorp Vault Radar](https://developer.hashicorp.com/vault/docs/radar).  
Modular, Homebrew-ready, and designed for modern CI/CD and local workflows.

---

## 🧑‍💻 Why radar-scan-cli?

- **Zero bullshit:** Clean Bash, portable, no Python or Node dependencies
- **Smart output:** Markdown, CSV, JSON, or SARIF — perfect for audits or CI
- **No lock-in:** Works with any repo, Docker image, or folder (local or remote)
- **Baseline logic:** Know what’s new, not just what’s always there
- **Built for the loop:** Modular structure for easy extension, Homebrew install, and team use

---

## 🚀 Installation

### Homebrew (recommended)

```bash
brew tap raymonepping/radar-scan-cli
brew install radar-scan-cli
```

Manual
Just clone and run:

```bash
git clone https://github.com/yourusername/radar-scan-cli.git
cd radar-scan-cli
./bin/radar_scan.sh --help
```
---

## ⚡️ Usage

```bash
radar_scan.sh --type file README.md --format md
radar_scan.sh --type repo --outfile results.csv
radar_scan.sh --type docker-image --image my/image:latest --format json
radar_scan.sh --type folder ./src --format sarif
```

### Supported types:

- repo: Scan a list of repos from .scan.repositories.json
- file: Scan a single file
- folder: Scan all files in a directory
- docker-image: Scan a local or remote Docker image

### Supported formats:

csv, json, sarif, md (Markdown)

---

## 📝 Example Output

```yaml
🔍 Scanning [file] README.md ...
Scan completed

Summary:
   New secrets found: 2
   Baseline secrets found: 0

🛑 2 secrets found in [file] README.md (see README_scan.md)
📝 Markdown report generated: README_scan.md
```
The Markdown output is fully audit-ready and easy to include in compliance reports.

---

## 🏗️ Project Structure
```python
bin/
  radar_scan.sh          # Main CLI
lib/
  scan_output.sh         # Output formatting and helpers
tpl/
  radar_agent.tpl        # Markdown template
.scan.repositories.json  # (optional) Repo batch file
```
---
## 🔒 Powered by Vault Radar

This CLI wraps HashiCorp Vault Radar
Install via:

```bash
brew tap hashicorp/tap
brew install vault-radar
```
---
## 💡 Pro tips
- Baseline: Keep baseline_* files in your repo for diff-only scanning
- Homebrew install: Works out of the box, even on Mac ARM (M1/M2)
- Modular: Drop in your own output/scan logic in lib/

---

## 🙋 FAQ

**Q: Does this upload my code anywhere?**  
A: No. All scans run locally. Vault Radar doesn’t upload files.

**Q: Can I use this in CI/CD?**  
A: 100%. All output is machine- and human-readable.

**Q: How do I update templates or logic?**  
A: Edit the files in `tpl/` or `lib/` — the main script will find them, even from Homebrew.

---

## 🤖 Credits
Raymon Epping & contributors
Inspired by the “do one thing well” Bash mantra, and built for modern security teams.

© HashiCorp Vault Radar - Automated scan CLI