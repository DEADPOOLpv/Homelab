# Homelab: Proxmox, TrueNAS and a WireGuard-protected edge

A single-node home infrastructure lab, documented as it is built. The Proxmox host was reinstalled in November 2026; TODO: state exactly when the TrueNAS VM and its pool were created. The goal is to learn how real systems are isolated, exposed and defended, and to show the evidence for each claim.

> **Honesty rule for this repository:** a feature is marked **Built** only after it has been verified, with proof in `evidence/`. Everything else is **Planned** or **In progress**.

## Hardware (verified)

| Item         | Detail                                                                 |
| ------------ | ---------------------------------------------------------------------- |
| Machine      | Lenovo laptop                                                          |
| CPU          | Intel Core i5-1135G7 @ 2.40 GHz, 1 socket, 4 cores / 8 threads         |
| RAM          | 16 GB                                                                  |
| Boot/VM disk | 225 GB SSD (Proxmox host and VM storage)                               |
| Bulk disk    | 1 TB hard drive, connected over USB and passed through to a TrueNAS VM |
| Hypervisor   | Proxmox VE 9.2.18, kernel 7.0.14-16-pve (build 2026-08-28)             |

## Status

| # | Component                                                     | Status      | Evidence          |
| - | ------------------------------------------------------------- | ----------- | ----------------- |
| 1 | Proxmox VE installed and hardened                             | In progress | `evidence/01-*` |
| 2 | TrueNAS VM with the 1 TB USB disk (USB passthrough)           | In progress | `evidence/02-*` |
| 3 | Pool rebuilt as `tank`, datasets, automated snapshots, ACLs | Planned     |                   |
| 4 | SMB3 shares, encrypted                                        | Planned     |                   |
| 5 | Cloud edge VPS                                                | Planned     |                   |
| 6 | WireGuard site-to-site tunnel                                 | Planned     |                   |
| 7 | Layer 4 reverse proxy at the edge                             | Planned     |                   |
| 8 | Terraform and Ansible automation                              | Planned     |                   |
| 9 | Backups (see `docs/backup-strategy.md`)                     | Planned     |                   |

## Architecture

Diagram: TODO (added after step 6). Target design: the public internet reaches only the cloud edge VPS; the VPS forwards selected ports through an encrypted WireGuard tunnel to a service VM on Proxmox; the home network is never directly exposed.

## Documentation

- `docs/00-hardware.md`: what the machine can and cannot do
- `docs/01` to `docs/05`: build logs, one per step
- `docs/design-decisions.md`: why each choice was made
- `docs/threat-model.md`: what is protected from what
- `docs/backup-strategy.md`: what is and is not backed up
- `evidence/`: sanitized screenshots and command output

## Security and privacy

This repository contains no real IP addresses, keys, domain names, passwords or camera/home details. Run `scripts/sanitize-check.sh` before every commit.

## Author

Prathit Visen. Built and maintained independently.
