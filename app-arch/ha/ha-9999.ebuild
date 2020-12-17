# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="HA archiver"
HOMEPAGE="https://github.com/l-4-l/ha"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"

EGIT_REPO_URI="https://github.com/l-4-l/ha"
EGIT_BRANCH="master"
EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-git"
S="${WORKDIR}/${PN}-git"

src_prepare() {
	default
	cp "${FILESDIR}/makefile" "${S}"
}

src_install() {
	dobin ha
	dodoc README info.txt
}

