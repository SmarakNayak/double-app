#!/usr/bin/env bash
set -e

AVD_NAME="pixel_8"

# Check if AVD already exists
if avdmanager list avd | grep -q "Name: $AVD_NAME"; then
  exit 0
fi

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
  SYSTEM_IMAGE="system-images;android-35;google_apis;arm64-v8a"
else
  SYSTEM_IMAGE="system-images;android-35;google_apis;x86_64"
fi

echo "Creating AVD '$AVD_NAME' with $SYSTEM_IMAGE..."
avdmanager create avd -n "$AVD_NAME" -k "$SYSTEM_IMAGE" -d pixel_8
