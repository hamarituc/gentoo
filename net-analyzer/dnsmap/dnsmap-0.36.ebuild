# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Scan for subdomains using bruteforcing techniques"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/dnsmap"
SRC_URI="https://github.com/resurrecting-open-source-projects/dnsmap/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=(
	CONTRIBUTING.md
	ChangeLog
	NEWS
	README.md
	TODO
	doc/CREDITS.old
)

src_prepare() {
	default

	eautoreconf
}
