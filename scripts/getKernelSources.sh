#!/bin/bash
# Get Kernel sources for NVIDIA Jetson NX Xavier
apt-add-repository universe
apt-get update
apt-get install pkg-config -y
# We use 'make menuconfig' to edit the .config file; install dependencies
apt-get install libncurses5-dev -y


echo "Installing kernel sources in: ""$SOURCE_TARGET"
if [ ! -d "$SOURCE_TARGET" ]; then
   # Target directory does not exist; create
   echo "Creating directory: ""$SOURCE_TARGET"
   mkdir -p "$SOURCE_TARGET"
fi

cd "$SOURCE_TARGET"
echo "$PWD"
# L4T Driver Package (BSP) Sources
# For this version, TX2 and AGX Xavier and Xavier NX have the same source files
wget -N https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/sources/t186/public_sources.tbz2

# l4t-sources is a tbz2 file
tar -xvf public_sources.tbz2  Linux_for_Tegra/source/public/kernel_src.tbz2 --strip-components=3
tar -xvf kernel_src.tbz2
# Space is tight; get rid of the compressed kernel source
rm -r kernel_src.tbz2
cd kernel/kernel-4.9
# Copy over the module symbols
# These should be part of the default rootfs
# When the kernel itself is compiled, it should generate its own Module.symvers and place it here
cp /usr/src/linux-headers-4.9.253-tegra-ubuntu18.04_aarch64/kernel-4.9/Module.symvers .
# Go get the current kernel config file; this becomes the base system configuration
zcat /proc/config.gz > .config
# Make a backup of the original configuration
cp .config config.orig
# Default to the current local version
KERNEL_VERSION=$(uname -r)
# For L4T 32.6.1 the kernel is 4.9.253-tegra ; 
# Everything after '4.9.253' is the local version
# This removes the suffix
LOCAL_VERSION=${KERNEL_VERSION#$"4.9.253"}
# Should be "-tegra"
bash scripts/config --file .config \
	--set-str LOCALVERSION $LOCAL_VERSION

