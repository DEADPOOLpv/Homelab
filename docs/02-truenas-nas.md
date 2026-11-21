# 2. TrueNAS VM and ZFS storage

Status: **In progress** (VM and pool exist; corrections and share setup pending)

## Decision
Keep the existing TrueNAS VM, with the 1 TB USB drive passed through to it, instead of moving ZFS to the Proxmox host.
- It is already running, and a web interface is easier and safer to maintain for several users and devices than hand-written Samba configuration.
- Controller passthrough (PCIe/IOMMU) is not possible: the drive is USB. This is **USB device passthrough**, and the documentation must not claim otherwise.
- Trade-offs: the VM costs host RAM, and a USB link under ZFS can disconnect or reset (see Known risks).

## Observed state (from screenshots, 21 Nov 2026)
| Item | Observed |
|---|---|
| TrueNAS | Community Edition 25.10 (point release 0.1) "Goldeye"; an update is available |
| VM CPU type | QEMU Virtual CPU 2.5+ (generic) |
| VM memory | about 1.9 GiB available to TrueNAS |
| Pool | `cctv`, one disk, 931.51 GiB, 899.25 GiB usable, online, no errors |
| Pool usage | 2.25 GiB used |
| Scrub | scheduled Sundays 00:00; last finished 2026-11-01, 0 errors, 52 minutes |

## Corrections planned
1. **Give the VM more memory:** 1.9 GiB is far below what TrueNAS needs for SMB plus ZFS caching. Target 4 to 6 GiB, fixed (ballooning off).
2. **Set the VM CPU type to `host`:** the generic CPU type hides hardware AES, which makes SMB3 encryption slower.
3. **Recreate the pool with a better name:** `cctv` is the wrong name for a pool that will also hold files. Pool names cannot be changed in the interface, and the pool holds almost nothing, so recreate it as `tank` with two datasets.
4. **Datasets:** `tank/files` (copies=2, snapshots) and `tank/cctv` (quota, large record size, old footage removed).
5. **Apply the TrueNAS update** after the Proxmox upgrade is finished and stable.

## Known risks (stated honestly)
- One disk, no redundancy: ZFS detects corruption but cannot repair it unless `copies=2` holds a second copy. No protection against disk failure or theft. See `backup-strategy.md`.
- USB attachment: disconnects, power-saving resets and limited health data.

## Steps taken
TODO

## Verification
- [ ] VM memory raised and confirmed on the TrueNAS dashboard
- [ ] VM CPU type set to `host`
- [ ] New pool `tank` online, no errors
- [ ] Datasets and properties confirmed
- [ ] Snapshot task and scrub schedule confirmed
- [ ] SMB shares reachable, users and permissions tested

## Evidence
- `evidence/02-truenas-observed-state.txt`
