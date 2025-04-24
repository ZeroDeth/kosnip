# NixOS Host Configuration Consolidation Plan

**Goal:** Consolidate the `nix-komodo-01` and `nix-komodo-02` configurations into a single, reusable NixOS module, eliminating redundancy while maintaining host-specific settings (hostname, IP).

**Proposed Steps:**

1.  **Create Common Directory Structure:**
    *   Create a new directory: `hosts/nixos/nix-komodo`
    *   Move the common files (`disko.nix`, `hardware-configuration.nix`) from `nix-komodo-01` into `hosts/nixos/nix-komodo`.
    *   Move `install-nix.sh` into the new common directory.

2.  **Create Parameterized NixOS Module:**
    *   Create `hosts/nixos/nix-komodo/module.nix`.
    *   This file will contain the bulk of the configuration, using `config.networking.hostName` (provided by `mkNixos`) to derive the host number and calculate the IP address dynamically.
    *   It will import the common `disko.nix` and `hardware-configuration.nix`.

3.  **Modify `lib/helpers.nix`:**
    *   Update `mkNixos` to accept a `hostModules` list argument instead of deriving the path from `hostname`.

4.  **Update `flake.nix`:**
    *   Modify `nixosConfigurations` for `nix-komodo-01` and `nix-komodo-02` to call `mkNixos` with `hostModules = [ ../hosts/nixos/nix-komodo/module.nix ]` and their respective `hostname` values.

5.  **Adapt `install-nix.sh`:**
    *   Modify `hosts/nixos/nix-komodo/install-nix.sh` to accept the target hostname as a command-line argument and use it in the `nixos-install` command.

6.  **Cleanup:**
    *   Remove the old `hosts/nixos/nix-komodo-01` and `hosts/nixos/nix-komodo-02` directories after verification.

**Visual Representation (Mermaid):**

```mermaid
graph TD
    subgraph flake.nix
        F_Config[nixosConfigurations]
    end

    subgraph lib/helpers.nix
        MK[mkNixos(hostname, hostModules)]
    end

    subgraph hosts/nixos/nix-komodo
        M[module.nix]
        D[disko.nix]
        H[hardware-configuration.nix]
        I[install-nix.sh]
    end

    subgraph hosts/common
        NC[nixos-common.nix]
        CP[common-packages.nix]
    end

    F_Config -- calls --> MK
    MK -- imports --> M
    MK -- imports --> NC
    M -- uses --> config.networking.hostName
    M -- imports --> D
    M -- imports --> H
    M -- imports --> NC
    M -- imports --> CP

    style F_Config fill:#f9f,stroke:#333,stroke-width:2px
    style MK fill:#ccf,stroke:#333,stroke-width:2px
    style M fill:#cfc,stroke:#333,stroke-width:2px
