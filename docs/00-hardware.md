# Hardware and its limits

| Resource | Available | Planned split (TODO: confirm) |
|---|---|---|
| CPU | 4 cores / 8 threads | |
| RAM | 16 GB | Proxmox host, TrueNAS VM (target 4 to 6 GiB), service VM(s) |
| SSD | 225 GB | Proxmox OS and VM disks |
| HDD | 1 TB, connected over USB | ZFS pool inside the TrueNAS VM, reached through the passed-through USB controller |

## Constraints to document honestly
- **One node.** This is a single Proxmox host, not a cluster. There is no high availability.
- **One data disk.** A ZFS pool on one disk detects corruption (checksums) but cannot repair it. See `backup-strategy.md`.
- **16 GB RAM.** TrueNAS currently has about 1.9 GiB, which is too low; it is being raised. Record the final allocation.
- **Laptop platform.** The 1 TB disk is attached over USB. The laptop's USB controller (PCI 00:14.0) is passed through to the TrueNAS VM, so USB ports on that controller are not usable by the Proxmox host while the VM runs.

## To capture (paste real output into `evidence/`)
```
pveversion -v
lscpu | head -20
lsblk -o NAME,SIZE,TYPE,MODEL,TRAN
dmesg | grep -i -e DMAR -e IOMMU
```
