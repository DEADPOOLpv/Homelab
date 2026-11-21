# 1. Proxmox VE update and hardening

Environment: Proxmox VE 9.2.32, kernel 7.0.14-30-pve (updated on 21 Nov 2026 from 9.2.18 / 7.0.14-16-pve).

## What was done
1. Repositories set to the no-subscription Proxmox repository; the enterprise repositories disabled; the Debian repositories re-enabled (see "Problems met").
2. System upgraded and rebooted.
3. Administration through the web interface only. No SSH, and no extra user: one administrator account with two-factor login (TOTP).
4. Datacenter firewall: TCP 8006 allowed only from the Tailscale address range and, as a fallback, the home network; firewall enabled at datacenter and node level.
5. Tailscale installed on the host and the owner's devices, with key expiry disabled for the host. The Tailscale account uses two-factor login.
6. Laptop set not to sleep when the lid is closed.

## Checks to run after changes
- `pveversion` shows 9.2.32 or later after the upgrade and reboot.
- `systemctl is-active ssh` prints `inactive`.
- The web interface opens over Tailscale from a phone on mobile data, and does not open from an unlisted network.
- The Two Factor page lists the administrator's TOTP entry.
- The firewall is enabled at datacenter and node level.

## Problems met and how they were solved
**`apt full-upgrade` tried to remove `proxmox-ve`, `pve-manager` and `qemu-server`.**
- Proxmox's safety hook aborted the run before anything changed.
- Diagnosis: `apt update` contacted only the Proxmox and Tailscale repositories, and `apt policy` showed the installed Proxmox packages far behind their candidates. The two Debian entries (`trixie` with `trixie-updates`, and `trixie-security`) were set to `Enabled: false`. Without them the newer Proxmox packages had unmet Debian dependencies, and `apt` tried to resolve that by removing the meta-package.
- Fix: re-enabled the three Debian suites, ran `apt full-upgrade --dry-run` and confirmed no removals, upgraded and rebooted.
- Side finding: with the Debian repositories off, the host had not been receiving Debian security updates.
- Lesson: never answer yes to an upgrade that lists `proxmox-ve` under REMOVING; read the dry run first. This check is now part of `maintenance.md`.

**SSH was still active after being disabled.** The verification output showed `active`; it was disabled afterwards. Each hardening step is therefore tied to an output where possible.
