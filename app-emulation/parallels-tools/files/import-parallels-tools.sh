#!/bin/bash

# This script imports the contents of the Parallels Tools ISO
# and puts them in DISTFILES where an ebuild can work with them.

CDROM_MOUNTPOINT=/mnt/cdrom
DISTDIR=/var/cache/portage/distfiles

VERSIONFILE="${CDROM_MOUNTPOINT}/version"


###############################################################################
# check that we have the tools image mounted

if [[ ! -d $CDROM_MOUNTPOINT ]]
then
	echo "Mount point not present."
	exit 1
fi

if [[ ! -e $VERSIONFILE ]]
then
	echo "Parallels Tools ISO is not mounted."
	exit 1
fi

VERSION="$(cat "$VERSIONFILE")"

if [[ -z $VERSION ]]
then
	echo "Unable to retrieve version string from Parallels Tools ISO."
	exit 1
fi


###############################################################################
# get the kernel modules source

KMODFILE="${DISTDIR}/prl_mod-${VERSION}.tar.gz"

cp "${CDROM_MOUNTPOINT}/kmods/prl_mod.tar.gz" "$KMODFILE"


###############################################################################
# get the userspace tools

TOOLFILE="${DISTDIR}/prl_tools-${VERSION}.tar.gz"

tar c -C "${CDROM_MOUNTPOINT}/tools" -zf "$TOOLFILE" .


###############################################################################
# get the installer components

INSTFILE="${DISTDIR}/prl_tools_inst-${VERSION}.tar.gz"

tar c -C "${CDROM_MOUNTPOINT}/installer" -zf "$INSTFILE" .


exit 0

	for file in $FILES_KMOD
	do
		rsync -ru $CDROM_MOUNTPOINT/kmods/$file $DISTDIR/
	done
	for file in $FILES_TOOLS
	do
		rsync -ru --progress $CDROM_MOUNTPOINT/tools/$files $DISTDIR/
	done
	for file in $FILES_INSTALLER
	do
		rsync -ru $CDROM_MOUNTPOINT/installer/$files $DISTDIR/
	done

