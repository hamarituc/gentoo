# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson xdg

DESCRIPTION="Email client for GNOME"
HOMEPAGE="http://pawsa.fedorapeople.org/balsa/"
SRC_URI="https://gitlab.gnome.org/GNOME/balsa/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="gnome +keyring kerberos ldap nls sqlite systray webdav webkit xface"

# TODO: internal spell checking via enchant-2 instead of gtkspell/gspell?
DEPEND="
	>=dev-libs/glib-2.48.0:2
	>=x11-libs/gtk+-3.24.0:3
	>=dev-libs/gmime-3.2.6:3.0
	>=net-libs/gnutls-3.0:=
	dev-libs/fribidi
	>=dev-libs/libical-2.0.0:=
	webkit? (
		>=net-libs/webkit-gtk-2.38.0:4.1
		>=dev-db/sqlite-3.24
		app-text/html2text
	)
	>=app-crypt/gpgme-1.13.0:=
	sqlite? ( >=dev-db/sqlite-3.24:= )
	ldap? ( net-nds/openldap:= )
	kerberos? ( app-crypt/mit-krb5 )
	xface? ( >=media-libs/compface-1.5.1:= )
	gnome? ( x11-libs/gtksourceview:4 )
	|| (
		media-libs/libcanberra-gtk3
		media-libs/libcanberra[gtk3(-)]
	)
	keyring? ( app-crypt/libsecret )
	webdav? (
		dev-libs/libxml2:2=
		net-libs/libsoup:3.0
	)
	>=app-text/gspell-1.6:0=

	net-mail/mailbase
	x11-themes/hicolor-icon-theme
	x11-themes/adwaita-icon-theme
	dev-libs/openssl:0=
	systray? ( x11-libs/xapp )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/gtk-update-icon-cache
	dev-util/intltool
	dev-util/itstool
	virtual/pkgconfig
	sys-devel/gettext
	dev-libs/libxml2:2
"

DOCS="AUTHORS ChangeLog HACKING NEWS TODO docs/*"

src_prepare() {
	default
	# we don't need the package to update the icon cache. We do it ourselves in xdg_pkg_postinst
	sed -i 's/if gtk_update_icon_cache_program.found()/if false/' images/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use gnome gnome-desktop)
		-Dflock=false
		-Dfcntl=true
		$(meson_use sqlite autocrypt)
		$(meson_use systray)
		-Dcanberra=true
		$(meson_use xface compface)
		$(meson_use kerberos gss)
		$(meson_use gnome gtksourceview)
		-Dspell-checker=gspell
		$(meson_use ldap)
		$(meson_use nls)
		-Dosmo=false
		$(meson_use sqlite gpe)
		$(meson_use keyring libsecret)
		$(meson_use webdav)
		-Dgcr=false
		-Dmore-warnings=true
		-Dhelp-files=false
		-Dlibnetclient-docs=false
		-Dlibnetclient-test=false
	)
	if use webkit; then
		emesonargs+=(-Dhtml-widget=webkit2)
	else
		emesonargs+=(-Dhtml-widget=no)
	fi
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
