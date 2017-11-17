# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

#inherit python-r1

DESCRIPTION="ioprocess library"
HOMEPAGE="http://www.ovirt.org"
LICENSE="Apache-2.0"
SLOT="0"


if [[ ${PV} = *9999* ]]
then
	inherit git-r3
	EGIT_REPO_URI="git://gerrit.ovirt.org/ioprocess"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://resources.ovirt.org/pub/src/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

RDEPEND="virtual/pkgconfig
dev-lang/python
dev-libs/glib"
DEPEND="${RDEPEND}"

#pkg_setup() {
#	python_setup
#}

#src_prepare() {
#	sed -i '/pthreading/d' configure.ac # until we have pthreading it tree
#	eautoreconf
#}

#src_configure() {
#	econf \
#		$(use selinux || echo --disable-libvirt-selinux) \
#		--localstatedir=/var

#}

src_test() {
	# the syntax checking in Gentoo is newer than fedora
	# so we disable it for now
	emake -C tests check
}

#src_install() {
#	default
#	python_replicate_script "${ED}/usr/bin/vdsm-tool"
#}
