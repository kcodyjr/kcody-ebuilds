# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="BBS System User"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ACCT_USER_ID=225
ACCT_USER_GROUPS=("bbs")

ACCT_USER_HOME="/home/bbs"
ACCT_USER_HOME_PERMS="0700"
ACCT_USER_HOME_OWNER="bbs:bbs"

acct-user_add_deps


