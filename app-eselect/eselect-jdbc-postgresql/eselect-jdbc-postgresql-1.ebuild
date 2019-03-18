# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Manages the /usr/share/jdbc-postgresql symlink"
HOMEPAGE="https://www.gentoo.org/"
#SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-admin/eselect-1.0.6
!!<dev-java/jdbc-postgresql-42.0"

src_unpack() {
	mkdir "$S"
}

src_install() {
	insinto /usr/share/eselect/modules
	doins ${FILESDIR}/jdbc-postgresql.eselect || die
}
