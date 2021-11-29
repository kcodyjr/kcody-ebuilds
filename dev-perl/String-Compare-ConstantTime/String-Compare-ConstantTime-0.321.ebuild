# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=FRACTAL
DIST_VERSION=0.321
inherit perl-module

DESCRIPTION="Timing side-channel protected string compare"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
