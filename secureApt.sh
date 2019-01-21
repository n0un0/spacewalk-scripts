#!/bin/bash
#
# Creates the Release and Release.gpg files for APT repo
# based on Packages and Packages.gz files
# The created files make the repo a "signed" repo

if [ "$1" = "" -o "$2" = "" ]; then echo "Usage: secureApt.sh DIST SUITE";exit 1;fi

DATE=`date -Ru`
GPG_PASS='foobar'

HEADER="Origin: Debian
Label: Debian
Suite: $2
Version: 9.6
Codename: $1
Date: ${DATE}
Architectures: amd64
Components: repodata
Description: Debian Stretch 9.6
MD5Sum:"

PACKAGES_MD5=($(md5sum Packages))
PACKAGES_SIZE=$(stat -c%s Packages)
PACKAGESGZ_MD5=($(md5sum Packages.gz))
PACKAGESGZ_SIZE=$(stat -c%s Packages.gz)
PACKAGES_SHA256=($(sha256sum Packages))
PACKAGESGZ_SHA256=($(sha256sum Packages.gz))

# write Release file with MD5s
rm -rf Release
echo -e "${HEADER}" > Release
echo -e " ${PACKAGES_MD5}\t${PACKAGES_SIZE}\trepodata/binary-amd64/Packages" >> Release
echo -e " ${PACKAGESGZ_MD5}\t${PACKAGESGZ_SIZE}\trepodata/binary-amd64/Packages.gz" >> Release
echo -e " ${PACKAGES_MD5}\t${PACKAGES_SIZE}\trepodata/binary-i386/Packages" >> Release
echo -e " ${PACKAGESGZ_MD5}\t${PACKAGESGZ_SIZE}\trepodata/binary-i386/Packages.gz" >> Release
echo -e "SHA256:" >> Release
echo -e " ${PACKAGES_SHA256}\t${PACKAGES_SIZE}\trepodata/binary-amd64/Packages" >> Release
echo -e " ${PACKAGESGZ_SHA256}\t${PACKAGESGZ_SIZE}\trepodata/binary-amd64/Packages.gz" >> Release
echo -e " ${PACKAGES_SHA256}\t${PACKAGES_SIZE}\trepodata/binary-i386/Packages" >> Release
echo -e " ${PACKAGESGZ_SHA256}\t${PACKAGESGZ_SIZE}\trepodata/binary-i386/Packages.gz" >> Release

# write the signature for Release file
rm -rf Release.gpg
echo $GPG_PASS | gpg --armor --detach-sign -o Release.gpg --batch --no-tty --digest-algo SHA256 --passphrase-fd 0 --sign Release
