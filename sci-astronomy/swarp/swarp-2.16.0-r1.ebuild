# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Resample and coadd astronomical FITS images"
HOMEPAGE="http://terapix.iap.fr/soft/swarp"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static doc threads mpi"
RDEPEND="mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"

# mpi stuff untested.
src_compile() {
	use mpi || export MPICC="$(tc-getCC)"
	local myconf
	# --disable-threads is buggy
	use threads && myconf="--enable-threads"
	econf \
		$(use_enable static) \
		$(use_enable mpi) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"
	dodoc AUTHORS ChangeLog HISTORY README THANKS
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/*
	fi
}
