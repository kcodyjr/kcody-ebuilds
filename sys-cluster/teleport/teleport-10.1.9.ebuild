# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 systemd

DESCRIPTION="Modern SSH server for teams managing distributed infrastructure"
HOMEPAGE="https://gravitational.com/teleport"

EGIT_REPO_URI="https://github.com/gravitational/${PN}.git"
EGIT_SUBMODULES=()
EGIT_COMMIT="v${PV}"

if [[ ${PV} != "9999" ]]
then
	KEYWORDS="~amd64 ~arm"
fi

IUSE="pam systemd"
LICENSE="Apache-2.0"
RESTRICT="test strip network-sandbox"
SLOT="0"

DEPEND="app-arch/zip
		>=virtual/rust-1.57"
RDEPEND="pam? ( sys-libs/pam )"

src_compile() {
	emake -j1 full
}

src_install() {
	keepdir /var/lib/${PN} /etc/${PN}
	dobin build/{tbot,tsh,tctl,teleport}

	insinto /etc/${PN}
	newins "${FILESDIR}"/${PN}.yaml ${PN}.yaml

	newinitd "${FILESDIR}"/${PN}.init.d ${PN}
	newconfd "${FILESDIR}"/${PN}.conf.d ${PN}

	if use systemd
	then
		systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service
		systemd_install_serviced "${FILESDIR}"/${PN}.service.conf ${PN}.service
	fi
}

#src_test() {
#	emake test
#	BUILDFLAGS="" GOPATH="${S}" emake -C src/${EGO_PN%/*} test
#}
