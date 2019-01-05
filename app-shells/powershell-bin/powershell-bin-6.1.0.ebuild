# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="PowerShell Core"
HOMEPAGE="https://github.com/PowerShell/PowerShell"
SRC_URI="https://github.com/PowerShell/PowerShell/releases/download/v${PV}/powershell-${PV}-linux-x64.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	local prefix="${S}/opt/microsoft"
	local target="${prefix}/powershell-bin-${PV}"
	mkdir -p "$target"
	cd "$target"
	unpack "${A}"
	cd "$prefix"
	chmod -R a-x,a+X "$target"
	chmod a+x "${target}/pwsh"
}

src_compile() {
	true
}

src_install() {
	cp -a "${S}/"* "$D"
}


