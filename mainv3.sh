#! /bin/bash

set -e

VERSION="$(date '+%Y%m%d').git"

export DEBIAN_FRONTEND="noninteractive"
export DEB_BUILD_MAINT_OPTIONS="optimize=+lto -march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32"
export DEB_CFLAGS_MAINT_APPEND="-march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32"
export DEB_CPPFLAGS_MAINT_APPEND="-march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32"
export DEB_CXXFLAGS_MAINT_APPEND="-march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32"
export DEB_LDFLAGS_MAINT_APPEND="-march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32"
export DEB_BUILD_OPTIONS="nocheck notest terse"
export DPKG_GENSYMBOLS_CHECK_LEVEL=0

# Clone Upstream
#git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/
git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/ -b main --depth 1
cp -rvf ./debian ./linux-firmware/
cp -rvf ./ath12k ./linux-firmware/
cd ./linux-firmware
touch debian/changelog
echo -e "linux-firmware ("$VERSION"-101pika1) canary; urgency=medium\n\n  * New Upstream Release\n\n -- Ward Nakchbandi <hotrod.master@hotmail.com> Sat, 01 Oct 2022 14:50:00 +0200" > debian/changelog

# Get build deps
apt-get build-dep ./ -y

# Build package
LOGNAME=root dh_make --createorig -y -l -p linux-firmware_"$VERSION" || echo "dh-make: Ignoring Last Error"
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
