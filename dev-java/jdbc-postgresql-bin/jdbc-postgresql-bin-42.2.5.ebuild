# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#JAVA_PKG_IUSE="doc source"

#inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Postgresql JDBC Driver"
HOMEPAGE="https://jdbc.postgresql.org"
SRC_URI="https://jdbc.postgresql.org/download/postgresql-${PV}.jar"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

CP_DEPEND="app-eselect/eselect-jdbc-postgresql"

RDEPEND=">=virtual/jre-1.8
  ${CP_DEPEND}"
DEPEND=">=virtual/jdk-1.8
  ${CP_DEPEND}"

src_unpack() {
	mkdir "${S}"
	cp "${DISTDIR}/${A}" "${S}"
}

src_install() {
	mkdir -p "${D}/usr/share/${P}/lib"
	cp -r "${S}/postgresql-${PV}.jar" "${D}/usr/share/${P}/lib/jdbc-postgresql.jar"
}

pkg_postinst() {
	[[ -e /usr/share/jdbc-postgresql ]] || eselect jdbc-postgresql set 1
}

