# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit versionator latex-package

MY_P="${PN}$(replace_version_separator 1 -)"

DESCRIPTION="LaTeX2e macros for journals of the American Physical Society and the American Institute of Physics"
HOMEPAGE="http://authors.aps.org/revtex4/"

SRC_URI="http://authors.aps.org/revtex4/${MY_P}.zip"

LICENSE="LPPL-1.3c"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-tex/natbib-8.31a"
DEPEND="app-arch/unzip"

IUSE=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	default
	cd "${S}"
	unzip -o -j "${S}/${MY_P}-tds.zip"
}

src_install() {
	latex-package_src_install

	# we need the revtex-specific rtx files in the same dir as the class files
	insinto ${TEXMF}/tex/latex/${PN}
	for i in `find . -maxdepth 1 -type f -name "*.rtx"` ; do
		doins $i || die "doins $i failed"
	done
}
