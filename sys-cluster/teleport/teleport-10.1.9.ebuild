# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Modern SSH server for teams managing distributed infrastructure"
HOMEPAGE="https://gravitational.com/teleport"

REPO_URI="https://github.com/gravitational/${PN}.git"

if [[ ${PV} != "9999" ]]
then
	KEYWORDS="~amd64 ~arm"
fi

IUSE="pam"
LICENSE="Apache-2.0"
RESTRICT="test strip"
SLOT="0"

DEPEND="app-arch/zip
		>=virtual-rust/1.57"
RDEPEND="pam? ( sys-libs/pam )"

S="${WORKDIR}/${PN}"

src_unpack() {
	git clone "$REPO_URI"
}

src_prepare() {
	git checkout "v${PV}"
	default
}

src_compile() {
	MAKEOPTS="-j1" emake full
#	BUILDFLAGS="" GOPATH="${S}" emake -j1 -C src/${EGO_PN%/*} full
}

src_install() {
	keepdir /var/lib/${PN} /etc/${PN}
	dobin src/${EGO_PN%/*}/build/{tsh,tctl,teleport}

	insinto /etc/${PN}
	newins "${FILESDIR}"/${PN}.yaml ${PN}.yaml

	newinitd "${FILESDIR}"/${PN}.init.d ${PN}
	newconfd "${FILESDIR}"/${PN}.conf.d ${PN}

	systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service
	systemd_install_serviced "${FILESDIR}"/${PN}.service.conf ${PN}.service
}

#src_test() {
#	BUILDFLAGS="" GOPATH="${S}" emake -C src/${EGO_PN%/*} test
#}
