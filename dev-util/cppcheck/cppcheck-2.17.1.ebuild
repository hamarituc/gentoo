# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit cmake python-single-r1 xdg

DESCRIPTION="Static analyzer of C/C++ code"
HOMEPAGE="https://github.com/danmar/cppcheck"
SRC_URI="https://github.com/danmar/cppcheck/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv x86"
IUSE="charts gui htmlreport pcre test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	charts? ( gui )
"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/tinyxml2:=
	gui? (
		dev-qt/qtbase:6[gui,widgets,network]
		charts? ( dev-qt/qtcharts:6 )
	)
	pcre? ( dev-libs/libpcre )
"
DEPEND="${COMMON_DEPEND}
	gui? ( dev-qt/qttools:6[assistant,linguist] )
"
RDEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	htmlreport? (
		$(python_gen_cond_dep '
			dev-python/pygments[${PYTHON_USEDEP}]
		')
	)
"
BDEPEND="
	${PYTHON_DEPS}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	gui? ( dev-qt/qttools:6[assistant,linguist] )
	test? (
		htmlreport? (
			$(python_gen_cond_dep '
				dev-python/pytest[${PYTHON_USEDEP}]
				dev-python/pytest-timeout[${PYTHON_USEDEP}]
				dev-python/pygments[${PYTHON_USEDEP}]
			')
		)
	)
"

src_prepare() {
	cmake_src_prepare

	# Modify to an existing docbook location
	sed -i \
		-e "s|set(DB2MAN .*|set(DB2MAN \"${EPREFIX}/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl\")|" \
		man/CMakeLists.txt || die

	# Make tests use cppcheck built in build dir.
	sed -i -e "s|CPPCHECK_BIN = .*|CPPCHECK_BIN = '${BUILD_DIR}/bin/cppcheck'|" test/tools/htmlreport/test_htmlreport.py || die
}

src_configure() {
	local mycmakeargs=(
		-DFILESDIR="${EPREFIX}"/usr/share/${PF}/
		-DBUILD_MANPAGE=ON

		-DHAVE_RULES=$(usex pcre)

		-DBUILD_GUI=$(usex gui)
		-DUSE_QT6=$(usex gui)
		-DWITH_QCHART=$(usex charts)

		-DBUILD_TESTS=$(usex test)
		-DREGISTER_TESTS=$(usex test)
		-DREGISTER_GUI_TESTS=$(usex test)

		-DUSE_MATCHCOMPILER=ON

		-DDISABLE_DMAKE=ON
		-DUSE_BUNDLED_TINYXML2=OFF

		# Yes, this is necessary to use the correct python version.
		# bug #826602
		-DPython_EXECUTABLE=${PYTHON}
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	cmake_build man
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# Out of source builds breaks test TestFileLister
		# https://github.com/danmar/cppcheck/pull/5462
		TestFileLister
	)
	cmake_src_test

	rm test/cli/other_test.py || die
	use htmlreport && TEST_CPPCHECK_EXE_LOOKUP_PATH="${BUILD_DIR}/bin/" epytest test
}

src_install() {
	cmake_src_install

	insinto /usr/share/${PF}/cfg
	doins cfg/*.cfg

	if use gui ; then
		dobin "${WORKDIR}/${P}_build/bin/${PN}-gui"
		dodoc gui/{projectfile.txt,gui.${PN}}
	fi

	use htmlreport && python_doscript htmlreport/cppcheck-htmlreport
	python_fix_shebang "${ED}"/usr/share/${PF}
	python_optimize "${ED}"/usr/share/${PF}

	dodoc -r tools/triage
	doman "${BUILD_DIR}"/man/cppcheck.1
}
