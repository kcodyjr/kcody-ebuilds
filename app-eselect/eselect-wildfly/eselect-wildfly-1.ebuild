# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Manages the /opt/wildfly symlink"
HOMEPAGE="https://www.gentoo.org/"
#SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=app-admin/eselect-1.0.6"

src_unpack() {
	mkdir "$S"
}

src_install() {
	insinto /usr/share/eselect/modules
	doins ${FILESDIR}/wildfly.eselect || die
}
