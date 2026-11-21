# Backup strategy

## Current reality
One 1 TB data disk and one SSD in a single machine. ZFS on a single disk gives checksums and snapshots, which protect against corruption detection and accidental deletion, but **not against disk failure or theft**. Snapshots are not backups.

## Do not claim "3-2-1" unless all three hold
- [ ] 3 copies of the data
- [ ] 2 different media
- [ ] 1 copy offsite

## Plan
TODO: choose a second disk or an offsite target, then record the result and a tested restore.
