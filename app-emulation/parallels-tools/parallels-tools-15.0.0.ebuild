# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

NREL="46967"
MYPV="${PV}.${NREL}"

DESCRIPTION="Parallels Tools for Linux"
HOMEPAGE="http://www.parallels.com"
SRC_URI="prl_tools-${MYPV}.tar.gz
prl_tools_inst-${MYPV}.tar.gz
prl_mod-${MYPV}.tar.gz"
RESTRICT="fetch"

LICENSE="" # FIXME proprietary
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X gnome selinux systemd selinux"

# FIXME which depends on which???
DEPEND="app-portage/gentoolkit"
RDEPEND="${DEPEND} sys-kernel/dkms"

S="${WORKDIR}"

if [[ $ARCH == amd64 ]]
then
	TOOLSDIR="${S}/tools/tools64"
	XMODSDIR="/usr/lib64/xorg/modules"

elif [[ $ARCH == x86 ]]
then
	TOOLSDIR="${S}/tools/tools32"
	XMODSDIR="/usr/lib32/xorg/modules"

else
	echo "ERROR: unsupported architecture $ARCH"
	exit 1
fi

src_unpack() {

	mkdir "${S}/kmods"
	cd "${S}/kmods"
	tar xf "../../distdir/prl_mod-${MYPV}.tar.gz"

	mkdir "${S}/tools"
	cd "${S}/tools"
	tar xf "../../distdir/prl_tools-${MYPV}.tar.gz"

	mkdir "${S}/installer"
	cd "${S}/installer"
	tar xf "../../distdir/prl_tools_inst-${MYPV}.tar.gz"

}

src_compile() {
	sed -i 's/ = / == /' "${S}/kmods/dkms.conf"
	sed -i 's/ \]/ \]\]/' "${S}/kmods/dkms.conf"
	sed -i 's/ \[ / \[\[ /' "${S}/kmods/dkms.conf"
}

_do_install_kmods() {
	MODSRC="${ED}/usr/src/${PN}-${PVR}"
	mkdir -p "$MODSRC"
	rsync -a "${S}/kmods/" "$MODSRC"
}

_do_install_tools_openrc() {
	newinitd "${FILESDIR}/prltoolsd-openrc" 'prltoolsd'
}

_do_install_tools_systemd() {
	true
}

_do_install_tools_base() {

	cd "${TOOLSDIR}/bin"
	dobin prl_showvmcfg prlhosttime prlshprint prlshprof prltimesync prltoolsd prlusmd

	cd "${TOOLSDIR}/sbin"
	dosbin prl_nettool prl_snapshot prltools_updater.sh

	use systemd || _do_install_tools_openrc
	use systemd && _do_install-tools_systemd

	# shared folders automount daemon
	newsbin ${S}/tools/prlfsmountd.sh prlfsmountd

	# script library
	insinto /usr/lib/parallels-tools/installer
	doins ${S}/installer/prl-functions.sh

	# power management
	insinto /etc/pm/sleep.d
	doins ${S}/tools/99prltoolsd-hibernate

	# udev rules
	insinto /lib/udev/rules.d
	newins ${S}/tools/parallels-cpu-hotplug.rules 99-parallels-cpu-hotplug.rules
	newins ${S}/tools/parallels-memory-hotplug.rules 99-parallels-memory-hotplug.rules

	# modprobe
	insinto /etc/modprobe.d
	newins "${S}/installer/blacklist-parallels.conf" parallels.conf

	# modules-load
	insinto /etc/modules-load.d
	newins "${FILESDIR}/parallels-modules.conf" parallels.conf

	# manpages
	doman ${S}/tools/mount.prl_fs.8

}

_do_install_tools_xorg() {

	insinto  /usr/share/applications
	doins "${S}/tools/prlcc.desktop" "${S}/tools/ptiagent.desktop"

	insinto /lib/udev/rules.d
	newins "${S}/tools/parallels-video.rules" 99-parallels-video.rules
	newins "${S}/tools/xorg-prlmouse.rules" 69-xorg-prlmouse.rules

	insinto "${XMODSDIR}/drivers"
	doins "${TOOLSDIR}/x-server/modules/drivers/prlvideo_drv.so"
	doins "${TOOLSDIR}/x-org-1.20/x-server/modules/drivers/prlvidel_drv.so"
	doins "${TOOLSDIR}/x-org-1.20/x-server/modules/drivers/prlvidex_drv.so"

	insinto "${XMODSDIR}/input"
	doins "${TOOLSDIR}/x-org-1.20/x-server/modules/input/prlmouse_drv.so"

	dolib "${TOOLSDIR}/x-org-1.20/usr/lib/libglx.so.1.0.0"

}

_do_install_tools_gnome() {
	true
}

src_install() {
	_do_install_kmods
	_do_install_tools_base

	use X     && _do_install_tools_xorg
	use gnome && _do_install_tools_gnome

}

pkg_postinst() {
	dkms add -m "${PN}" -v "${PVR}"
	dkms autoinstall
}

pkg_prerm() {
	dkms remove "${PN}/${PVR}" --all
}

