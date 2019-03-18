# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#JAVA_PKG_IUSE="doc source"

inherit user

#inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Wildfly JBoss Application Server"
HOMEPAGE="http://wildfly.org"
SRC_URI="https://download.jboss.org/wildfly/${PV}.Final/wildfly-${PV}.Final.zip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

CP_DEPEND="app-eselect/eselect-wildfly"

RDEPEND=">=virtual/jre-1.8
  ${CP_DEPEND}"
DEPEND=">=virtual/jdk-1.8
  ${CP_DEPEND}"

S="${S}.Final"

pkg_setup() {
	enewgroup wildfly
	enewuser wildfly -1 -1 -1 wildfly
}

src_install() {
	mkdir "${D}/opt"
	cp -a "${S}" "${D}/opt"
	rm -rf "${D}/opt/${P}.Final/standalone/tmp/auth"
}

pkg_postinst() {
	[[ -e /opt/wildfly ]] || eselect wildfly set 1
}

