# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="http://127.0.0.1/null.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}-3.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

DESCRIPTION="pthreading python module"
HOMEPAGE="http://pypi.python.org"
LICENSE="LGPL-2"
SLOT="0"
IUSE="examples test"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${S}-3"
