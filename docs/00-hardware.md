# Hardware and its limits

| Resource | Available | Use |
|---|---|---|
| CPU | Intel Core i5-1135G7, 4 cores / 8 threads | Shared by the host and the VMs; TrueNAS VM has 2 cores |
| RAM | 16 GB | Proxmox host; TrueNAS VM 4 GiB (fixed); ParrotOS VM 8 GiB when running |
| SSD | 225 GB | Proxmox system, VM disks (TrueNAS boot disk 32 GiB, ParrotOS disk 80 GiB) |
| HDD | 1 TB, connected over USB | ZFS pool `tank` inside the TrueNAS VM, reached through the passed-through USB controller |

## Constraints
- **One node.** A single Proxmox host, not a cluster. No high availability.
- **One data disk.** ZFS on one disk detects corruption (checksums) but cannot repair it, except where `copies=2` stores a second copy. See `backup-strategy.md`.
- **Memory is the tight resource.** TrueNAS 4 GiB plus ParrotOS 8 GiB leaves about 4 GiB for the host, so the ParrotOS VM is run only when needed.
- **USB controller belongs to the VM.** The laptop's USB controller (PCI 00:14.0) is passed through to TrueNAS, so USB ports on it are unavailable to the Proxmox host while the VM runs.
