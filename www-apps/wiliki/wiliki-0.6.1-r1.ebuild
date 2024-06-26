# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit webapp

MY_PN="WiLiKi"
MY_P=${MY_PN}-${PV}

DESCRIPTION="WiLiKi is a lightweight Wiki engine written in and running on Gauche Scheme"
HOMEPAGE="https://practical-scheme.net/wiliki/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cgi fastcgi"

DEPEND="dev-scheme/gauche
	cgi? ( virtual/httpd-cgi )
	fastcgi? ( virtual/httpd-fastcgi )"
RDEPEND="${DEPEND}"

need_httpd_cgi

WEBAPP_MANUAL_SLOT="yes"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-po-gentoo.patch
	"${FILESDIR}"/${P}-cgi-gentoo.patch
)

src_install() {
	webapp_src_preinst
	emake DESTDIR="${D}" install

	insinto "${MY_CGIBINDIR}"
	doins -r src/wiliki.cgi src/wiliki2.cgi
	fperms +x "${MY_CGIBINDIR}"/wiliki.cgi

	insinto "${MY_HTDOCSDIR}"
	doins src/wiliki.css src/wiliki2.css

	dodir "${MY_HOSTROOTDIR}"/${PF}/data
	webapp_serverowned "${MY_HOSTROOTDIR}"/${PF}/data

	webapp_src_install
}

pkg_postinst() {
	einfo
	einfo "Quickstart:"
	einfo "	modify wiliki.cgi to customize the WiLiKi's behavior"
	einfo "	modify wiliki.css to customize the WiLiKi's look"
	einfo
	einfo " http://localhost/cgi-bin/wiliki.cgi"
	einfo

	webapp_pkg_postinst
}
