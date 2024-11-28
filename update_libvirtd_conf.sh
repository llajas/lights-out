#!/bin/bash

CONFIG_FILE="/etc/libvirt/libvirtd.conf"
SETTING="listen_addr = \"0.0.0.0\""
COMMENT="# Added by update_libvirtd_conf.sh for Terraform/Unraid"

# Check if the configuration file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: $CONFIG_FILE does not exist."
    exit 1
fi

# Check if the setting is already set
if grep -Fxq "$SETTING" "$CONFIG_FILE"; then
    echo "The setting '$SETTING' is already configured in $CONFIG_FILE."
else
    # Add the setting and a comment if it doesn't exist
    echo "Adding the setting '$SETTING' to $CONFIG_FILE..."
    {
        echo ""
        echo "$COMMENT"
        echo "$SETTING"
    } >> "$CONFIG_FILE"
    echo "Setting added successfully."
fi

# Check if libvirtd needs to be restarted
echo "Restarting libvirtd to apply changes..."
if systemctl restart libvirtd; then
    echo "libvirtd restarted successfully."
else
    echo "Error: Failed to restart libvirtd. Please check your system configuration."
    exit 1
fi

# Confirm the setting is in place
echo "Verification:"
grep -A1 "$COMMENT" "$CONFIG_FILE"

