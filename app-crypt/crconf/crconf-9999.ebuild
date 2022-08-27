# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

#if [[ $PV != 9999 ]]
#then
#	KEYWORDS="~amd64 ~x86"
#else
	EGIT_REPO_URI="https://github.com/Thermi/crconf"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-git"
	inherit git-r3
	S="${WORKDIR}/${PN}-git"
#fi

DESCRIPTION="crconf linux kernel crypto config utility"

SLOT="0"
IUSE=""

RDEPEND="net-libs/libmnl
"

DEPEND="${RDEPEND}
"

src_prepare() {
	true
}

src_install() {

	dobin src/crconf
	doman man/man8/crconf.8
}

