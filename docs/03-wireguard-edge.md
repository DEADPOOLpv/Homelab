# 3. Cloud edge and WireGuard tunnel

Status: Planned

## Design
Public traffic -> edge VPS -> WireGuard tunnel -> service VM on Proxmox.

## Steps taken
TODO (VPS provider and size, WireGuard addressing scheme using placeholder ranges only, firewall rules).

## Verification
- [ ] Tunnel handshake is recent (`wg show`, addresses and keys blacked out)
- [ ] Only the intended ports are reachable from outside (scan result)
- [ ] Home network is not reachable from the VPS beyond the intended service

## Evidence
TODO: `evidence/03-*`
