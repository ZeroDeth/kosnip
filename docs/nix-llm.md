# Build a Private, Self-Hosted LLM Server with Proxmox, PCIe Passthrough, Ollama & NixOS

This guide walks you through setting up a private LLM server on NixOS, running in a Proxmox VM, with optional PCIe passthrough and secure remote access via SSH and Tailscale. By the end, you’ll have a production-ready system for running large language models, with modern DevOps practices.

> **Reference Video:** [YouTube: Build a private, self-hosted LLM server with Proxmox, PCIe passthrough, Ollama & NixOS](https://www.youtube.com/watch?v=9hni6rLfMTg)


## Prerequisites

Before beginning, ensure you have:

- A compatible machine to install NixOS (bare metal or VM).
- Administrative access to Proxmox or similar virtualization platform.
- Basic understanding of virtualization, networking, and the command line.
- A working Nix installation on your local machine (for remote deployment/testing).
- (Recommended) Familiarity with SSH, Tailscale, and Docker Compose.


## Setting Up NixOS

### Step 1: Download NixOS ISO

1. **Visit NixOS Website**: Navigate to [nixos.org](https://nixos.org).
2. **Download Minimal ISO**: Scroll to the "NixOS - The Linux distribution" section and choose the minimal ISO image. Copy the download link for the ISO.

### Step 2: Upload ISO to Proxmox

1. **Go to Proxmox Storage**: Navigate to your Proxmox shared storage.
2. **Download from URL**: Use the copied ISO link to download and store it on your Proxmox server.

### Step 3: Create a Virtual Machine for NixOS

1. **New VM Setup**: Create a new VM in Proxmox with a relevant VM ID and name.
2. **Select ISO**: Choose the NixOS ISO you uploaded.
3. **Configure VM Attributes**:
    - System: Use UEFI type BIOS (OVMF) and enable the QEMU guest agent.
    - Disks: Choose 'virtio block' for better performance.
    - CPU & Memory: Assign appropriate resources (e.g., 16 cores, 32 GB RAM).
    - Network: Set up networking as necessary, possibly with VLAN tagging.

### Step 4: Install NixOS

1. **Boot VM**: Start the VM and access the console.
2. **Begin Installation**: Follow the installation prompts to set up NixOS.
3. **Set SSH Password (Live Installer)**: Use `passwd` to set an SSH password for the live session (needed for initial remote access).
4. **SSH into VM**: Connect via SSH for ease of configuration.

### Step 5: Configure NixOS

- **Root Password (Installed System)**: After installation, set a root password for the freshly installed NixOS (see below).
- **Network Configuration**: Update the network settings as needed for your environment.
- **Install nix-llm**: Use the Taskfile to automate the installation. From your project root, run:

  ```sh
  task install HOST=nix-llm IP=<IP_ADDRESS>
  ```
  Replace `<IP_ADDRESS>` with the address of your NixOS VM.

  **Before rebooting your NixOS VM, set the password for the `nixos` user inside the installed system:**

  ```sh
  ssh nixos@<IP_ADDRESS>   # Connect to your VM as the default user
  sudo su                  # Become root
  nixos-enter --root /mnt  # Enter the installed system (chroot)
  passwd                   # Set the root password for the installed system
  exit                     # Exit the chroot
  reboot                   # Reboot into your new NixOS installation
  ```

  > **Note:**
  > The first `passwd` sets a password for the live installer. The second (inside the chroot) sets the password for the actual installed system. This ensures you can SSH in after reboot.

- **Verify Installation**: After reboot, SSH in and check system status:
  ```sh
  ssh root@<IP_ADDRESS>
  nixos-version
  hostnamectl
  ```

## Setting Up SSH

SSH access to your NixOS VM is handled automatically by Tailscale and the Taskfile workflow in this repository. You do **not** need to manually configure SSH keys or edit `configuration.nix` for SSH access.

- After running `tailscale up --ssh` on your VM, you can securely SSH to it using Tailscale’s built-in authentication and the Tailscale-assigned IP or hostname.
- The `task` commands in this repo automate the provisioning and connection process using Nix flakes and Tailscale.

> **Note:**
> If you encounter SSH connection issues, ensure Tailscale is running and authenticated on both client and VM. Manual SSH configuration is only needed for advanced or custom setups.

## Install and Configure Tailscale

[Tailscale](https://tailscale.com/) is a secure, zero-config VPN that makes your VM accessible from anywhere. Sign up at tailscale.com if you don’t have an account.

1. **Install and Authenticate Tailscale**:
   ```sh
   tailscale up --ssh
   ```
   Follow the authentication URL in your terminal to connect your VM to your Tailscale network.
2. **Connect Devices**:
   Once authenticated, your NixOS VM can securely connect to your Tailscale network.
3. **Update Submodules**:
   From your project root:
   ```sh
   task sub-update
   ```
4. **Generate Docker Compose for nix-llm**:
   ```sh
   task compose nix-llm
   ```
   This generates a `docker-compose.yml` for the LLM stack.
5. **Start the LLM Services**:
   SSH into your NixOS VM, navigate to the directory with your generated `docker-compose.yml`, and run:
   ```sh
   docker compose up --watch
   ```

> **Tip:** If you need persistent storage, ensure Docker volumes are mapped to disk locations that will survive VM reboots.

## PCIe Pass-through (Optional)

If you need to pass through a GPU to your VM:

1. **Verify Compatibility**: Ensure your hardware (motherboard, CPU, and GPU) supports PCIe pass-through (IOMMU/VT-d/AMD-Vi must be enabled in BIOS/UEFI).
2. **Configure Proxmox**:
   - Add the GPU as a PCI device in the VM's hardware settings.
   - See the [Proxmox PCIe Passthrough documentation](https://pve.proxmox.com/wiki/PCI_Passthrough) for detailed steps.
3. **Validate Setup**:
   - SSH into your NixOS VM and run:
     ```sh
     nvidia-smi
     ```
     to verify GPU recognition.

> **Warning:** PCIe passthrough can be tricky and hardware-specific. Consult your motherboard and Proxmox documentation for troubleshooting.

## Serving Open WebUI Securely with Tailscale

To securely expose your Open WebUI instance over your Tailscale network with automatic HTTPS certificates, use Tailscale's built-in HTTPS serving feature:

1. Ensure Open WebUI is running and listening on port 8080 (or your chosen port).
2. In your terminal, run:
   ```sh
   tailscale serve --bg 8080
   ```
   This serves local port 8080 over HTTPS to your Tailscale network, using certificates managed by Tailscale.
3. Enable the web client for browser-based SSH access:
   ```sh
   tailscale set --webclient
   ```
   This enables Tailscale's web client feature, allowing you to access your machine via SSH directly from a browser.
4. Access the web UI using your machine's Tailscale domain (e.g., `https://<your-machine-name>.ts.net`).

For more details, see the [Tailscale Serve documentation](https://tailscale.com/kb/1227/serve/).

---

## Troubleshooting

- **SSH not working:**
  - Double-check network/firewall settings.
  - Ensure SSH is enabled and configured in your NixOS configuration.
  - Use `journalctl -u sshd` for logs.
- **Tailscale issues:**
  - Run `tailscale status` and `tailscale up` for diagnostics.
  - Check your Tailscale dashboard for device visibility.
- **Docker not starting:**
  - Ensure Docker is installed and the service is running.
  - Use `docker compose logs` for troubleshooting.
- **General:**
  - Reboot the VM if you make significant configuration changes.
  - Consult NixOS, Proxmox, or Tailscale documentation for advanced troubleshooting.

---

## References & Further Reading

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Proxmox Documentation](https://pve.proxmox.com/wiki/Main_Page)
- [Tailscale Documentation](https://tailscale.com/kb/)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [YouTube: Build a private, self-hosted LLM server with Proxmox, PCIe passthrough, Ollama & NixOS](https://www.youtube.com/watch?v=9hni6rLfMTg)
