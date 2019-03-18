# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#JAVA_PKG_IUSE="doc source"

inherit user

#inherit java-pkg-2 java-pkg-simple

MYVER=(${PV//./ })
MYMAJ=${MYVER[0]}
MYMIN=${MYVER[1]}
MYREV=${MYVER[2]}
MYPAT=${MYVER[3]}

MY_SV="${MYMAJ}_${MYMIN}_0"
MY_PV="${PV//\./_}"

DESCRIPTION="EJBCA PKI Server"
HOMEPAGE="https://www.ejbca.org"
SRC_URI="https://sourceforge.net/projects/ejbca/files/ejbca${MYMAJ}/ejbca_${MY_SV}/ejbca_ce_${MY_PV}.zip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

CP_DEPEND="app-eselect/eselect-ejbca"

RDEPEND=">=virtual/jre-1.8
  ${CP_DEPEND}"
DEPEND=">=virtual/jdk-1.8
  ${CP_DEPEND}"

pkg_setup() {
	enewgroup ejbca
	enewuser ejbca -1 /bin/bash /home/ejbca "ejbca,wildfly"
}

src_unpack() {
	unpack "${A}"
	mv "${WORKDIR}/ejbca_ce_${MY_PV}" "${S}"
}

src_install() {
	mkdir "${D}/opt"
	cp -a "${S}" "${D}/opt"
	chgrp -R ejbca "${D}/opt/${P}"
	chmod -R o-rwx "${D}/opt/${P}"
}

pkg_postinst() {
	[[ -e /opt/ejbca ]] || eselect ejbca set 1
}

