# 🧰 PowerShell Scripts Collection

A growing collection of practical PowerShell scripts designed to make everyday tasks easier, faster, and more consistent.

## 📌 Purpose

This repository contains **random but useful PowerShell scripts** that solve real-world problems — from system administration to automation and quick fixes.

The goal is simple:

> Save time, reduce repetitive work, and provide reusable building blocks for daily operations.

---

## 📂 Contents

Scripts in this repository may include:

* System administration utilities
* Network and configuration helpers
* File and data processing scripts
* Security and compliance helpers
* Automation tools for common tasks

Each script is self-contained and documented where needed.

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/madoak/Powershell.git
cd Powershell
```

### 2. Run a script

Make sure you run PowerShell as Administrator when required.

Example:

```powershell
.\update_hostfile.ps1 -Help
```

---

## 📜 Example Script: Hosts File Updater

The `update_hostfile.ps1` script allows you to manage entries in the Windows hosts file.

### Features

* Add hostname → IP mappings
* Remove existing entries
* Prevent duplicate entries
* Built-in help support

### Usage

#### Show help

```powershell
.\update_hostfile.ps1 -Help
```

#### Add entry

```powershell
.\update_hostfile.ps1 -Action Add -Hostname "example.local" -IPAddress "127.0.0.1"
```

#### Remove entry

```powershell
.\update_hostfile.ps1 -Action Remove -Hostname "example.local"
```

⚠️ **Note:** This script must be run as Administrator.

---

## ⚙️ Requirements

* Windows PowerShell 5.1 or PowerShell 7+
* Appropriate permissions (some scripts require Administrator rights)

---

## 🔐 Execution Policy

If scripts are blocked, temporarily allow execution:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process
```

---

## 🤝 Contributing

Feel free to contribute by:

* Adding new useful scripts
* Improving existing ones
* Fixing bugs or edge cases
* Enhancing documentation

---

## 📖 Philosophy

These scripts are:

* **Simple** – easy to understand and modify
* **Practical** – built for real use cases
* **Reusable** – designed to be dropped into any environment

---

## ⚠️ Disclaimer

Use these scripts at your own risk. Always review scripts before running them in production environments.

---

## ⭐ Final Note

This repo is intentionally a **grab bag of useful PowerShell tools** — not a framework, not a product, just things that make life easier.

If it saves you time, it’s doing its job.
