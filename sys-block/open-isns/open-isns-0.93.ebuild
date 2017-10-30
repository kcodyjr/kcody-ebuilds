# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/open-iscsi/open-iscsi-2.0.873.ebuild,v 1.1 2013/10/11 20:08:09 idl0r Exp $

EAPI=5

#inherit versionator linux-info eutils flag-o-matic toolchain-funcs
inherit versionator eutils flag-o-matic toolchain-funcs

DESCRIPTION="iSCSI Name Service Daemon"
HOMEPAGE="http://www.open-iscsi.org/"
SRC_URI="http://www.open-iscsi.org/bits/$PN-$PV.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug slp"

DEPEND="slp? ( net-libs/openslp )"
RDEPEND="${DEPEND}
	sys-apps/util-linux"


src_configure() {

	# SSL (--with-security) is broken
	econf $(use_with slp) \
		--without-security

}

src_install() {

	dosbin isnsadm isnsd

	insinto /etc/isns
	doins etc/isnsd.conf
	doins etc/isnsadm.conf

	keepdir /var/lib/isns
	fperms 700 /var/lib/isns

	newinitd "${FILESDIR}"/isnsd-init.d isnsd

	dodoc README TODO HACKING
	dodoc isnssetup
	dodoc doc/rfc*.txt
	doman doc/*.5 doc/*.8

}

pkg_postinst() {

	if ! getent services isns >/dev/null ; then
		elog "Adding isns 3205/tcp to /etc/services"
		echo -e "isns\t\t3205/tcp" >> /etc/services
	fi

}

pkg_config() {

	true # FIXME: implement

	# abort if keys exist

	# run --init if we built with security

}

