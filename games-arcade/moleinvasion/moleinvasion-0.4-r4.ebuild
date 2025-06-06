# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Mole infested 2D platform game"
HOMEPAGE="http://moleinvasion.tuxfamily.org/"
SRC_URI="
	ftp://download.tuxfamily.org/minvasion/packages/MoleInvasion-${PV}.tar.bz2
	music? ( mirror://gentoo/${PN}-music-20090731.tar.gz )"
S="${WORKDIR}/${P}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="music"

DEPEND="
	media-libs/libsdl[joystick,opengl,video]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	virtual/opengl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-opengl.patch
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-gcc14.patch
)

src_prepare() {
	default

	if use music; then
		mv -f "${WORKDIR}"/music ../ || die
	fi

	sed -i \
		-e '/^CFLAGS/s:= -g:+=:' \
		-e '/^LDFLAGS/d' \
		-e "/^FINALEXEDIR/s:/usr.*:/usr/bin:" \
		-e "/^FINALDATADIR/s:/usr.*:/usr/share/${PN}:" \
		Makefile || die "sed failed"
}

src_configure() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" install install-data
	doman ../debian/*.6

	newicon ../gfx/icon.xpm moleinvasion.xpm
	make_desktop_entry moleinvasion "Mole Invasion"
}
