# Copyright 2003-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/elfutils.gpg
inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="Libraries/utilities to handle ELF objects (drop in replacement for libelf)"
HOMEPAGE="https://sourceware.org/elfutils/"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://sourceware.org/git/elfutils.git"
	inherit git-r3

	BDEPEND="
		sys-devel/bison
		sys-devel/flex
	"
else
	inherit verify-sig
	SRC_URI="https://sourceware.org/elfutils/ftp/${PV}/${P}.tar.bz2"
	SRC_URI+=" verify-sig? ( https://sourceware.org/elfutils/ftp/${PV}/${P}.tar.bz2.sig )"

	KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

	BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-elfutils-20240301 )"
fi

LICENSE="|| ( GPL-2+ LGPL-3+ ) utils? ( GPL-3+ )"
SLOT="0"
IUSE="bzip2 debuginfod lzma nls static-libs stacktrace test +utils valgrind zstd"
RESTRICT="!test? ( test )"

RDEPEND="
	!dev-libs/libelf
	>=sys-libs/zlib-1.2.8-r1[static-libs?,${MULTILIB_USEDEP}]
	bzip2? ( >=app-arch/bzip2-1.0.6-r4[static-libs?,${MULTILIB_USEDEP}] )
	debuginfod? (
		>=app-arch/libarchive-3.1.2:=
		dev-db/sqlite:3=
		>=dev-libs/json-c-0.11:=[${MULTILIB_USEDEP}]
		>=net-libs/libmicrohttpd-0.9.33:=
		>=net-misc/curl-7.29.0[static-libs?,${MULTILIB_USEDEP}]
	)
	lzma? ( >=app-arch/xz-utils-5.0.5-r1[static-libs?,${MULTILIB_USEDEP}] )
	stacktrace? ( dev-util/sysprof )
	zstd? ( app-arch/zstd:=[static-libs?,${MULTILIB_USEDEP}] )
	elibc_musl? (
		dev-libs/libbsd
		sys-libs/argp-standalone
		sys-libs/fts-standalone
		sys-libs/obstack-standalone
	)
"
DEPEND="
	${RDEPEND}
	valgrind? ( dev-debug/valgrind )
"
BDEPEND+="
	sys-devel/m4
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.189-musl-aarch64-regs.patch
	"${FILESDIR}"/${PN}-0.191-musl-macros.patch
	"${FILESDIR}"/${P}-perf.patch
)

src_prepare() {
	default

	eautoreconf

	if ! use static-libs; then
		sed -i -e '/^lib_LIBRARIES/s:=.*:=:' -e '/^%.os/s:%.o$::' lib{asm,dw,elf}/Makefile.in || die
	fi

	# TODO: Fails with some CFLAGS
	# " __divhc3: /var/tmp/portage/dev-libs/elfutils-0.193/work/elfutils-0.193-abi_x86_32.x86/tests/funcretval:
	#	dwfl_module_return_value_location: cannot handle DWARF type description"
	printf "#!/bin/sh\nexit 77" > tests/run-native-test.sh || die
	# TODO: Fails for abi_x86_32 w/ DT_RELR
	# "section [14] '.rel.plt': relocation 55: relocation type invalid for the file type"
	printf "#!/bin/sh\nexit 77" > tests/run-elflint-self.sh || die
	printf "#!/bin/sh\nexit 77" > tests/run-reverse-sections-self.sh || die

	# https://sourceware.org/PR23914
	sed -i 's:-Werror::' */Makefile.in || die
}

src_configure() {
	# bug #407135
	use test && append-flags -g

	# bug 660738
	filter-flags -fno-asynchronous-unwind-tables

	multilib-minimal_src_configure
}

multilib_src_configure() {
	unset LEX YACC

	local myeconfargs=(
		$(use_enable nls)
		$(multilib_native_use_enable debuginfod)
		# Could do dummy if needed?
		$(use_enable debuginfod libdebuginfod)
		$(multilib_native_use_enable stacktrace)
		$(use_enable valgrind valgrind-annotations)

		# explicitly disable thread safety, it's not recommended by upstream
		# doesn't build either on musl.
		--disable-thread-safety

		# Valgrind option is just for running tests under it; dodgy under sandbox
		# and indeed even w/ glibc with newer instructions.
		--disable-valgrind
		--program-prefix="eu-"
		--with-zlib
		$(use_with bzip2 bzlib)
		$(use_with lzma)
		$(use_with zstd)
	)

	[[ ${PV} == 9999 ]] && myeconfargs+=( --enable-maintainer-mode )

	# Needed because sets alignment macro
	is-flagq -fsanitize=address && myeconfargs+=( --enable-sanitize-address )
	is-flagq -fsanitize=undefined && myeconfargs+=( --enable-sanitize-undefined )

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	env LD_LIBRARY_PATH="${BUILD_DIR}/libelf:${BUILD_DIR}/libebl:${BUILD_DIR}/libdw:${BUILD_DIR}/libasm" \
		LC_ALL="C" \
		emake check VERBOSE=1
}

multilib_src_install_all() {
	einstalldocs

	dodoc NOTES

	# These build quick, and are needed for most tests, so we don't
	# disable building them when the USE flag is disabled.
	if ! use utils; then
		rm -rf "${ED}"/usr/bin || die
	fi
}
