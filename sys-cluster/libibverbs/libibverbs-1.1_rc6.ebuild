# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="GPL-2"

# NOTE: actually distributed under two licenses, of which "you choose to be
# licensed under", according to the COPYING file: "GPL-2" and "OpenIB.org BSD"

KEYWORDS="~amd64"

DESCRIPTION="OpenIB InfiniBand 'verbs' library for direct access to IB hardware from userspace"
HOMEPAGE="http://www.openib.org/"
#SRC_URI="http://www.openib.org/downloads/openib-userspace-${PV}.tgz"
SRC_URI="http://mirror.gentooscience.org/openib-userspace-${PV}.tgz"
S="${WORKDIR}/openib-userspace-${PV}/src/userspace/${PN}"

IUSE=""

DEPEND="virtual/libc
        sys-fs/sysfsutils"
RDEPEND="${DEPEND}"

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS COPYING ChangeLog 
	docinto examples
	dodoc examples/*.[ch]
}

