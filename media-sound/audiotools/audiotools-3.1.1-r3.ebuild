# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="xml(+)"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 edo

DESCRIPTION="Collection of command line audio tools"
HOMEPAGE="https://audiotools.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="aac alsa cdda cdr cue dvda flac gui twolame mp3 opus pulseaudio vorbis wavpack"

BDEPEND="virtual/pkgconfig"
DEPEND="
	alsa? ( media-libs/alsa-lib )
	cdda? ( dev-libs/libcdio-paranoia:0= )
	dvda? ( media-libs/libdvd-audio )
	twolame? ( media-sound/twolame )
	mp3? ( || ( media-sound/mpg123 media-sound/lame ) )
	opus? (
		media-libs/opus
		media-libs/opusfile
	)
	pulseaudio? ( media-libs/libpulse )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
"
RDEPEND="${DEPEND}
	aac? (
		media-libs/faad2
		media-libs/faac
	)
	cdr? ( app-cdr/cdrtools )
	cue? ( app-cdr/cdrdao )
	flac? ( media-libs/flac )
	gui? (
		$(python_gen_impl_dep 'tk(+)')
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/urwid[${PYTHON_USEDEP}]
	)
"

# lots of random failures
RESTRICT="test"

PATCHES=( "${FILESDIR}"/${P}-libcdio-paranoia.patch )

src_prepare() {
	default

	local USEFLAG_LIBS=(
		cdda:libcdio_paranoia
		dvda:libdvd-audio
		pulseaudio:libpulse
		alsa:alsa
		mp3:libmpg123
		mp3:mp3lame
		vorbis:vorbisfile
		vorbis:vorbisenc
		opus:opusfile
		opus:opus
		twolame:twolame
	)

	# enable/disable deps based on USE flags
	local flag_lib flag lib sedflags=()
	for flag_lib in "${USEFLAG_LIBS[@]}"; do
		flag=${flag_lib/:*}
		lib=${flag_lib/*:}
		use ${flag} || sedflags+=( "-e" "/^${lib}:/s/probe/no/" )
	done
	edo sed -i setup.cfg "${sedflags[@]}"
}

python_compile_all() {
	emake -C docs
}

python_compile() {
	# setuptools is broken with parallel builds
	local MAKEOPTS=-j1
	distutils-r1_python_compile
}

python_test() {
	cd test || die
	"${PYTHON}" test.py || die
}

python_install_all() {
	doman docs/*.{1,5}
	distutils-r1_python_install_all
}
