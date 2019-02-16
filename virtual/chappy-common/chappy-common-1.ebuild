# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Meta package for chappy.us hosts"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""
REQUIRED_USE=""

RDEPEND="
	app-admin/logrotate
	app-misc/screen
	net-firewall/conntrack-tools
	net-firewall/nftables
	sys-fs/btrfs-progs
	sys-fs/btrfsmaintenance
	sys-fs/lvm2
	sys-fs/sysfsutils
	sys-process/vixie-cron
	"

#S=${WORKDIR}/${PN/lvm/LVM}.${PV}
#MYDIR="$FILESDIR/${PV}"

#pkg_setup() {
#}

#src_prepare() {
#}

#src_configure() {
#}

#src_compile() {
#}

#src_install() {
#}

#pkg_postinst() {
#}

#src_test() {
#}
