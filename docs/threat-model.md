# Threat model

Scope: a home network with one laptop server, a few users and two cameras. Not a high-security environment; the controls are chosen to be proportionate and easy to maintain.

| Asset | Threat | Control | Tested? |
|---|---|---|---|
| Proxmox management interface | Credential attack from the internet or the LAN | Not published; firewall allows port 8006 only from the Tailscale range and the home network; two-factor login | Configured |
| Proxmox host | Attack through a remote shell | SSH service disabled | Configured |
| Proxmox host | Running unpatched software | Monthly update routine; dry-run check before upgrading | Update to 9.2.32 done |
| Private documents | Another user or device reading them | Separate natively encrypted dataset; one login only | Denial test pending |
| Shared folder | Over-broad access | Shared login can open `shared` only | Denial test pending |
| Camera login | A compromised camera or its stored credentials reaching other data | Camera login can open `cctv` only; quota 500 GiB | Camera sessions seen connected |
| Files on the LAN | Interception | SMB transport encryption | Set to negotiate; active for capable clients |
| Files | Accidental deletion | Daily snapshots | Tasks enabled; first run pending |
| Files | Disk failure or theft | None, by design | See `backup-strategy.md` |
| NAS reached from outside the home | Exposure to the internet | Reached only through Tailscale; no router port forwarding; only the owner's devices on the tailnet | Tested from outside the home network |
