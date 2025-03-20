#!/bin/bash

# Default values
SOURCE_ENDPOINT="be16a1ce-46be-4e22-ab87-63274761dac4"
SOURCE_PATH="gjgpb9/cortex_modeling/test"
DEST_ENDPOINT="38ea6966-f500-11ed-9a79-83ef71fbf0ae"
DEST_PATH="~/test/"
RECURSIVE=true
LABEL="Folder Transfer $(date '+%Y-%m-%d')"

# Function to display usage
usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -s, --source-endpoint ENDPOINT_ID     Source endpoint ID"
    echo "  -p, --source-path PATH                Source path"
    echo "  -d, --dest-endpoint ENDPOINT_ID       Destination endpoint ID"
    echo "  -t, --dest-path PATH                  Destination path"
    echo "  -n, --no-recursive                    Disable recursive transfer"
    echo "  -l, --label TEXT                      Custom label for transfer"
    echo "  -h, --help                            Display this help message"
    echo ""
    echo "Example:"
    echo "  $0 -s SourceEndpointID -p /path/to/source -d DestEndpointID -t /path/to/dest -l \"My Transfer\""
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -s|--source-endpoint)
            SOURCE_ENDPOINT="$2"
            shift 2
            ;;
        -p|--source-path)
            SOURCE_PATH="$2"
            shift 2
            ;;
        -d|--dest-endpoint)
            DEST_ENDPOINT="$2"
            shift 2
            ;;
        -t|--dest-path)
            DEST_PATH="$2"
            shift 2
            ;;
        -n|--no-recursive)
            RECURSIVE=false
            shift
            ;;
        -l|--label)
            LABEL="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validation
if [[ -z "$SOURCE_ENDPOINT" || -z "$SOURCE_PATH" || -z "$DEST_ENDPOINT" || -z "$DEST_PATH" ]]; then
    echo "Error: Missing required parameters"
    usage
fi

echo "Starting Globus transfer..."
echo "From: $SOURCE_ENDPOINT:$SOURCE_PATH"
echo "To:   $DEST_ENDPOINT:$DEST_PATH"
echo "Recursive: $RECURSIVE"
echo "Label: $LABEL"

# Activate endpoints
echo "Activating endpoints..."
globus endpoint activate "$SOURCE_ENDPOINT"
globus endpoint activate "$DEST_ENDPOINT"

# Build transfer command
TRANSFER_CMD="globus transfer \"$SOURCE_ENDPOINT:$SOURCE_PATH\" \"$DEST_ENDPOINT:$DEST_PATH\" --label \"$LABEL\""

if [[ "$RECURSIVE" == "true" ]]; then
    TRANSFER_CMD="$TRANSFER_CMD --recursive"
fi

# Execute the transfer
echo "Executing transfer command..."
eval $TRANSFER_CMD

echo "Transfer submitted. Check the Globus web interface or use 'globus task list' to monitor status."