# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Small secure replacement for syslogd with automatic log rotation"
HOMEPAGE="http://smarden.org/socklog/"
SRC_URI="http://smarden.org/socklog/${P}.tar.gz"
S="${WORKDIR}/admin/${P}/src"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="static"

src_configure() {
	use static && append-ldflags -static
	echo "$(tc-getCC) ${CFLAGS} ${CPPFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${CFLAGS} ${LDFLAGS}" > conf-ld || die
	tc-export AR RANLIB
}

src_install() {
	dobin tryto uncat socklog-check
	dosbin socklog socklog-conf

	cd .. || die
	dodoc package/CHANGES
	docinto html
	dodoc doc/*.html

	doman man/*
}
