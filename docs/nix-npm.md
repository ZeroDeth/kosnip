# Nginx Proxy Manager (NPM) on NixOS with Tailscale and Cloudflare

This guide details the setup and configuration of Nginx Proxy Manager (NPM) on a NixOS host, integrated with Tailscale for secure network access and Cloudflare DNS challenge for automated SSL certificate management.

## Introduction

Nginx Proxy Manager is a user-friendly tool that enables you to easily manage Nginx proxy hosts, including SSL certificate generation and management, without needing to directly edit Nginx configuration files.

In this project, `nix-npm` serves as a centralized reverse proxy for various internal services (e.g., `nix-llm`, `nix-metrics`). It leverages Tailscale for secure, private network connectivity and Cloudflare's DNS challenge mechanism for obtaining and renewing SSL certificates for services exposed via Tailscale.

**Benefits:**
- **Simplified Proxy Management:** Easy-to-use web UI for managing proxy hosts.
- **Automated SSL:** Free SSL certificates via Let's Encrypt, with automated renewal using Cloudflare DNS.
- **Secure Access:** Services are exposed securely within your Tailscale network (tailnet).
- **Centralized Access Point:** A single point of entry for multiple backend services.
- **Consistent Deployment:** Utilizes the project's standard NixOS and Docker Compose deployment patterns.

---

## Prerequisites

Before you begin, ensure you have the following:

- **NixOS Host:** A machine (VM or bare metal) ready for NixOS installation, which will become `nix-npm`.
- **Tailscale Account:** A Tailscale account. If you don't have one, sign up at [tailscale.com](https://tailscale.com).
- **Cloudflare Account:** A Cloudflare account managing the domain you intend to use for your services.
- **Cloudflare API Token:** An API token from Cloudflare with permissions to edit DNS records for your chosen domain.
  - Permissions required: `Zone:Zone:Read`, `Zone:DNS:Edit` for the specific zone.
- **Domain Name:** A registered domain name managed through Cloudflare.
- **Project Repository:** Access to this project repository, as it contains the necessary NixOS configurations and Taskfile automation.

---

## Installation

The installation process for the `nix-npm` host follows the standard procedure for other NixOS hosts in this project.

1.  **Prepare NixOS Host:**
    *   Install NixOS on your target machine. Refer to the [NixOS Installation Guide](https://nixos.org/manual/nixos/stable/index.html#ch-installation) if needed.
    *   Ensure basic network connectivity.

2.  **Run Installation Script:**
    *   From the root of this project repository, use the `just` recipe to install the `nix-npm` configuration:
        ```sh
        just install-npm <IP_ADDRESS_OF_NIX_NPM_HOST>
        ```
    *   This command will SSH into the host, clone the repository, and apply the NixOS configuration defined in [`hosts/nixos/nix-npm/`](hosts/nixos/nix-npm/:0).

3.  **Initial System Configuration:**
    *   After the installation, the host will reboot.
    *   Verify SSH access to `root@nix-npm` (Tailscale MagicDNS name, once Tailscale is up).

---

## Tailscale Integration

Tailscale provides secure connectivity to the `nix-npm` host and allows it to communicate with other services on your tailnet.

1.  **Enable Tailscale on `nix-npm`:**
    *   SSH into the `nix-npm` host (initially via its IP address if Tailscale isn't up yet).
    *   Run the following command to bring Tailscale up and authenticate the node:
        ```sh
        sudo tailscale up --ssh
        ```
    *   Follow the authentication URL provided in the terminal to add the `nix-npm` host to your Tailscale network.
    *   The `--ssh` flag enables Tailscale SSH, allowing you to SSH to the host using `ssh root@nix-npm` (or your user) over the Tailscale network.

2.  **Network Connectivity:**
    *   Once `nix-npm` is on the tailnet, it can reach other Tailscale-enabled hosts (e.g., `nix-llm`, `nix-metrics`) using their Tailscale IPs or MagicDNS names.

3.  **Exposing NPM via Tailscale (Optional but Recommended):**
    *   To access the Nginx Proxy Manager web UI securely over Tailscale with HTTPS:
        ```sh
        sudo tailscale serve --bg 81 tcp://127.0.0.1:81
        sudo tailscale serve --bg 443 tcp://127.0.0.1:81 # Or your NPM's HTTPS port if configured
        ```
    *   This makes the NPM admin interface available at `https://nix-npm.<your-tailnet-name>.ts.net`. Port `81` is the default admin port for NPM. Adjust if you change it in the Docker Compose file.

---

## Nginx Proxy Manager (NPM) Setup

NPM is deployed as a Docker container managed by Docker Compose.

1.  **Deploy Docker Compose Stack:**
    *   The Ansible playbook handles the creation of necessary directories and the `docker-compose.yml` file.
    *   To generate and deploy the Docker Compose configuration for `nix-npm`, run the `just` recipe from your local machine (where you have Ansible configured):
        ```sh
        just compose nix-npm
        ```
    *   This command uses Ansible to place the `docker-compose.yaml` (generated from [`ansible/services/nix-npm/compose.yaml`](ansible/services/nix-npm/compose.yaml:0)) and related files (like `.env.example`) into `/opt/stacks/npm` on the `nix-npm` host.

2.  **Start NPM Service:**
    *   SSH into `nix-npm`.
    *   Navigate to the NPM stack directory:
        ```sh
        cd /opt/stacks/npm
        ```
    *   If an `.env` file is needed (e.g., for Cloudflare API token), copy `.env.example` to `.env` and populate it:
        ```sh
        cp .env.example .env
        nano .env # Or your preferred editor
        ```
        Ensure your `CLOUDFLARE_API_TOKEN` is set in this `.env` file.
    *   Start the NPM services:
        ```sh
        sudo docker compose up -d
        ```

3.  **Initial NPM Web Interface Access:**
    *   Access the NPM web UI. If you used `tailscale serve` as described above, this would be `https://nix-npm.<your-tailnet-name>.ts.net`. Otherwise, access it via `http://<nix-npm-tailscale-ip>:81`.
    *   Default login credentials:
        *   Email: `admin@example.com`
        *   Password: `changeme`
    *   Change these credentials immediately after your first login.

4.  **Basic Proxy Host Configuration:**
    *   Navigate to "Proxy Hosts" in NPM.
    *   Click "Add Proxy Host".
    *   **Details Tab:**
        *   Domain Names: e.g., `service1.yourdomain.com` (if exposing publicly) or `service1.nix-npm.<your-tailnet-name>.ts.net` (if using Tailscale Funnel or exposing via Tailscale IPs).
        *   Scheme: `http` or `https` (depending on the backend service).
        *   Forward Hostname / IP: The Tailscale IP or MagicDNS name of the backend service (e.g., `nix-llm` or its Tailscale IP).
        *   Forward Port: The port the backend service is listening on.
        *   Enable `Block Common Exploits`.
    *   **SSL Tab:**
        *   Select "Request a new SSL Certificate" with "Force SSL" and "HTTP/2 Support" enabled.
        *   Agree to Let's Encrypt ToS.
        *   If using Cloudflare DNS Challenge, this will be configured globally or per certificate.

---

## Cloudflare DNS Challenge Setup

Using Cloudflare's DNS challenge allows NPM to obtain SSL certificates from Let's Encrypt without exposing port 80 to the internet.

1.  **Create Cloudflare API Token:**
    *   Log in to your Cloudflare dashboard.
    *   Go to "My Profile" -> "API Tokens" -> "Create Token".
    *   Use the "Edit zone DNS" template or create a custom token.
    *   **Permissions:**
        *   `Zone` - `Zone` - `Read`
        *   `Zone` - `DNS` - `Edit`
    *   **Zone Resources:**
        *   Include - Specific zone - `yourdomain.com`
    *   Copy the generated API token. This token will be used in NPM.

2.  **Configure DNS Challenge in NPM:**
    *   In the NPM web UI, navigate to "SSL Certificates" -> "Add SSL Certificate" -> "Let's Encrypt".
    *   **If adding a new certificate directly here (not via a Proxy Host):**
        *   Enter your Domain Names.
        *   Toggle "Use a DNS Challenge".
        *   DNS Provider: Select "Cloudflare".
        *   Credentials File Content:
            ```ini
            dns_cloudflare_api_token = YOUR_CLOUDFLARE_API_TOKEN
            ```
            Replace `YOUR_CLOUDFLARE_API_TOKEN` with the token you generated.
            Alternatively, if you've set the `CLOUDFLARE_API_TOKEN` in the `/opt/stacks/npm/.env` file, NPM should pick it up automatically for DNS challenges if the `docker-compose.yaml` is configured to pass it as an environment variable to the NPM container. The provided [`ansible/services/nix-npm/compose.yaml`](ansible/services/nix-npm/compose.yaml:0) should handle this.
        *   Propagation Seconds: Can usually be left at default (e.g., 120).
    *   Agree to Let's Encrypt ToS and Save.

3.  **Requesting Certificates for Proxy Hosts:**
    *   When adding or editing a Proxy Host, on the "SSL" tab:
        *   Select "Request a new SSL Certificate".
        *   Enable "Use a DNS Challenge".
        *   If you've configured the Cloudflare token in the `.env` file and the Docker Compose service, NPM should automatically use it. If not, you might need to enter the credentials content as described above.

4.  **Wildcard Certificates:**
    *   For wildcard certificates (e.g., `*.your-internal-domain.com`), ensure your Cloudflare API token has the necessary permissions. The DNS challenge is the only way Let's Encrypt issues wildcard certificates.

---

## Integration with Other Services

NPM on `nix-npm` can proxy requests to other services on your tailnet.

-   **Proxying to `nix-llm`, `nix-metrics`, etc.:**
    *   When creating a proxy host in NPM:
        *   Forward Hostname / IP: Use the Tailscale MagicDNS name (e.g., `nix-llm`) or its Tailscale IP.
        *   Forward Port: The port the service on the target host is listening on.
-   **Internal Network Routing:** All traffic between NPM and backend services occurs over the secure Tailscale network.
-   **SSL Termination:** NPM handles SSL termination, so backend services can often be configured to listen on HTTP.
-   **Load Balancing:** Nginx (which NPM uses) has load balancing capabilities. For advanced scenarios, you might need custom Nginx configurations, which can be added in the "Advanced" tab of a proxy host in NPM.

---

## Configuration Management

1.  **Deploying Configuration via Taskfile:**
    *   The `task config HOST=nix-npm` command can be used to trigger an Ansible run that copies configuration files (like `.env`) to the `nix-npm` host.
    *   The Ansible playbook for `nix-npm` (in [`ansible/playbook.yaml`](ansible/playbook.yaml:0)) should define tasks tagged with `npm_config` to handle this.

2.  **Environment Variables & Secrets:**
    *   Critical secrets like the `CLOUDFLARE_API_TOKEN` should be stored in `/opt/stacks/npm/.env` on the `nix-npm` host. This file is gitignored.
    *   Ensure the `.env.example` file in [`ansible/services/nix-npm/`](ansible/services/nix-npm/:0) is kept up-to-date with all required variables.

3.  **Backup and Restore:**
    *   **NPM Data:** The NPM Docker container stores its data (SQLite database, custom configurations, SSL certificates) in volumes mapped to the host. The primary data volume is typically mapped to `/opt/stacks/npm/data` and `/opt/stacks/npm/letsencrypt` on the `nix-npm` host.
    *   **Backup:** Regularly back up these directories:
        ```sh
        # On nix-npm
        sudo rsync -avz /opt/stacks/npm/data/ /path/to/backup/npm/data/
        sudo rsync -avz /opt/stacks/npm/letsencrypt/ /path/to/backup/npm/letsencrypt/
        ```
    *   **Restore:** Stop NPM, restore the directories from backup, and restart NPM.
        ```sh
        # On nix-npm
        sudo docker compose -f /opt/stacks/npm/docker-compose.yaml down
        sudo rsync -avz /path/to/backup/npm/data/ /opt/stacks/npm/data/
        sudo rsync -avz /path/to/backup/npm/letsencrypt/ /opt/stacks/npm/letsencrypt/
        sudo docker compose -f /opt/stacks/npm/docker-compose.yaml up -d
        ```

---

## Troubleshooting

-   **NPM Not Starting:**
    *   Check Docker logs: `sudo docker compose -f /opt/stacks/npm/docker-compose.yaml logs`
    *   Ensure ports (80, 443, 81) are not already in use on the `nix-npm` host by other services outside Docker.
-   **Tailscale Connectivity:**
    *   Run `sudo tailscale status` on `nix-npm` to check connection.
    *   Run `sudo tailscale netcheck` for diagnostics.
    *   Ensure Tailscale ACLs allow traffic between `nix-npm` and backend services.
-   **Cloudflare DNS Challenge Failures:**
    *   Verify the API token is correct and has the right permissions in Cloudflare.
    *   Check NPM logs for specific errors from Let's Encrypt or Certbot.
    *   Ensure the domain is correctly managed by Cloudflare and DNS propagation has occurred if changes were recent.
    *   Increase "Propagation Seconds" in NPM's DNS challenge settings if needed.
-   **Certificate Renewal Issues:**
    *   NPM should auto-renew. If it fails, check logs. Often related to DNS challenge issues or Let's Encrypt rate limits.
-   **"Internal Error" in NPM UI:**
    *   Check the NPM container logs for more details. Often indicates a problem with the backend database or a misconfiguration.

---

## Security Considerations

-   **NPM Access Control:**
    *   Use strong, unique passwords for the NPM admin UI.
    *   Consider restricting access to the NPM admin UI (port 81) using Tailscale ACLs or firewall rules on `nix-npm` if not using `tailscale serve`.
-   **Tailscale ACLs:**
    *   Define strict ACLs in your Tailscale admin console to control which devices can access `nix-npm` and which services `nix-npm` can access.
-   **Cloudflare Security:**
    *   Regularly review Cloudflare API token permissions.
    *   Utilize Cloudflare's security features (WAF, bot management) for any publicly exposed services, although services proxied via NPM to Tailscale are generally not public.
-   **Rate Limiting:**
    *   NPM can be configured with custom Nginx directives for rate limiting if needed, though this is more relevant for public-facing services.
-   **Keep Software Updated:**
    *   Regularly update NixOS on `nix-npm` (`sudo nixos-rebuild switch --flake .#nix-npm` after pulling changes in `/root/kosnip`).
    *   Update Docker images for NPM by pulling new images and restarting the compose stack (`sudo docker compose pull` then `sudo docker compose up -d`).

---

## References

-   [Nginx Proxy Manager Documentation](https://nginxproxymanager.com/)
-   [Tailscale Documentation](https://tailscale.com/kb/)
-   [Cloudflare API Token Documentation](https://developers.cloudflare.com/api/tokens/)
-   [Let's Encrypt Documentation](https://letsencrypt.org/docs/)
-   Project `Taskfile`: [`Taskfile.yml`](../../Taskfile.yml:0)
-   Project Ansible Playbook: [`ansible/playbook.yaml`](../../ansible/playbook.yaml:0)
-   `nix-npm` Host Configuration: [`hosts/nixos/nix-npm/`](../../hosts/nixos/nix-npm/:0)
-   `nix-npm` Service Configuration: [`ansible/services/nix-npm/`](../../ansible/services/nix-npm/:0)
