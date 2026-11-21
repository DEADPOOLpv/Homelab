# Threat model

| Asset | Threat | Control | Tested? |
|---|---|---|---|
| Home network | Direct exposure from the internet | Only the edge VPS is public; tunnel is the only path in | |
| Proxmox web UI | Credential attack | LAN/tunnel only, 2FA | |
| Stored files | Disk failure, accidental deletion | ZFS snapshots, backups | |
| Stored files | Interception on the LAN | SMB3 encryption (negotiated; camera traffic may be unencrypted) | |
| Personal documents | Another user or device reading them | Separate encrypted `private` dataset, one login only | |
| Camera account | A compromised camera reaching other data | Camera login can open `cctv` only | |
| Edge VPS | Port scanning, brute force | Firewall, key-only SSH | |

Fill the last column with a real test or leave it blank.
