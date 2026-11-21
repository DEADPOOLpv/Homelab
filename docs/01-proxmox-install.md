# 1. Proxmox VE install and hardening

Status: **Done** (pending evidence: SSH inactive output, Two Factor page) (SSH inactive output, Two Factor page, update screenshot)

## Environment

- Proxmox VE 9.2.32, kernel 7.0.14-30-pve (upgraded on 21 Nov 2026 from 9.2.18 / 7.0.14-16-pve)
- Administration through the web interface only. No extra Linux or Proxmox user: `root@pam` is the single admin account (see `design-decisions.md`, items 5 and 6).

## Hardening checklist (ticked only with evidence)

- [X] Enterprise repositories disabled, no-subscription repository added, Debian repositories re-enabled, system upgraded and rebooted (`pveversion` output in evidence)
- [X] Two-factor login (TOTP) on `root@pam` (reported by author; screenshot of the Two Factor page pending, QR code hidden)
- [X] SSH service disabled (first check showed it still active; fixed afterwards; output of `systemctl is-active ssh` pending)
- [X] Laptop does not sleep when the lid is closed (logind lid settings applied)
- [X] Tailscale installed on the host, a PC and a phone; the Tailscale account uses two-factor login
- [X] Web interface (port 8006) reachable through Tailscale from the PC and from the phone
- [X] Datacenter firewall rules: accept TCP 8006 from the Tailscale range, and from the home network as a fallback
- [X] Firewall enabled at datacenter and node level
- [X] Tailscale key expiry disabled for the host (reported by author)

## Problems met and how they were solved

- **`apt full-upgrade` tried to remove `proxmox-ve`, `pve-manager` and `qemu-server`.** Proxmox's safety hook aborted it before anything changed. Diagnosis with `apt update` and `apt policy`: only the Proxmox no-subscription and Tailscale repositories were being contacted. The two Debian entries (`trixie`/`trixie-updates` and `trixie-security`) were set to `Enabled: false`, so the newer Proxmox packages had unmet Debian dependencies and `apt` resolved it by removing the meta-package. Fix: re-enabled the Debian repositories, re-checked with a dry run that listed no removals, upgraded and rebooted. Side effect found: with Debian repositories off, no Debian security updates had been arriving.
- First verification showed `ssh` still active after the plan said to disable it. The check caught it, which is why every item above is tied to an output.
