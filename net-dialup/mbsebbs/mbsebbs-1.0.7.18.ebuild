# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

filter-flags -O -O1 -O2 -O3 -O0 -Os -Ofast -Og

MY_PV=${PV%.*}

DESCRIPTION="MBSE BBS System"
HOMEPAGE="https://www.mbse.eu"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${MY_PV}/${P}.tar.bz2"

PATCHES=(
"${FILESDIR}/${PN}-1.0.7.18-installinit.patch"
"${FILESDIR}/${PN}-1.0.7.18-openrc.patch"
"${FILESDIR}/${PN}-1.0.7.18-nostrip.patch"
"${FILESDIR}/${PN}-1.0.7.18-cflags.patch"
)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geoip newsgate"

DEPEND="
acct-user/mbse
acct-group/bbs
media-gfx/imagemagick
net-dialup/lrzsz
sys-libs/zlib
app-arch/arc
app-arch/arj
app-arch/bzip2
app-arch/gzip
app-arch/lha
app-arch/ncompress
app-arch/rar
app-arch/tar
app-arch/unarj
app-arch/unzip
app-arch/zip
app-arch/zoo
geoip? ( dev-libs/geoip )
!geoip? ( !dev-libs/geoip )"
RDEPEND="${DEPEND}"
BDEPEND=""

export MBSE_ROOT="/opt/mbse"

src_configure() {
	local my_build
	local my_target

	if [[ -n $CBUILD ]]
	then
		my_build="--build=$CBUILD"
	fi

	if [[ -n $CTARGET ]]
	then
		my_target="--target=$CTARGET"
	fi

	eautoreconf

	${ECONF_SOURCE:-.}/configure \
		$my_build \
		$my_target \
		--host="${CHOST}" \
		--prefix="$MBSE_ROOT" \
		$(use_enable newsgate)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc README README.Gentoo FILE_ID.DIZ
	dodoc ChangeLog*
	dodoc docs/*

	mkdir -p "${D}/etc/conf.d"
	echo "MBSE_ROOT=\"${MBSE_ROOT}\"" > "${D}/etc/conf.d/mbsebbs"

}

