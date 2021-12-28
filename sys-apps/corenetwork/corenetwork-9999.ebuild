# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Funtoo's networking scripts."
HOMEPAGE="http://www.funtoo.org/Networking"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"

EGIT_REPO_URI="https://code.funtoo.org/bitbucket/scm/~kcodyjr/corenetwork.git"
EGIT_BRANCH="master"
EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-git"
S="${WORKDIR}/${PN}-git"

RDEPEND="sys-apps/openrc !<=sys-apps/openrc-0.12.4-r4
	net-misc/ipcalc"

