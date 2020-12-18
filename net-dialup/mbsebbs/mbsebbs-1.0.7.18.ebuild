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
acct-group/bbs
acct-group/mbse
acct-user/bbs
acct-user/mbse
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
media-gfx/imagemagick
net-dialup/lrzsz
net-misc/telnet-bsd
sys-apps/xinetd
sys-libs/zlib
geoip? ( dev-libs/geoip )
!geoip? ( !dev-libs/geoip )"
RDEPEND="${DEPEND}"
BDEPEND=""

export MBSE_ROOT="/opt/mbse"

src_prepare() {
	default
	eautoreconf
}

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

	${ECONF_SOURCE:-.}/configure \
		$my_build \
		$my_target \
		--host="${CHOST}" \
		--prefix="$MBSE_ROOT" \
		$(use_enable newsgate)
}

generate_mbse_profile() {
	local file="$1"
	local path="$(dirname "$file")"

	[[ -e $path ]] || mkdir -p "$path"

	cat >>"$file" <<EEOF
export MBSE_ROOT="${MBSE_ROOT}"
export PATH="\${PATH}:\${MBSE_ROOT}/bin"
export GOLDED="\${MBSE_ROOT}/etc"
export COLUMNS LINES
EEOF
}

generate_xinetd_mbse() {
	local file="$1"
	local path="$(dirname "$file")"

	[[ -e $path ]] || mkdir -p "$path"

	cat >>"$file" <<EEOF
#:MBSE BBS services are defined here.
#
# Author: Michiel Broek <mbse@mbse.eu>, 27-Sep-2004
# Modified by: Andrew Leary <ajleary@users.sourceforge.net>, 15-Aug-2020

service binkp
{
>---socket_type>= stream
>---protocol>---= tcp
>---wait>--->---= no
>---user>--->---= mbse
>---instances>--= 10
>---server>->---= ${MBSE_ROOT}/bin/mbcico
>---server_args>= -t ibn
}

service fido
{
>---socket_type>= stream
>---protocol>---= tcp
>---wait>--->---= no
>---user>--->---= mbse
>---instances>--= 10
>---server>->---= ${MBSE_ROOT}/bin/mbcico
>---server_args>= -t ifc
}

service tfido
{
>---socket_type     = stream
>---protocol        = tcp
>---wait            = no
>---user            = mbse
>---instances       = 10
>---server          = ${MBSE_ROOT}/bin/mbcico
>---server_args>= -t itn
}

# Telnet to the bbs using mblogin, disabled by default.
#
service telnet
{
>---disable>>---= yes
>---protocol>---= tcp
>---instances>--= 10
>---flags>-->---= REUSE
>---log_on_failure += USERID
>---socket_type>= stream
>---user>--->---= root
>---server>->---= /usr/sbin/in.telnetd
>---server_args>= -L ${MBSE_ROOT}/bin/mblogin
>---wait>--->---= no
}

EEOF
}


src_install() {
	emake DESTDIR="${D}" install

	dodoc README README.Gentoo FILE_ID.DIZ
	dodoc ChangeLog*
	dodoc docs/*

	mkdir -p "${D}/etc/conf.d"
	echo "MBSE_ROOT=\"${MBSE_ROOT}\"" > "${D}/etc/conf.d/mbsebbs"

	generate_mbse_profile "${D}/home/mbse/.profile"
	generate_xinetd_mbse  "${D}/etc/xinetd.d/mbse"

}

pkg_postinst() {
	usermod -s "${MBSE_ROOT}/bin/mbnewuser" -c "BBS New User" bbs
}

