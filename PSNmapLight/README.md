# PSNmapLight

A lightweight, PowerShell-based network scanner designed for fast, reliable port discovery and basic service fingerprinting.

This project is intended for:
- Internal network visibility
- SOC / security validation tasks
- Quick infrastructure checks
- Learning network scanning concepts in PowerShell

---

## ⚠️ Disclaimer

This tool is intended for **authorized security testing only**.

Do not use on systems or networks you do not own or have explicit permission to test.

---

## 🚀 Features

- Fast TCP port scanning (no external dependencies)
- Subnet support (`/24`, `/16`)
- Multiple scan profiles (Fast, Balanced, Stealth, Audit)
- Basic service detection via plugins
- Simple output (console + optional export)
- JSON / CSV export for SOC tooling
- Stable deterministic scanning engine (no runspaces, no job loss)

---

## 📦 Installation

Clone the repository:

git clone https://github.com/madoak/Powershell.git
cd Powershell

Import the module (if using module structure):

Import-Module .\PSNmapLight\PSNmapLight.psm1

Or run directly:

.\Invoke-NmapLight.ps1

---

## 🔧 Usage

Basic scan
Invoke-NmapLight -Target 192.168.1.10 -Profile Balanced
Subnet scan
Invoke-NmapLight -Target 192.168.1.0/24 -Profile Fast
Deep scan
Invoke-NmapLight -Target 192.168.1.10 -Profile Audit
Stealth scan (low noise)
Invoke-NmapLight -Target 192.168.1.10 -Profile Stealth

---

# 📊 Output example

OPEN 192.168.1.10:22 [SSH] OpenSSH
OPEN 192.168.1.10:80 [HTTP] nginx
OPEN 192.168.1.10:443 [HTTP] Apache

---

## 📁 Export results

JSON (SOC / SIEM ingestion)
Invoke-NmapLight -Target 192.168.1.0/24 -Profile Balanced -ExportPath results.json -Format JSON
CSV
Invoke-NmapLight -Target 192.168.1.0/24 -Profile Balanced -ExportPath results.csv -Format CSV

---

## 🧠 Scan Profiles

Profile	Description
Fast	Minimal ports, quick scan
Balanced	Default enterprise-safe scan
Stealth	Slow, low-noise scanning
Audit	Deep scan (1–1024 ports)

---

##🔌 Plugin System

PSNmapLight supports simple service detection plugins.

Each plugin:

receives (Host, Port)
returns a structured object:
@{
    Service = "SSH"
    Detail  = "OpenSSH_8.9"
}

If no plugin matches, the result defaults to:
OPEN / Unknown

---

## 🏗 Architecture

Current design:

Sequential scanning engine (stable & deterministic)
No runspaces or job pools
Controlled port iteration per host
Plugin-based service detection
Safe output aggregation

This prioritizes:

reliability over extreme concurrency
completeness over aggressive parallelism
predictability for SOC use cases

---

## 📈 Performance Notes

Optimized for accuracy and stability
No dropped ports due to concurrency issues
Suitable for enterprise internal networks
Can scale to /24 networks reliably

---

## 🔐 Security Considerations

Does not require admin rights (except where network policies restrict TCP)
No packet injection (TCP connect only)
Safe for defensive scanning environments
May trigger IDS/EDR alerts depending on profile

---

## 🧪 Example SOC use cases

Asset discovery validation
Shadow IT detection
Exposure checks before audits
Rapid port validation during incident response

---

## 📌 Roadmap (optional future enhancements)

Advanced banner fingerprinting
TLS certificate inspection plugin
HTTP header deep analysis
Confidence scoring per service
Nmap-compatible output format

---

## 👤 Author

Created as part of a PowerShell security tooling set:
“Random PowerShell scripts to make your life easier”


---
