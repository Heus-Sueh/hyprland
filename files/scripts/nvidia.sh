#!/usr/bin/env bash
set -euo pipefail

# Target file (replace with the correct path)
file="/etc/skel/.config/hypr/env.conf"

# Uncomment specific NVIDIA-related environment variable lines
sed -i '/#.*env = LIBVA_DRIVER_NAME,nvidia/s/^#\s*//;
        /#.*env = GBM_BACKEND,nvidia-drm/s/^#\s*//;
        /#.*env = __GLX_VENDOR_LIBRARY_NAME,nvidia/s/^#\s*//;
        /#.*env = NVD_BACKEND,direct/s/^#\s*//' "$file"

echo "Lines successfully uncommented in $file"
