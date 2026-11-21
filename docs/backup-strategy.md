# Backup strategy

## Decision
No separate backup is kept. This is deliberate.

## Reasoning (author's)
- The NAS is a transfer point between devices and a place for convenience copies. The author keeps the originals of anything important on a PC, laptop or phone.
- Rule in force: **the NAS never holds the only copy of anything.** Anything irreplaceable is also held on another device.

## What protects the data, and what does not
| Risk | Protected? | How |
|---|---|---|
| Accidental deletion or overwrite | Yes | Daily snapshots: `shared` for 2 weeks, `private` for 1 month |
| Silent corruption | Detected | ZFS checksums and scheduled scrubs |
| Disk failure | No | Single disk, no redundancy; data on the NAS would be lost |
| Theft, fire, power surge | No | One machine, one location |
| Camera footage | Partly | Each camera keeps its own SD card |

## Not claimed
This setup does not meet the 3-2-1 rule (three copies, two media, one off-site) and is not described as doing so.

## When to revisit
If anything irreplaceable is ever stored only on the NAS, add a second drive or an encrypted off-site copy first.
