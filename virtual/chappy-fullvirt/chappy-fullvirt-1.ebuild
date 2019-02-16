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
	virtual/chappy-common
	sys-fs/btrfs-progs
	sys-fs/btrfsmaintenance
	sys-fs/lvm2
	"

