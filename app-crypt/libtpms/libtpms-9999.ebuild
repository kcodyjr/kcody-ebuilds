# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ $PV == 9999 ]]
then
	EGIT_REPO_URI="https://github.com/stefanberger/${PN}.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-git"
	S="${WORKDIR}/${PN}-git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI=""
fi


inherit flag-o-matic

DESCRIPTION="Software TPM Library"
HOMEPAGE="https://sourceforge.net/stefanberger/libtpms"

LICENSE="GPL-2"

SLOT="0"

IUSE="ssl hardened"

RDEPEND="
		ssl? ( dev-libs/openssl:0= )
		!ssl? ( dev-libs/nss:0= )
	"
DEPEND="${RDEPEND}"

src_prepare() {
	"${S}/bootstrap.sh"
	eapply_user
}

src_configure() {
	local myconf=""

	if use ssl
	then
		myconf="${myconf} --with-openssl"
	fi

	if use hardened
	then
		myconf="${myconf} --with-pic"
	fi

	econf ${myconf}

}

