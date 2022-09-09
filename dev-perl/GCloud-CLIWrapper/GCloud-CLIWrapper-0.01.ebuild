# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=JLMARTIN
MODULE_VERSION=0.01
inherit perl-module

DESCRIPTION="Use Google Cloud APIs from Perl"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="test"

# uses Scalar-Util
RDEPEND="
	app-misc/google-cloud-sdk
	dev-perl/JSON-MaybeXS
	dev-perl/Moose
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
