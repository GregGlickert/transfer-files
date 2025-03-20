#!/bin/bash

# Simple bash script to make transferring files easy. Not really needed but can make using rsync a bit easier 

# Default values
SOURCE_DIR="/local/directory"
REMOTE_HOST="user@remote.server"
REMOTE_DIR="/remote/directory"

# Process command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --source)
            SOURCE_DIR="$2"
            shift 2
            ;;
        --host)
            REMOTE_HOST="$2"
            shift 2
            ;;
        --dest)
            REMOTE_DIR="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $(basename "$0") [options]"
            echo "Options:"
            echo "  --source DIR       Source directory (default: '/local/directory')"
            echo "  --host HOSTNAME    Remote hostname (default: 'user@remote.server')"
            echo "  --dest DIR         Destination directory on remote host (default: '/remote/directory')"
            echo "  --help             Display this help message"
            echo "Example:"
            echo "  $(basename "$0") --source ./data --host user@remote.server --dest ~/projects"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Start the rsync process
rsync -avz "$SOURCE_DIR" "$REMOTE_HOST":"$REMOTE_DIR"
