# Matrioska OS Installation Wizard

![Matrioska OS Logo](https://example.com/logo.png)

## Introduction

The **Matrioska OS Installation Wizard** is a user-friendly tool designed to simplify the installation process of Matrioska OS. Featuring both graphical and command-line interfaces, it automates essential system configurations, ensuring an efficient and streamlined installation experience. The wizard balances automation with advanced customization options, making it suitable for both novice and experienced users.

The wizard is compatible with **Matrioska OS** versions **1.x and 2.x**, including both *Desktop* and *Server* editions. The latest supported version is **Matrioska OS 2.0**, released in **March 2025**. Users are advised to use the most up-to-date version included with the distribution to ensure optimal stability and compatibility.

## Table of Contents

- [System Requirements](#system-requirements)
- [Architecture](#architecture)
- [Installation Guide](#installation-guide)
- [Logs and Debugging](#logs-and-debugging)
- [Contributing](#contributing)
- [License](#license)

## System Requirements

### **Hardware Requirements**

- **Minimum:** 1 GHz single-core processor (x86_64), 1 GB RAM, 10 GB available disk space.
- **Recommended:** 2 GHz dual-core processor or higher, 4 GB RAM, 20-25 GB disk space, **256 MB VRAM** for graphical acceleration, and an internet connection for updates.

### **Software Dependencies**

If missing, these dependencies should be installed manually:

- **Python 3.6+**:
  ```bash
  sudo apt install python3  # Debian-based
  sudo dnf install python3  # RPM-based
  ```
- **Qt5 Libraries**:
  ```bash
  sudo apt install qt5-default  # Debian-based
  sudo dnf install qt5-qtbase-devel  # RPM-based
  ```
- **System Utilities (parted, fdisk, APT/dpkg)**:
  ```bash
  sudo apt install parted fdisk dpkg
  ```

## Architecture

The wizard is structured into **modular components**, each responsible for a specific installation task. It supports both **graphical (Qt5-based)** and **text-based (ncurses)** modes, providing flexibility across different environments.

### **Core Components**

- **User Interface (UI):** Provides both graphical and command-line interfaces.
- **Configuration Module:** Handles language, keyboard, timezone, and network settings.
- **Partitioning Module:** Facilitates automatic and manual disk partitioning.
- **Installation Module:** Manages OS file copying and core system setup.
- **Bootloader Manager:** Installs and configures GRUB for multi-boot compatibility.
- **Logging & Debugging:** Captures detailed installation logs and error reports.

## Installation Guide

### **Troubleshooting Common Issues**

- **Boot Failure:** Ensure the BIOS/UEFI boot order is set correctly.
- **Partition Errors:** Verify the target disk is accessible and writable.
- **File Copy Failures:** Check the integrity of the installation media and recreate the bootable drive.
- **Network Configuration Issues:** Try configuring network settings manually if automatic detection fails.

### **Starting the Wizard**

To begin installation, boot from the Matrioska OS **USB/DVD** and select **"Install Matrioska OS"**.

Alternatively, execute manually from a live session:
```bash
sudo matrioska-installer
```
For unattended installation:
```bash
sudo matrioska-installer --text-mode --preseed=config.cfg
```

### **Installation Workflow**

1. **Preparation:**
   - Select Matrioska OS edition (Desktop/Server).
   - Create bootable media:
     ```bash
     sudo dd if=MatrioskaOS.iso of=/dev/sdX bs=4M status=progress && sync
     ```

2. **Configuration:**
   - Select language, keyboard layout, and timezone.
   - Configure network settings.

3. **System Installation:**
   - Choose partitioning method (automatic/manual).
   - Copy OS files and install the GRUB bootloader.

4. **Final Configuration:**
   - Create a user account.
   - Configure hostname, services, and optional updates.

5. **Completion & Reboot:**
   - A confirmation message *"Installation completed successfully!"* will appear.
   - Remove the installation media and restart the system.

## Logs and Debugging

- **Logs Location:** `/var/log/installer/`
  - `/var/log/installer/syslog` – General logs.
  - `/var/log/installer/debug` – Detailed debug logs.
  - `/var/log/installer/cfg` – Saved configuration settings.
- **Live Log Monitoring:** Press `Alt+F4` during installation.
- **Enable Debug Mode:** Use `debug` or `verbose` at boot prompt.

### **Common Error Diagnostics**

- **Disk Not Found:** Check physical connectivity or re-scan storage devices.
- **Partitioning Failure:** Ensure sufficient disk space and that no conflicting processes are running.
- **Network Errors:** Adjust DHCP/static settings accordingly.
- **Bootloader Installation Failure:** Attempt a manual GRUB reinstallation using `chroot`.
- **Corrupt Installation Media:** Download a fresh ISO and recreate the bootable drive.

## Contributing

The **Matrioska OS Installation Wizard** is an **open-source** project. Contributions are encouraged!

- **Repository:** [Matrioska OS Installer](https://github.com/matrioska-os/installer)
- **Issue Reporting:** Submit bug reports and feature requests.
- **Pull Requests:** Contribute improvements and fixes.
- Follow `CONTRIBUTING.md` for contribution guidelines.

### **How to Submit a Pull Request**

1. **Fork the Repository:** Click *Fork* on GitHub.
2. **Clone Your Fork:**
   ```bash
   git clone https://github.com/your-username/installer.git
   ```
3. **Create a Feature Branch:**
   ```bash
   git checkout -b feature-branch-name
   ```
4. **Make Changes & Commit:**
   ```bash
   git add .
   git commit -m "Describe changes"
   ```
5. **Push Changes to Fork:**
   ```bash
   git push origin feature-branch-name
   ```
6. **Submit a Pull Request:** Navigate to *Pull Requests* on GitHub and submit.

## License

This project is distributed under the **MIT License**, allowing unrestricted use, modification, and redistribution. Refer to the `LICENSE` file for details.

---

For support, visit the [Matrioska OS Community](https://community.matrioska-os.org). Happy installing! 🚀

