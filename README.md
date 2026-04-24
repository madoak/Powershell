# 🧰 PowerShell Scripts Collection

A growing collection of practical PowerShell scripts designed to make everyday tasks easier, faster, and more consistent.

## 📌 Purpose

This repository contains **random but useful PowerShell scripts** that solve real-world problems — from system administration to automation and quick fixes.

The goal is simple:

> Save time, reduce repetitive work, and provide reusable building blocks for daily operations.

---

## 📂 Contents

### 🧾 Hosts File Management

#### `update_hostfile.ps1`

Manages Windows hosts file entries.

**Features:**

* Add hostname → IP mappings
* Remove existing entries
* Prevent duplicates
* Built-in help support

**Usage:**

```powershell id="k9h2pw"
.\update_hostfile.ps1 -Help
.\update_hostfile.ps1 -Action Add -Hostname "example.local" -IPAddress "127.0.0.1"
.\update_hostfile.ps1 -Action Remove -Hostname "example.local"
```

---

### 🖥️ Remote Desktop Certificate Management

#### `set_rdp_certificate.ps1`

Automatically configures and manages the RDP SSL certificate using a PKI template.

**What it does:**

* Detects the machine FQDN automatically
* Checks for an existing RDP certificate
* Reuses valid certificates when available
* Replaces self-signed certificates with PKI-issued ones
* Requests a new certificate using `RDPTemplate` if needed
* Applies the certificate to RDP (WinStations registry key)

---

## 🚀 RDP Certificate Script Overview

This script ensures Remote Desktop uses a **valid enterprise certificate** instead of a self-signed one.

### ✔️ Key behavior

* Builds FQDN from system hostname + domain
* Searches LocalMachine RDP certificate store
* Replaces self-signed certificates if found
* Requests certificate from PKI (`RDPTemplate`)
* Configures RDP to use the correct certificate thumbprint

---

### ▶️ Example usage

Run as Administrator:

```powershell id="rdp1"
.\set_rdp_certificate.ps1
```

---

### ⚠️ Requirements

* Windows Server / Windows with RDP role enabled
* PKI / AD Certificate Services available
* Certificate template: `RDPTemplate` must exist
* Administrative privileges required

---

### 🔐 Output example

```
Found an existing certificate with subject name: CN=server.domain.local
The certificate is not self-signed. It will be used for RDP.
RDP is now configured to use the certificate with thumbprint: XXXXX
```

---

## 🚀 Getting Started

### 1. Clone the repository

```bash id="repo1"
git clone https://github.com/madoak/Powershell.git
cd Powershell
```

### 2. Run a script

Always run PowerShell as Administrator when required.

Example:

```powershell id="run1"
.\update_hostfile.ps1 -Help
```

---

## ⚙️ Requirements

* Windows PowerShell 5.1 or PowerShell 7+
* Administrator privileges (for system-level scripts)
* Optional: Active Directory Certificate Services (for RDP script)

---

## 🔐 Execution Policy

If scripts are blocked:

```powershell id="policy1"
Set-ExecutionPolicy RemoteSigned -Scope Process
```

---

## 🤝 Contributing

Feel free to contribute:

* Add new scripts
* Improve existing automation
* Fix edge cases
* Enhance documentation

---

## 📖 Philosophy

These scripts are:

* Simple
* Practical
* Reusable
* Built for real-world admin work

---

## ⚠️ Disclaimer

Use at your own risk. Always validate scripts before running in production environments.

---

## ⭐ Final Note

This repository is a collection of **small automation tools that make Windows administration easier** — nothing more, nothing less.
