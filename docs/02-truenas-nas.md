# 2. TrueNAS VM and ZFS storage

Status: **In progress** (VM and pool exist; corrections and share setup pending)

## Decision
Keep the existing TrueNAS VM instead of moving ZFS to the Proxmox host. The VM was created on 24 November 2025 (Proxmox creation record).
- It is already running, and a web interface is easier and safer to maintain for several users and devices than hand-written Samba configuration.
- The 1 TB drive is USB. The VM configuration passes the laptop's whole USB controller (PCI address 00:14.0) through to TrueNAS using PCIe/IOMMU passthrough, so TrueNAS talks to the drive directly. Consequence: while the VM runs, every USB port on that controller belongs to the VM, not the Proxmox host. Confirmed: 00:14.0 is the Intel Tiger Lake-LP USB 3.2 xHCI host controller (`evidence/02-usb-controller.txt`).
- Trade-offs: the VM costs host RAM, and a USB link under ZFS can disconnect or reset (see Known risks).

## Observed state (from screenshots, 21 Nov 2026)
| Item | Observed |
|---|---|
| TrueNAS | Community Edition 25.10 (point release 0.1) "Goldeye"; an update is available |
| VM CPU | type `host`, 1 core, 1 socket (changed from the generic QEMU CPU on 21 Nov 2026) |
| VM memory | 4096 MiB, ballooning off (raised from about 1.9 GiB on 21 Nov 2026) |
| VM disk | 32 GiB boot disk (qcow2 on local storage); installer ISO still attached |
| VM start | starts at boot |
| Pool | `cctv`, one disk, 931.51 GiB, 899.25 GiB usable, online, no errors |
| Pool usage | 2.25 GiB used |
| Scrub | scheduled Sundays 00:00; last finished 2026-11-01, 0 errors, 52 minutes |

## Corrections planned
1. **Memory:** done (4096 MiB, fixed). Consider 6 GiB if the host has room.
2. **CPU type `host`:** done. Cores raised from 1 to 2 (author confirmed), because encrypted SMB and ZFS on one core is slow.
3. **Recreate the pool with a better name:** `cctv` is the wrong name for a pool that will also hold files. Pool names cannot be changed in the interface, and the pool holds almost nothing, so recreate it as `tank` with two datasets.
4. **Datasets:** `tank/shared`, `tank/private` and `tank/cctv` (see Storage layout below).
5. **Detach the installer ISO:** done (author confirmed).
6. **Apply the TrueNAS update** after the Proxmox upgrade is finished and stable.

## Storage layout (created 21 Nov 2026)
| Dataset | Purpose | Key properties |
|---|---|---|
| `tank/shared` | the one folder shared on the home network for moving files between devices | SMB preset, compression, snapshots |
| `tank/private` | important personal documents | native encryption with a passphrase, copies=2, accessible to one account only |
| `tank/cctv` | camera recordings | quota (starting at 500 GiB, adjustable), large record size, old footage removed by a scheduled task; its own camera-only account |

Why separate datasets: one login shared by everyone and every device must not also open the private documents, and a camera should only ever reach its own folder.

## Access model
| Login | Opens | Used by |
|---|---|---|
| personal login | `shared`, `private`, `cctv` | the owner only |
| shared login | `shared` only | other people, on their devices |
| camera login | `cctv` only | the two cameras |

Passwords are unique, 16 characters or more, kept in a password manager and never written in this repository. Windows allows only one login per server per session, which is why the owner uses a single personal login for all three folders.

## Camera storage
- Two Xiaomi Mi Home security cameras, each with a microSD card inserted. Per Xiaomi's support pages, the camera saves to its SD card and the Mi Home app transfers the recordings to an SMB share on the same network.
- The cameras write to `tank/cctv` with the camera login. Quota 500 GiB. A scheduled task removes files older than 30 days (planned, see Step 5).

## Known risks (stated honestly)
- One disk, no redundancy: ZFS detects corruption but cannot repair it unless `copies=2` holds a second copy. No protection against disk failure or theft. See `backup-strategy.md`.
- USB attachment: disconnects, power-saving resets and limited health data.

## Steps taken
TODO

## Verification
- [x] VM memory raised to 4096 MiB (VM configuration shown; dashboard check pending)
- [x] VM CPU type set to `host` (VM configuration shown)
- [x] VM cores raised to 2 (author confirmed)
- [x] Installer ISO detached (author confirmed)
- [x] New pool `tank` created with the three datasets (pool health screenshot pending)
- [x] Datasets `shared`, `private` (encrypted, unlocked) and `cctv` (500 GiB quota) exist (`evidence/02-datasets.txt`)
- [ ] `private` has copies=2 and `cctv` has record size 1M (not visible in the screenshot)
- [ ] Snapshot task and scrub schedule confirmed
- [x] SMB shares reachable from the PC with the personal login (author reported, 21 Nov 2026; screenshot pending)
- [ ] Negative test: the shared login cannot open `private` or `cctv` (screenshot pending)
- [x] Both cameras connect and store recordings through the Mi Home app (author reported; screenshot pending)

## Evidence
- `evidence/02-truenas-observed-state.txt`
- `evidence/02-vm-config.txt`
- `evidence/02-datasets.txt`
