# Lab Design

## Site 1

- 4 Virtual Networks
  - A Virtual Network for the VPN & Private DNS Resolver using prefixes
    - 192.168.100.0/24 for the VPN
    - 192.168.101.0/24 for the Private DNS Resolver
  - A Virtual Network for the SQL Server in the east region using prefixes
    - 192.168.110.0/24 for the SQL Server
  - A Virtual Network for the SQL Server in the west region using prefixes
    - 192.168.120.0/24 for the SQL Server
  - A Virtual Network for VMs using prefixes
    - 192.168.200.0/24 for the VMs

## Site 2

- 3 Virtual Networks
  - A Virtual Network for the VPN using prefixes
    - 10.0.100.0/24 for the VPN
  - A Virtual Network for the SQL Server using prefixes
    - 10.0.110.0/24 for the SQL Server
  - A Virtual Network for VMs using prefixes
    - 10.0.200.0/24 for the VMs
