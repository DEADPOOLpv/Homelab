# Maintenance routine

## Monthly (about 30 minutes)
1. **Proxmox updates.** In the web interface: node, Updates, Refresh. Before upgrading, run in the Shell: `apt full-upgrade --dry-run | grep -E 'Remv|REMOVING'`. No output means nothing would be removed. If any line mentions `proxmox-ve` or `pve-manager`, stop and fix the repositories first (see `docs/01-proxmox-hardening.md`, "Problems met").
2. **Shut TrueNAS down gracefully** from its own menu, then upgrade and reboot the host. The VM starts by itself.
3. **TrueNAS updates.** Apply after the host is stable. TrueNAS keeps the previous boot environment for rollback.
4. **Storage health.** Check Storage: pool online, no errors, last scrub result.
5. **Snapshots.** Confirm recent snapshots exist for `shared` and `private`.
6. **Camera folder usage.** Check the `cctv` dataset usage against its 500 GiB quota.
7. **Tailscale.** Confirm only the expected devices are listed.

## After any change
Update the status table in the README. Do not add screenshots or logs to the repository. Run `scripts/sanitize-check.sh` before committing.
