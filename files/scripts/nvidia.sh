#!/usr/bin/env bash
set -euo pipefail

#-------------------------------------# 
# Uncomment nvidia specific variables #
#-------------------------------------# 
# Target file (replace with the correct path)
file="/etc/skel/.config/hypr/env.conf"

# Uncomment specific NVIDIA-related environment variable lines
sed -i '/#.*env = LIBVA_DRIVER_NAME,nvidia/s/^#\s*//;
        /#.*env = GBM_BACKEND,nvidia-drm/s/^#\s*//;
        /#.*env = __GLX_VENDOR_LIBRARY_NAME,nvidia/s/^#\s*//;
        /#.*env = NVD_BACKEND,direct/s/^#\s*//' "$file"

echo "Lines successfully uncommented in $file"
#---------------------------------------------------------------------------------------#

#----------------------------#
# set Nvidia toolkit policy) #
#----------------------------#
semodule --verbose --install /usr/share/selinux/packages/nvidia-container.pp

#---------------------------------------------------------------------------------------#

#-------------------#
# set early loading #
#-------------------#
sed -i 's@omit_drivers@force_drivers@g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf
sed -i 's@ nvidia @ i915 amdgpu nvidia @g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf

#---------------------------------------------------------------------------------------#

#---------------#
# DRM Variables #
#---------------#
echo '

# Nvidia modesetting support. Set to 0 or comment to disable kernel modesetting
# support. This must be disabled in case of SLI Mosaic.

options nvidia-drm modeset=1 fbdev=1

' > /usr/lib/modprobe.d/nvidia-modeset.conf

cp /usr/lib/modprobe.d/nvidia-modeset.conf /etc/modprobe.d/nvidia-modeset.conf
