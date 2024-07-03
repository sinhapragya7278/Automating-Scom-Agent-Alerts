# SCOM Not Responding Script

![PowerShell](https://img.shields.io/badge/language-PowerShell-blue.svg)

This PowerShell script checks the status of the SCOM service on a remote server and performs troubleshooting steps if needed.

## Description

The script performs the following tasks:
1. Checks the ping status of the server.
2. If the server is reachable, it attempts to connect via RDP.
3. Once connected, it checks the status of the "Microsoft Monitoring Agent" service.
4. If the service is running, the ticket is closed.
5. If the service is not running, it attempts to start the service.
6. If the service starts successfully, the ticket is closed.
7. If the service fails to start, it assigns the issue to the Windows team and updates the worknotes.

## How to Use

1. **Clone the Repository:**
   ```sh
   git clone https://github.com/your-username/your-repository-name.git
   cd your-repository-name
