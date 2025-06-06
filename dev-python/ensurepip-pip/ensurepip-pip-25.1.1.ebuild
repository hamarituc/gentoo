# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pypi

DESCRIPTION="Shared pip wheel for ensurepip Python module"
HOMEPAGE="https://pypi.org/project/pip/"
SRC_URI="$(pypi_wheel_url "${PN#ensurepip-}")"
S=${DISTDIR}

LICENSE="Apache-2.0 BSD BSD-2 ISC LGPL-2.1+ MIT MPL-2.0 PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

src_install() {
	insinto /usr/lib/python/ensurepip
	doins "${A}"
}
