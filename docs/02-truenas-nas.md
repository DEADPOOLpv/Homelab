# 2. TrueNAS VM, ZFS storage and SMB shares

## Environment
- TrueNAS Community Edition 25.10 (point release 0.1), VM 100 on the Proxmox host. The VM's creation record is dated 24 November 2025.
- VM settings: 4096 MiB RAM, ballooning off, CPU type `host`, 2 cores, 32 GiB boot disk, starts at boot, installer ISO detached.
- System dataset on the VM's boot pool; time zone Asia/Kolkata (author reported).

## USB controller passthrough
The 1 TB disk is USB. The VM configuration passes the laptop's whole USB controller (PCI 00:14.0, an Intel Tiger Lake-LP USB 3.2 xHCI controller) through to TrueNAS using PCIe/IOMMU passthrough, so TrueNAS talks to the disk directly. While the VM runs, every USB port on that controller belongs to the VM and not to the Proxmox host.

## Storage layout
Pool `tank`: one disk, 931.51 GiB raw, about 899 GiB usable, no redundancy.

| Dataset | Purpose | Properties |
|---|---|---|
| `tank/shared` | folder for moving files between devices | SMB preset, compression, daily snapshots kept 2 weeks |
| `tank/private` | important personal documents | natively encrypted with a passphrase (unlocked after each restart), copies=2, daily snapshots kept 1 month |
| `tank/cctv` | camera recordings | quota 500 GiB, large record size |

The pool was recreated as `tank` on 21 Nov 2026; the previous pool, `cctv`, held about 2.25 GiB of system data and no user files.

## Access model
| Login | Opens | Used by |
|---|---|---|
| personal login | `shared`, `private`, `cctv` | the owner only |
| shared login | `shared` only | other people, on their devices |
| camera login | `cctv` only | the two cameras |

Passwords are unique, 16 characters or more, kept in a password manager and not written in this repository. Windows allows one login per server per session, so the owner uses a single personal login that opens all three folders.

## Camera storage
- Two Xiaomi Mi Home security cameras, each with a microSD card. Per Xiaomi's support pages, the camera records to its SD card and the Mi Home app transfers recordings to an SMB share on the same network.
- Both cameras write to `tank/cctv` with the camera login over SMB 3.1.1.
- Retention: the author reports the Mi Home app deletes old footage itself, so no clean-up task is used. This is not independently verified; the 500 GiB quota is the hard limit, and usage is checked monthly.

## SMB encryption
SMB transport encryption is set to negotiate, so capable clients (the PCs and phone) encrypt their sessions while the cameras, which may not support encryption, keep working. It must not be set to "required" globally while the cameras connect. Check: `smbstatus` shows an encryption entry for the owner's session.

## Remote access
The NAS is reachable over Tailscale from outside the home network, using the same personal login and the same encrypted SMB sessions. Only the owner's own devices are on the tailnet; other people use the shared login on the home network. The NAS is not exposed to the internet and no router port is opened.

## Known risks
- One disk, no redundancy; no protection against disk failure or theft (`backup-strategy.md`).
- ZFS over a USB link can disconnect or reset.
- The Proxmox host cannot use the USB ports on the passed-through controller.

## Checks
- VM settings: 4096 MiB RAM, ballooning off, 2 cores, installer ISO detached.
- Datasets exist with the expected quota and encryption state; snapshot tasks are enabled (first run pending).
- Both cameras show as connected and writing to `cctv`.
- To test: the shared login must fail to open `private` and `cctv`.
- To confirm: `private` has copies=2 and `cctv` has record size 1M.
