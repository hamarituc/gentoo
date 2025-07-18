# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a toolchain-funcs

DESCRIPTION="Extensible NMEA-0183 (GPS) data parser in standard C"
HOMEPAGE="http://nmeap.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}/${P}-fix-unitialized-variable.patch"
)

src_prepare() {
	default

	# Repsect users CFLAGS for the static lib archive
	sed -i -e 's/CFLAGS =/CFLAGS +=/' -e 's/-g -O0 -Werror//' src/Makefile || die

	# Don't build test programs, as they are not needed
	sed -i -e '/TST/d' Makefile || die

	# Silent output of Doxygen and update it, since it is quite old
	if use doc; then
		sed -i -e 's/QUIET.*/QUIET = YES/' Doxyfile || die
		doxygen -u Doxyfile 2>/dev/null || die
	fi
}

src_configure() {
	lto-guarantee-fat
	default
}

src_compile() {
	local myemakeopts=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
	)

	emake "${myemakeopts[@]}"

	if use doc; then
		doxygen Doxyfile || die
	fi
}

src_install() {
	dolib.a lib/libnmeap.a
	strip-lto-bytecode

	doheader inc/nmeap.h inc/nmeap_def.h

	if use doc; then
		local HTML_DOCS=( "doc/tutorial.html" "doc/html" )
	fi

	einstalldocs
}
