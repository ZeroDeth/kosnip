# [Build a private, self-hosted LLM server with Proxmox, PCle passthrough, Ollama & NixOS - YouTube](https://www.youtube.com/watch?v=9hni6rLfMTg)

# Getting Started with Nix, SSH, & Tailscale

This documentation provides a guide on how to get started with Nix, SSH, and Tailscale. These tools are powerful for setting up environments, remote access, and secure networking.

## Prerequisites

Before beginning, ensure you have the following:

1. A compatible machine to install NixOS.
2. Basic understanding of virtualization and networking.
3. Administrative access to virtualization software like Proxmox or any other similar platform.

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
3. **Set SSH Password**: Use `passwd` to set an SSH password.
4. **SSH into VM**: Connect via SSH for ease of configuration.

### Step 5: Configure NixOS

- **Root Password**: Set a root password for the freshly installed NixOS.
- **Network Configuration**: Update the network settings as needed for your environment.
- **Install nix-llm**: Use the justfile to automate the installation. From your project root, run:

  ```sh
  just install <IP_ADDRESS>
  ```
  Replace `<IP_ADDRESS>` with the address of your NixOS VM.

## Setting Up SSH

1. **Enable SSH**: Ensure SSH is enabled on your NixOS instance.
2. **Access via SSH**: Use the set SSH credentials to access your NixOS machine remotely.

## Install and Configure Tailscale

1. **Authenticate Tailscale**:
    - Run:
      ```sh
      tailscale up --ssh
      ```
    - Authenticate using your Tailscale account.
2. **Connect Devices**:
    - Once authenticated, your NixOS VM can securely connect to your Tailscale network.
3. **Update Submodules**:
    - From your project root, run:
      ```sh
      just sub-update
      ```
4. **Generate Docker Compose for nix-llm**:
    - Run:
      ```sh
      just compose nix-llm
      ```
5. **Start the LLM Services**:
    - SSH into your NixOS VM, navigate to the directory with your generated `docker-compose.yml`, and run:
      ```sh
      docker compose up --watch
      ```

## PCIe Pass-through (Optional)

If you need to pass through a GPU to your VM:

1. **Verify Compatibility**: Ensure hardware (motherboard, CPU, GPU) supports PCIe pass-through.
2. **Configure Proxmox**:
    - Add the GPU as a PCI device in the VM's hardware settings.
    - Check Proxmox documentation for specifics on setting up PCIe pass-through.
3. **Validate Setup**:
    - SSH into your NixOS VM and run `nvidia-smi` to verify GPU recognition.

## Serving Open WebUI Securely with Tailscale

To securely expose your Open WebUI instance over your Tailscale network with automatic HTTPS certificates, you can use Tailscale's built-in HTTPS serving feature. This is especially useful for securely accessing web interfaces like Open WebUI from any device on your Tailscale network.

**Steps:**

1. Ensure Open WebUI is running and listening on port 8080 (or your chosen port).
2. In your terminal, run the following command:

   ```sh
   tailscale serve --bg 8080
   ```

   This command will serve the local port 8080 over HTTPS to your Tailscale network, using certificates managed by Tailscale.

3. Access the web UI using your machine's Tailscale domain (e.g., `https://<your-machine-name>.ts.net`).

For more details, see the [Tailscale Serve documentation](https://tailscale.com/kb/1227/serve/).

---

## Conclusion

By following these steps, you now have a basic setup using NixOS, SSH, and Tailscale. This setup provides a solid foundation for further exploration into network management, virtualization, and secure cloud connectivity. For more advanced configurations, consult detailed documentation or community forums related to each tool.
