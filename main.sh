#! /bin/bash
# Add dependent repositories
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
add-apt-repository https://ppa.pika-os.com
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports
# Clone Upstream
#git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/
git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/ -b 20230515
cp -rvn ./debian-firmware/* ./linux-firmware/
cd ./linux-firmware
touch debian/changelog
#echo -e "linux-firmware ("$(date '+%Y%m%d')".git-99pika"$(date '+%M')") lunar; urgency=medium\n\n  * New Upstream Release\n\n -- Ward Nakchbandi <hotrod.master@hotmail.com> Sat, 01 Oct 2022 14:50:00 +0200" > debian/changelog
echo -e "linux-firmware (20230515.git-99pika"$(date '+%M')") lunar; urgency=medium\n\n  * New Upstream Release\n\n -- Ward Nakchbandi <hotrod.master@hotmail.com> Sat, 01 Oct 2022 14:50:00 +0200" > debian/changelog

# Get build deps
apt-get build-dep ./ -y

# Build package
#LOGNAME=root dh_make --createorig -y -l -p linux-firmware_"$(date '+%Y%m%d')".git || echo "dh-make didn't go clean"
LOGNAME=root dh_make --createorig -y -l -p linux-firmware_20230515.git || echo "dh-make didn't go clean"
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
