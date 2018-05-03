# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ $PV == 9999 ]]
then
	EGIT_REPO_URI="https://github.com/stefanberger/swtpm.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-git"
	S="${WORKDIR}/${PN}-git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI=""
fi


inherit flag-o-matic user udev

#MY_P=${P/-/_}
DESCRIPTION="Software TPM Provider"
HOMEPAGE="https://sourceforge.net/stefanberger/swtpm"

LICENSE="GPL-2"

SLOT="0"

IUSE="gnutls ssl +cuse selinux hardened"

RDEPEND="
		ssl? ( dev-libs/openssl:0= )
		gnutls? ( dev-libs/gnutls:0= )
		!ssl? ( !gnutls? ( dev-libs/nss:0= ) )
		app-crypt/libtpms
		dev-tcltk/expect
		net-misc/socat
		app-crypt/tpm-tools
	"
DEPEND="${RDEPEND}"
#DEPEND="${RDEPEND}
#	!ssl? ( dev-libs/gmp )"

TSSUSER="swtpm"
TSSGROUP="swtpm"
TSSHOME="/var/lib/swtpm"
TSSLOGS="/var/log/swtpm"

#S=${WORKDIR}/${P/-/_}

pkg_setup() {
	enewgroup "$TSSGROUP"
	enewuser "$TSSUSER" -1 -1 "$TSSHOME" "$TSSGROUP"
}

src_prepare() {
	"${S}/bootstrap.sh"
	eapply_user
}

src_configure() {
	local myconf=""

	if use gnutls
	then
		myconf="--with-gnutls"

	elif use ssl
	then
		myconf="--with-openssl"
	fi

	if use cuse
	then
		myconf="${myconf} --with-cuse"
	fi

	if use selinux
	then
		myconf="${myconf} --with-selinux"
	fi

	if use hardened
	then
		myconff="${myconf} --with-pic"
	fi

	econf ${myconf}						\
		"--with-tss-user=${TSSUSER}"	\
		"--with-tss-group=${TSSGROUP}"

}

src_install() {

	emake DESTDIR="${D}" install

	dodoc README

#	udev_newrules "${BUILD_DIR}/tpmd_dev/linux/tpmd_dev.rules" 60-tpmd_dev.rules
#
#	newinitd "${FILESDIR}"/${PN}.initd-0.7.4 ${PN}
#	newconfd "${FILESDIR}"/${PN}.confd-0.7.4 ${PN}

	keepdir "$TSSHOME"
	fowners "${TSSUSER}:${TSSGROUP}" "$TSSHOME"

	keepdir "$TSSLOGS"
	fowners "${TSSUSER}:${TSSGROUP}" "$TSSLOGS"

}
