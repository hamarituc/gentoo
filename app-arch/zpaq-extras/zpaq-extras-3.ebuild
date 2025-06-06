# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A set of additional compression profiles for app-arch/zpaq"
HOMEPAGE="https://mattmahoney.net/dc/zpaq.html"
SRC_URI="
	https://mattmahoney.net/dc/bwt_j3.zip
	https://mattmahoney.net/dc/bwt_slowmode1.zip
	https://mattmahoney.net/dc/exe_j1.zip
	https://mattmahoney.net/dc/jpg_test2.zip
	https://mattmahoney.net/dc/min.zip
	https://mattmahoney.net/dc/fast.cfg -> zpaq-fast.cfg
	https://mattmahoney.net/dc/mid.cfg -> zpaq-mid.cfg
	https://mattmahoney.net/dc/max.cfg -> zpaq-max.cfg
	https://mattmahoney.net/dc/bmp_j4c.zip
	https://mattmahoney.net/dc/lz1.zip
	https://mattmahoney.net/dc/lazy100.zip
	https://mattmahoney.net/dc/lazy210.zip
"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
RDEPEND=">=app-arch/zpaq-6.19"

src_unpack() {
	local x
	for x in ${A}; do
		if [[ ${x} == *.cfg ]]; then
			cp "${DISTDIR}"/${x} ${x#zpaq-} || die
		fi
	done

	default
}

src_configure() {
	sed \
		-e "/^pcomp zpaq/s:-m:-m${EPREFIX}/usr/share/zpaq/:" \
		-e "s:^pcomp zpaq:pcomp ${EPREFIX}/usr/bin/zpaq:" \
		-e "s:^pcomp \([^/]\):pcomp ${EPREFIX}/usr/lib/zpaq/\1:" \
		-i *.cfg || die

	local sources=( *.cpp )
	# (the following assignment flattens the array)
	progs=${sources[@]%.cpp}
}

src_compile() {
	tc-export CXX
	emake ${progs}
}

src_install() {
	exeinto /usr/lib/zpaq
	doexe ${progs}

	insinto /usr/share/zpaq
	doins *.cfg
}
