# transfer-files

A collection of scripts to help transfer files between different remote servers and endpoints efficiently.

## Table of Contents
1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Simple Rsync Script](#simple-rsync-script)
   - [Using the Script](#using-the-simple-script)
4. [Globus Transfer Script](#globus-transfer-script)
   - [Setup Instructions](#setup-instructions)
   - [Using the Script](#using-the-script)
   - [Troubleshooting](#troubleshooting)
5. [Expanse Transfer Script](#expanse-transfer-script)
   - [Setup Instructions](#setup-instructions-for-expanse)
   - [Using the Script](#using-the-script-for-expanse)
6. [Common Issues](#common-issues)

## Overview

These scripts automate file transfers between different systems:
- `transfer_simple.sh`: Basic rsync script for straightforward file transfers
- `globus_transfer.sh`: Uses Globus CLI to transfer files between Globus endpoints
- `transfer_with_dual_factor.exp`: Uses expect to handle two-factor authentication when transferring to Expanse

## Requirements

- **For simple rsync transfers**:
  - rsync installed on both local and remote systems
  - SSH access to the remote server

- **For Globus transfers**: 
  - Python and pip
  - Globus CLI (`pip install globus-cli`)
  - Active Globus account

- **For Expanse transfers**:
  - `expect` command-line tool
  - SSH access to Expanse
  - Valid credentials with two-factor authentication set up

## Simple Rsync Script

### Using the Simple Script

1. Edit the `transfer_simple.sh` script and update these variables:
   ```bash
   SOURCE_DIR="/local/directory"    # Local directory to transfer
   REMOTE_HOST="user@remote.server" # Remote server address
   REMOTE_DIR="/remote/directory"   # Destination directory on remote server

## Globus Transfer Script

### Setup Instructions

1. Install the Globus CLI:
   ```bash
   pip install globus-cli
   ```

2. Authenticate with Globus:
   ```bash
   globus login --no-local-server
   ```
   Follow the link provided in the output to authenticate in your browser.

3. Find your endpoint IDs:
   ```bash
   globus endpoint search --filter-scope=recently-used
   ```
   If your endpoint isn't listed, perform a transfer via the web app first, then run the command again.

4. Verify endpoint paths:
   ```bash
   globus ls "$SOURCE_ENDPOINT:/"
   ```
   This will show the root directory structure of your endpoint.

### Using the Script
#### for more help on using the script try 
```bash
./globus_transfer.sh --help
```

1. Edit the `globus_transfer.sh` script and update these variables:
   ```bash
   SOURCE_ENDPOINT="be16a1ce-46be-4e22-ab87-63274761dac4" # ID for source endpoint
   SOURCE_PATH="gjgpb9/cortex_modeling/test"  # Path relative to endpoint root
   DEST_ENDPOINT="38ea6966-f500-11ed-9a79-83ef71fbf0ae" # ID for destination endpoint
   DEST_PATH="~/test/" # Path relative to destination endpoint root
   ```

2. Make the script executable:
   ```bash
   chmod +x globus_transfer.sh
   ```

3. Run the script:
   ```bash
   ./globus_transfer.sh
   ```

4. Monitor your transfer:
   ```bash
   globus task list
   ```

### Troubleshooting

- **Session Consent Error**: If you receive a session consent error, run the suggested command:
  ```bash
  globus session consent "LONG_STRING" --no-local-server
  ```
  Follow the link provided in your browser to complete consent.

- **Endpoint Activation**: Ensure both endpoints are activated before transfer:
  ```bash
  globus endpoint activate "ENDPOINT_ID"
  ```

- **Path Issues**: Double-check paths with `globus ls` to ensure they exist and are accessible.

## Expanse Transfer Script

### Setup Instructions for Expanse

1. Ensure you have the `expect` utility installed on your system:
   ```bash
   # On Debian/Ubuntu
   sudo apt-get install expect
   
   # On CentOS/RHEL
   sudo yum install expect
   
   # On macOS with Homebrew
   brew install expect
   ```

2. Make sure you have SSH access to Expanse with two-factor authentication configured.

### Using the Script for Expanse
#### for more help on using the script try 
```bash
./transfer_with_dual_factor.exp --help
```

1. Edit the `transfer_with_dual_factor.exp` script and update these variables:
   ```bash
   set source_dir "../test" # Path relative to the script location
   set user_name "gglick9" # Expanse username 
   set remote_host "@login.expanse.sdsc.edu" # ssh address 
   set remote_dir "~/" # Destination directory absolute path 
   set expected_auth_message "TOTP code for gglick9:" # Exact auth message shown
   ```

2. Make the script executable:
   ```bash
   chmod +x transfer_with_dual_factor.exp
   ```

3. Run the script:
   ```bash
   ./transfer_with_dual_factor.exp
   ```

4. When prompted, enter your two-factor authentication code.

## Common Issues

1. **Globus endpoint not found**: If you can't see your endpoint, try accessing it through the web interface first.

2. **Permission denied**: Ensure you have read permissions on the source and write permissions on the destination.

3. **Connection timeout**: Check that both endpoints are online and accessible.

4. **Authentication failures on Expanse**: Ensure your authentication code is entered correctly and within the time window.

5. **Unexpected authentication prompt**: If the authentication message changes, update the `expected_auth_message` variable in the script.