# Hardware and its limits

| Resource | Available | Planned split (TODO: confirm) |
|---|---|---|
| CPU | 4 cores / 8 threads | |
| RAM | 16 GB | Proxmox host, TrueNAS VM (target 4 to 6 GiB), service VM(s) |
| SSD | 225 GB | Proxmox OS and VM disks |
| HDD | 1 TB, connected over USB | Passed through to the TrueNAS VM (ZFS pool) |

## Constraints to document honestly
- **One node.** This is a single Proxmox host, not a cluster. There is no high availability.
- **One data disk.** A ZFS pool on one disk detects corruption (checksums) but cannot repair it. See `backup-strategy.md`.
- **16 GB RAM.** TrueNAS currently has about 1.9 GiB, which is too low; it is being raised. Record the final allocation.
- **Laptop platform.** The 1 TB disk is attached over USB (confirmed by the author), so controller passthrough is not possible.

## To capture (paste real output into `evidence/`)
```
pveversion -v
lscpu | head -20
lsblk -o NAME,SIZE,TYPE,MODEL,TRAN
dmesg | grep -i -e DMAR -e IOMMU
```
