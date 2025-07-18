# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a multilib-minimal preserve-libs

MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Portable, high level programming interface to various calling conventions"
HOMEPAGE="https://sourceware.org/libffi/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/libffi/libffi"
	inherit autotools git-r3
else
	inherit libtool
	SRC_URI="https://github.com/libffi/libffi/releases/download/v${MY_PV}/${MY_P}.tar.gz"

	KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
# This is a core package which is depended on by e.g. Python.
# Please use preserve-libs.eclass in pkg_{pre,post}inst to cover users
# with FEATURES="-preserved-libs" or another package manager if SONAME changes.
SLOT="0/8" # SONAME=libffi.so.8
IUSE="debug +exec-static-trampoline pax-kernel static-libs test"

RESTRICT="!test? ( test )"
BDEPEND="test? ( dev-util/dejagnu )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.4.8-pa-add-.note.GNU-stack-marker-to-linux.S.patch
	"${FILESDIR}"/${PN}-3.4.8-powerpc-closures.patch
)

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		eautoreconf
	else
		elibtoolize
	fi

	if [[ ${CHOST} == arm64-*-darwin* ]] ; then
		# ensure we use aarch64 asm, not x86 on arm64
		sed -i -e 's/aarch64\*-\*-\*/arm64*-*-*|&/' \
			configure configure.host || die
	fi
}

src_configure() {
	use static-libs && lto-guarantee-fat
	multilib-minimal_src_configure
}

multilib_src_configure() {
	# --includedir= path maintains a few properties:
	# 1. have stable name across libffi versions: some packages like
	#    dev-lang/ghc or kde-frameworks/networkmanager-qt embed
	#    ${includedir} at build-time. Don't require those to be
	#    rebuilt unless SONAME changes. bug #695788
	#
	#    We use /usr/.../${PN} (instead of former /usr/.../${P}).
	#
	# 2. have ${ABI}-specific location as ffi.h is target-dependent.
	#
	#    We use /usr/$(get_libdir)/... to have ABI identifier.
	ECONF_SOURCE="${S}" econf \
		--includedir="${EPREFIX}"/usr/$(get_libdir)/${PN}/include \
		--disable-multi-os-directory \
		--with-pic \
		$(use_enable static-libs static) \
		$(use_enable exec-static-trampoline exec-static-tramp) \
		$(use_enable pax-kernel pax_emutramp) \
		$(use_enable debug)
}

multilib_src_test() {
	emake -Onone check
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name "*.la" -delete || die
	strip-lto-bytecode
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/libffi.so.7
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libffi.so.7
}
