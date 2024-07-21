#! /bin/bash

VERSION=$(date '+%Y%m%d')

# Clone Upstream
#git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/
git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/ -b main
cp -rvn ./debian-firmware/* ./linux-firmware/
cd ./linux-firmware
touch debian/changelog
echo -e "linux-firmware ("$VERSION".git-101pika1) canary; urgency=medium\n\n  * New Upstream Release\n\n -- Ward Nakchbandi <hotrod.master@hotmail.com> Sat, 01 Oct 2022 14:50:00 +0200" > debian/changelog

# Get build deps
apt-get build-dep ./ -y

# Build package
LOGNAME=root dh_make --createorig -y -l -p linux-firmware_"$VERSION".git || echo "dh-make didn't go clean"
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
