# VM Storage Resize Procedure for Proxmox NixOS VMs

## Pre-requisites
1. Take a backup of the VM in Proxmox
2. Download Nixos or suitable Linux live ISO
3. Ensure you have SSH access to the VM

## Proxmox Steps
1. Shut down the VM in Proxmox
2. In Proxmox web interface:
   - Select the VM
   - Go to Hardware
   - Select the hard disk
   - Click "Resize"
   - Enter the new size (e.g., +10G)
3. Mount the live ISO in Proxmox VM settings
4. Start the VM with the live ISO

## Live Environment Steps
1. Boot into the live environment
2. Verify current partition structure:
   ```bash
   sudo parted /dev/vda print
   # or
   lsblk /dev/vda
   ```

3. Extend the root partition to use all available space:
   ```bash
   sudo parted /dev/vda resizepart 2 100%
   ```

4. Resize the filesystem to use the new partition size:
   ```bash
   # For ext4 filesystem:
   sudo resize2fs /dev/vda2
   # For xfs filesystem:
   sudo xfs_growfs /dev/vda2
   ```

5. Verify the new sizes:
   ```bash
   sudo parted /dev/vda print
   lsblk /dev/vda
   ```

## Post-Resize Steps
1. Shut down the live environment
2. Remove the ISO from Proxmox VM settings
3. Start the VM normally
4. Verify disk space with 'df -h'

Notes:
- Always backup important data before resizing
- Replace vda with your actual device name (check with 'lsblk')
- If using LVM, additional steps may be needed
- Consider rebooting after resize if system is heavily utilized
- In case of boot issues, you can always return to the live environment

Troubleshooting:
- If partition table shows errors, you may need to use 'fdisk' to fix GPT issues
- Always have a backup bootable ISO ready
- Keep Proxmox backup available for recovery
