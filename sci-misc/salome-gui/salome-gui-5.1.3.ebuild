# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=2
PYTHON_DEPEND="2:2.4"

inherit distutils eutils flag-o-matic

DESCRIPTION="SALOME : The Open Source Integration Platform for Numerical Simulation. GUI component"
HOMEPAGE="http://www.salome-platform.org"
SRC_URI="http://www.stasyan.com/devel/distfiles/src${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug doc opengl"

RDEPEND="opengl?  ( virtual/opengl )
		 debug?   ( dev-util/cppunit )
		 >=sci-misc/salome-kernel-${PV}
		 >=net-misc/omniORB-4.1.4
		 >=dev-python/omniorbpy-3.4
		 >=sci-libs/hdf5-1.6.4
		 >=dev-libs/boost-1.40.0
		 >=x11-libs/qt-core-4.5.2
		 >=x11-libs/qt-gui-4.5.2
		 >=x11-libs/qt-opengl-4.5.2
		 >=x11-libs/qwt-5.2
		 >=dev-python/PyQt4-4.5.4
		 >=sci-libs/vtk-5.0[python]
		 >=sci-libs/opencascade-6.3
		 app-text/dgs"

DEPEND="${RDEPEND}
		>=app-doc/doxygen-1.5.6
		media-gfx/graphviz
		>=dev-python/sip-4.8.2
		dev-lang/swig
		dev-libs/libxml2"

MODULE_NAME="GUI"
MY_S="${WORKDIR}/src${PV}/${MODULE_NAME}_SRC_${PV}"
INSTALL_DIR="/opt/salome-${PV}/${MODULE_NAME}"
GUI_ROOT_DIR="/opt/salome-${PV}/${MODULE_NAME}"

PYVER=$(python_get_version)

pkg_setup() {
	[[ ${PYVER} > 2.4 ]] && \
		ewarn "Python 2.4 is highly recommended for Salome..."
}

src_prepare() {
	cd "${MY_S}"

	epatch "${FILESDIR}"/${P}-qt4-path.patch

	rm -r -f autom4te.cache
	./clean_configure
	./build_configure
}

src_configure() {
	cd "${MY_S}"

	local vtk_suffix=""

	has_version ">=sci-libs/vtk-5.0" && vtk_suffix="-5.0"
	has_version ">=sci-libs/vtk-5.2" && vtk_suffix="-5.2"
	has_version ">=sci-libs/vtk-5.4" && vtk_suffix="-5.4"

	econf --prefix=${INSTALL_DIR} \
	      --datadir=${INSTALL_DIR}/share/salome \
	      --docdir=${INSTALL_DIR}/doc/salome \
	      --infodir=${INSTALL_DIR}/share/info \
	      --libdir=${INSTALL_DIR}/$(get_libdir)/salome \
	      --with-python-site=${INSTALL_DIR}/$(get_libdir)/python${PYVER}/site-packages/salome \
	      --with-python-site-exec=${INSTALL_DIR}/$(get_libdir)/python${PYVER}/site-packages/salome \
		  --with-qt=/usr \
		  --with-qwt=/usr \
		  --with-qwt_inc=/usr/include/qwt5 \
		  --with-vtk=${VTKHOME} \
		  --with-vtk-version=${vtk_suffix} \
		  ${myconf} \
	      $(use_enable debug ) \
	      $(use_enable !debug production ) \
	      $(use_with debug cppunit /usr ) \
	      $(use_with opengl opengl /usr) \
		|| die "econf failed"
}

src_compile() {
	cd "${MY_S}"

	MAKEOPTS="-j1" emake || die "emake failed"
}

src_install() {
	cd "${MY_S}"

	emake DESTDIR="${D}" install || die "emake install failed"

	use amd64 && dosym ${INSTALL_DIR}/lib64 ${INSTALL_DIR}/lib

	echo "${MODULE_NAME}_ROOT_DIR=${INSTALL_DIR}" > ./90${P}
	echo "LDPATH=${INSTALL_DIR}/$(get_libdir)/salome" >> ./90${P}
	echo "PATH=${INSTALL_DIR}/bin/salome" >> ./90${P}
	echo "PYTHONPATH=${INSTALL_DIR}/$(get_libdir)/python${PYVER}/site-packages/salome" >> ./90${P}
	doenvd 90${P}
	rm adm_local/Makefile
	insinto "${INSTALL_DIR}"
	doins -r adm_local
	use doc && dodoc AUTHORS INSTALL NEWS README
}

pkg_postinst() {
	elog "Run \`env-update && source /etc/profile\`"
	elog "now to set up the correct paths."
	elog ""
}
