# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Intel IXGBE NIC Virtual Function Driver"
HOMEPAGE="https://www.intel.com/content/www/us/en/support/articles/000005688/network-and-i-o/ethernet-products.html"
SRC_URI="https://downloadmirror.intel.com/18700/eng/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES="${FILESDIR}/${PN}-noman.patch"


src_install() {
	dodoc README
	doman ${PN}.7
	insinto /usr/src/driver/${PN}
	doins src/*
}

