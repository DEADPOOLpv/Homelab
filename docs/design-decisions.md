# Design decisions

Each entry: decision, alternatives, reason, trade-off. Reasons come from my requirements and from observed constraints of this machine.

## 1. TrueNAS VM, not ZFS directly on the Proxmox host

- **Alternatives:** ZFS on the host with a small file-sharing container.
- **Reason:** the VM already existed and worked, and TrueNAS gives a web interface for users, permissions, snapshots and shares, which is easier to maintain than hand-written configuration for several people and devices.
- **Trade-off:** the VM costs host RAM (4 GiB assigned out of 16 GB) and adds a layer between ZFS and the hardware.

## 2. Pass the whole USB controller to the VM

- **Alternatives:** pass only the one USB device; attach the disk to the host and give the VM a virtual disk.
- **Reason:** the 1 TB disk is USB. Passing controller 00:14.0 (Intel Tiger Lake-LP USB 3.2 xHCI) lets TrueNAS talk to the disk directly, with its own drivers and error handling.
- **Trade-off:** every USB port on that controller belongs to the VM while it runs, so the Proxmox host cannot use them. ZFS over a USB link can still disconnect.

## 3. Web-only administration, SSH off, one administrator account with two-factor login

- **Alternatives:** key-only SSH; a separate non-root administrator.
- **Reason:** I administer everything through the web interface, so SSH is unused surface. Fewer services listening means fewer things to patch and defend.
- **Trade-off:** no remote shell if the web interface breaks, so recovery is at the laptop's own screen and keyboard. A single account has no audit trail separating people or roles.

## 4. Tailscale for private administration, plus a firewall rule

- **Alternatives:** expose the interface to the internet; a self-built WireGuard tunnel.
- **Reason:** nothing is published, and only the owner's authenticated devices can reach port 8006 remotely. The Tailscale account uses two-factor login.
- **Trade-off:** Tailscale is a managed service built on WireGuard; this is not a hand-built tunnel and is not described as one.

## 5. Three datasets and three logins

- **Alternatives:** one shared folder and one login for everything.
- **Reason:** the shared login is known to everyone and every device; the cameras store credentials in a consumer app. Separating `shared`, `private` and `cctv` keeps a leaked or abused login from reaching the private data.
- **Trade-off:** more accounts to manage. Windows allows one login per server at a time, so the owner uses a single personal login that opens all three folders.

## 6. Cameras: SD card plus Mi Home transfer to the NAS

- **Alternatives:** unofficial camera firmware to expose a video stream and record with a separate program.
- **Reason:** the supported path works (both cameras store to `cctv`), keeps the manufacturer's firmware and leaves the SD card as a second copy.
- **Trade-off:** retention and file layout are controlled by the app. The author reports the app deletes old footage itself; this is not independently verified, and a 500 GiB quota caps the folder.

## 7. Snapshots without backups

- **Reason:** snapshots undo accidental deletion and edits. See `backup-strategy.md` for why no separate backup is kept.
- **Trade-off:** snapshots do not protect against disk failure or theft.
