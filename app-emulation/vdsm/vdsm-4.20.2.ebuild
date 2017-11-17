# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-r1 autotools

DESCRIPTION="Virtual desktop server manager"
HOMEPAGE="http://www.ovirt.org"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="abrt containers glusterfs imageio numa openvswitch selinux"

if [[ ${PV} = *9999* ]]
then
	inherit git-r3
	EGIT_REPO_URI="git://gerrit.ovirt.org/vdsm"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://resources.ovirt.org/pub/src/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

HDEPEND="
	dev-libs/openssl
	dev-lang/python
	dev-python/cpopen
	dev-python/python-six
	dev-python/python-dateutil
	dev-python/pyyaml
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/gettext
	sys-devel/libtool
"

RDEPEND="
	abrt? ( app-admin/abrt )
	app-admin/logrotate
	app-admin/sudo
	app-arch/rpm[python]
	app-arch/tar
	app-arch/xz-utils
	app-emulation/ioprocess
	app-emulation/libvirt[dbus]
	app-emulation/qemu
	dev-lang/python
	dev-libs/cyrus-sasl
	dev-libs/libnl
	dev-libs/openssl
	dev-python/libvirt-python
	dev-python/pyyaml
	dev-python/cpopen
	dev-python/python-dateutil
	dev-python/dbus-python
	dev-python/decorator
	dev-python/netaddr
	dev-python/pyinotify
	dev-python/pthreading
	dev-python/requests
	dev-python/ipaddress
	dev-python/six
	net-fs/nfs-utils
	net-misc/bridge-utils
	net-misc/chrony
	net-misc/curl
	net-misc/networkmanager
	openvswitch? ( net-misc/openvswitch )
	x86? ( sys-apps/dmidecode )
	sys-apps/dbus
	sys-apps/ed
	sys-apps/ethtool
	sys-apps/iproute2
	sys-apps/lshw
	sys-apps/net-tools
	sys-apps/policycoreutils
	sys-apps/sed
	selinux? ( sys-apps/selinux-python )
	sys-apps/which
	sys-auth/polkit
	sys-block/open-iscsi
	glusterfs? ( sys-cluster/glusterfs )
	sys-cluster/sanlock[python]
	sys-fs/dosfstools
	sys-fs/e2fsprogs
	sys-fs/lvm2
	sys-fs/multipath-tools
	numa? ( sys-process/numactl )
	sys-process/procps
	sys-process/psmisc
	virtual/cdrtools
	virtual/shadow
	virtual/udev
"

#RDEPEND="
#	dev-python/cherrypy
#	dev-python/m2crypto
#	dev-python/nose
#	dev-python/pyflakes
#	dev-python/pyparted
#	dev-python/python-ethtool
#	net-misc/rsync
#	net-misc/wget
#	sys-apps/util-linux
#"
#	/usr/sbin/persist
#	/usr/sbin/unpersist
#	/sbin/vconfig -> should be replaced with iproute
#	/bin/systemctl
#	/sbin/grubby -> obosolete
#	/usr/sbin/fence_ilo
#	yum?
#	rpm?
#DEPEND="${RDEPEND}
#	dev-python/cheetah
#	dev-python/nose
#	dev-python/pep8"

DEPEND="${HDEPEND}"

pkg_setup() {
	python_setup
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--enable-hooks    \
		$(use containers  && echo --enable-containers)       \
		$(use gluster     || echo --disable-gluster-mgmt)    \
		$(use imageio     || echo --disable-ovirt-imageio)   \
		$(use openvswitch || echo --disable-openvswitch)     \
		$(use selinux     || echo --disable-libvirt-selinux) \
		--with-polkitdir=${EPREFIX}/etc/polkit-1/rules.d     \
		--localstatedir=${EPREFIX}/var

}

src_test() {
	# the syntax checking in Gentoo is newer than fedora
	# so we disable it for now
	emake -C tests check
}

src_install() {
	default
	python_replicate_script "${ED}/usr/bin/vdsm-tool"
}

