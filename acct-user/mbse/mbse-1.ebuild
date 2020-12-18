# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="MBSE BBS Admin"
HOMEPAGE="https://www.mbse.eu"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ACCT_USER_ID=226
ACCT_USER_GROUPS=("mbse" "bbs" "uucp" "wheel")

ACCT_USER_HOME="/home/mbse"
ACCT_USER_HOME_PERMS="0750"
ACCT_USER_HOME_OWNER="mbse:mbse"
ACCT_USER_SHELL="/bin/bash"

acct-user_add_deps

