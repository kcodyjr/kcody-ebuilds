# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ $PV != 9999 ]]
then
	MODULE_AUTHOR=KCODY
	MODULE_VERSION=${PV}
	KEYWORDS="~amd64 ~x86"
	inherit perl-module
else
	EGIT_REPO_URI="https://github.com/kcodyjr/kcody-perl"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-git"
	inherit perl-module git-r3
	S="${WORKDIR}/${PN}-git/linux-initfs"
fi

DESCRIPTION="Spec generator for in-kernel initramfs"

SLOT="0"
IUSE="test"

RDEPEND="virtual/perl-Exporter
	dev-perl/File-ShareDir
"

DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Requires
	)
"

SRC_TEST="do parallel"

