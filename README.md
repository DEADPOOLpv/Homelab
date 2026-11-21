# Homelab: Proxmox, TrueNAS and ZFS on a single laptop

A single-node home infrastructure lab: a Proxmox VE hypervisor running a TrueNAS storage VM, with least-privilege file shares, scheduled snapshots, camera recording to the NAS, and private remote administration over Tailscale. Everything listed as built is running; everything else is marked as planned.

**History:** in use since at least November 2025 (the TrueNAS VM's creation record in Proxmox is dated 24 November 2025); the author reports running Proxmox and TrueNAS for more than a year. The host has not been reinstalled. In November 2026 it was decluttered and rebuilt to be more efficient, easier to use and more secure, and this repository was started to document it. Earlier notes were lost, so everything here is written from the live system.

**How to read the status column:** *Built* means it is running and the author operates it. *Built, to be tested* means it is configured but a specific test has not been done yet. *Planned* means not built. No screenshots, logs or configuration dumps are published, because they can reveal the network layout; the author can demonstrate any item live.

## Hardware

| Item        | Detail                                               |
| ----------- | ---------------------------------------------------- |
| Machine     | Lenovo laptop (older model)                          |
| CPU         | Intel Core i5-1135G7 @ 2.40 GHz, 4 cores / 8 threads |
| RAM         | 16 GB                                                |
| System disk | 225 GB SSD (Proxmox and VM disks)                    |
| Bulk disk   | 1 TB hard drive, connected over USB                  |
| Hypervisor  | Proxmox VE 9.2.32, kernel 7.0.14-30-pve              |

## Architecture

```
  Owner PC / phone        Other devices          2 x Xiaomi cameras
  (personal login)        (shared login)         (camera login; SD card + Mi Home app)
         |                      |                          |
         +----------------------+--------------------------+
                                |   home network, SMB 3.1.1
   +----------------------------v----------------------------------------+
   |  Lenovo laptop: Intel i5-1135G7, 16 GB RAM                          |
   |   Proxmox VE 9.2.32 (web interface only, firewall, Tailscale)       |
   |    +-- VM 100  TrueNAS (4 GiB RAM, 2 cores, CPU type host)          |
   |    |     USB controller 00:14.0 passed through (PCIe / IOMMU)       |
   |    |     1 TB USB disk -> ZFS pool "tank"                           |
   |    |       tank/shared   tank/private (encrypted)   tank/cctv       |
   |    +-- VM 101  ParrotOS (currently stopped)                         |
   +----------------------------^----------------------------------------+
                                |
              Tailscale: private administration of the web interface
              (owner devices only, port 8006)
```

## What is built

| #  | Component                                                                                       | Status                                  |
| -- | ----------------------------------------------------------------------------------------------- | --------------------------------------- |
| 1  | Proxmox VE updated to 9.2.32 after fixing a repository fault (`docs/01-proxmox-hardening.md`) | Built                                   |
| 2  | Administration through the web interface only; SSH service disabled                             | Built                                   |
| 3  | Two-factor login on the Proxmox administrator account                                           | Built                                   |
| 4  | Proxmox firewall: port 8006 allowed only from the Tailscale range and the home network          | Built                                   |
| 5  | Tailscale on the host and the owner's devices                                                   | Built                                   |
| 6  | TrueNAS VM with the laptop's USB controller passed through (PCIe/IOMMU)                         | Built                                   |
| 7  | ZFS pool `tank` with three datasets, one natively encrypted, one with a 500 GiB quota         | Built                                   |
| 8  | Daily snapshots: `shared` kept 2 weeks, `private` kept 1 month                              | Built, to be tested (first run pending) |
| 9  | SMB shares with three least-privilege logins                                                    | Built                                   |
| 10 | Two cameras recording to the NAS over SMB 3.1.1                                                 | Built                                   |
| 11 | SMB transport encryption negotiated for capable clients                                         | Built                                   |
| 12 | Remote access to the NAS over Tailscale, from outside the home network                          | Built                                   |

## Design in brief

- **Three logins, three folders:** a personal login opens everything; a shared login opens only `shared`; a camera login opens only `cctv`. A compromised camera or a shared password never reaches the private dataset.
- **Small attack surface:** no SSH, no public exposure of the management interface, two-factor login, firewall rule on the management port.
- **Honest storage design:** a single disk, no redundancy. This is a deliberate decision, explained in `docs/backup-strategy.md`.

Full reasoning: `docs/design-decisions.md`. Threats and controls: `docs/threat-model.md`. Routine upkeep: `docs/maintenance.md`.

## Roadmap (not built)

- An internet-facing edge (WireGuard tunnel and reverse proxy) and infrastructure as code, to be added only when built

## Security and privacy

This repository contains no real IP addresses, keys, domain names, passwords, serial numbers or account names. Run `scripts/sanitize-check.sh` before every commit.

## Author

Prathit Visen. Built and maintained independently.
