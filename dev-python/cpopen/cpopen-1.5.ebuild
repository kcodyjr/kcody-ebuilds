# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
#	EGIT_REPO_URI="git://libvirt.org/libvirt-python.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://resources.ovirt.org/pub/src/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

DESCRIPTION="cpopen python module"
HOMEPAGE="https://ovirt.org"
LICENSE="LGPL-2"
SLOT="0"
IUSE="examples test"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}

python_compile() {
	CPOPEN_VERSION=${PV} esetup.py build
}

python_install() {
	CPOPEN_VERSION=${PV} distutils-r1_python_install
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	CPOPEN_VERSION=${PV} distutils-r1_python_install_all
}
