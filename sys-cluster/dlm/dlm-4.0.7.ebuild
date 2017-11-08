# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit linux-info

DESCRIPTION="Distributed Locking Manager"
HOMEPAGE="https://pagure.org/dlm"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

RDEPEND="sys-libs/zlib
	dev-libs/icu
	dev-libs/libxml2
	>=sys-cluster/corosync-2.0.0
	>=sys-cluster/pacemaker-1.1.0"

DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	virtual/pkgconfig"

pkg_pretend() {

	if ! linux_config_exists
	then
		ewarn No kernel config detected. Unable to check options.
	fi

	if ! linux_chkconfig_present CONFIG_DLM
	then
		ewarn CONFIG_DLM not set.
		ewarn You will need to enable it to use DLM.
	fi

}

src_unpack() {
	unpack ${A}
	cd "${S}"
	use systemd || epatch "${FILESDIR}/dlm-nosystemd.patch"
	epatch_user
}

src_prepare() {
	true
}

src_configure() {
	true
}

src_compile() {
	emake
}

src_install() {
	default

	# clean up rules location
	mv ${D}/usr/lib ${D}

}
