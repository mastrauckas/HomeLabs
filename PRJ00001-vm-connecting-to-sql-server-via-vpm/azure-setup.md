# How to setup VPN

1. Create a Resource Group.
   - Name `vpn-testing`.
2. Create a Virtual Network.
   - Name `vpn-network`.
   - 192.168.10.0/24 Address space
   - Delete Subnet after creating this network.
   - Create a Gateway Subnet as network 192.168.200.0/24.
     3 Create a Virtual Network and Subnet.
3. Create a Virtual Network.
   - Name `sql-server-network`.
   - 192.168.250.0/24 Address space.
   - Remove Default Subnet
   - Create a Subnet
     - Name `sql-server-subnet`
     - 192.168.250.0/24 Address space
4. Create a Virtual Network.
   - Name `virtual-machine-network`.
   - 192.168.210.0/24 Address space.
   - Remove Default Subnet
   - Create a Subnet
     - Name `virtual-machines-subnet`
     - 192.168.250.0/24 Address space
5. Create a public IP Address.
   - Name `vpn-ip-address`.
   - Basic
   - Dynamic
6. Create SQL Server
   - Name `maa-sql-server`
7. Create SQL Server Database
   - Name `TestingDatabase`
   - Server `maa-sql-server`
   - Basic DTU
8. Create a Private Endpoint
   - Name `sql-server-private-network`
   - Subnet `sql-server-subnet`
   - Private IP configuration
     - Statically allocate IP address
       - Name `maa-sql-server-static-ip-address`
       - This will also create a private DNS zone.
9. Create a Virtual network gateway (VPN).
   - Name `vpn-tunnel`.
   - SKU Basic.
   - Virtual Network `sql-server-network`.
   - Public IP address name `vpn-ip-address`.
   - Enable active-active mode `Disabled`.
   - Configure BGP `Disabled`.
10. Create a Local Network Gateway.
    - Name `vpn-local`.
    - IP address `75.176.73.70`
    - Address Space(s) `10.0.100.0/24`
11. Create a Connection.
    - Name `vpn-connection`
    - Connection Type `Site to Site(IPSec)`
    - Virtual Network Gateway `vpn-tunnel`
    - Local Network Gateway `vpn-local`
    - Shared Key(PSK) `testing12345$`
12. Create a Virtual Machine
    - Name `my-test-virtual-machine`.
    - Username `michael`
    - Password `testing12345$`.
    - Virtual Network `virtual-machine-network`.
