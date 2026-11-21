# Design decisions

Write each as: **Decision, alternatives considered, reason, trade-off.**

1. Why Proxmox as the hypervisor. TODO
2. Why a TrueNAS VM with USB disk passthrough, rather than ZFS directly on Proxmox. Reasons: it already runs, and its web interface suits several users and devices. Not claimed: PCIe/IOMMU passthrough, because the disk is USB. Trade-offs: costs host RAM; ZFS over USB can disconnect.
3. Why WireGuard rather than exposing ports at home. TODO
4. Why Layer 4 rather than Layer 7 proxying at the edge. TODO
5. Why administration is web interface only, with SSH disabled. TODO: reasons. Trade-off: no remote shell if the web interface breaks, so recovery is the laptop's own screen and keyboard.
6. Why a single `root@pam` account with two-factor login rather than a separate admin user. TODO: reasons. Trade-off: no per-user audit trail and no separation between everyday and full-power accounts.
7. Why Tailscale for private administration. Tailscale is a managed WireGuard-based service; the hand-built WireGuard tunnel (step 3) is a separate component for public services.
