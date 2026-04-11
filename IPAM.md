# IP Address Management (IPAM)

This file tracks the static IP assignments for the homelab network. 
**Gateway:** 192.168.1.1
**Subnet:** 192.168.1.0/24

| IP Address     | Hostname          | OS / Role                | Status      |
|----------------|-------------------|--------------------------|-------------|
| 192.168.1.10   | `control-plane-01` | NixOS (Control Plane)     | Active      |
| 192.168.1.20   | `desktop`         | NixOS (GPU Worker)        | Reserved    |
| 192.168.1.100  | `traefik-lb`      | K8s LoadBalancer (VIP)    | Reserved    |

---

## Reserved Ranges
*   **Infrastructure:** .10 - .50
*   **Service LoadBalancers:** .100 - .150
*   **DHCP Range (Router):** .150 - .254
