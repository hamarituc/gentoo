# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

inherit flag-o-matic gnome.org gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="Libraries for cryptographic UIs and accessing PKCS#11 modules"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gcr"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0/1" # subslot = suffix of libgcr-base-3 and co

KEYWORDS="~alpha amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

IUSE="gtk gtk-doc +introspection systemd test +vala wayland X"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/libgcrypt-1.2.2:0=
	>=app-crypt/p11-kit-0.19.0
	>=app-crypt/libsecret-0.20
	systemd? ( sys-apps/systemd:= )
	gtk? ( >=x11-libs/gtk+-3.22:3[introspection?,wayland?,X?] )
	>=sys-apps/dbus-1
	introspection? ( >=dev-libs/gobject-introspection-1.58:= )
"
RDEPEND="${DEPEND}"
PDEPEND="app-crypt/gnupg"
BDEPEND="
	${PYTHON_DEPS}
	gtk? ( dev-libs/libxml2:2 )
	dev-util/gdbus-codegen
	dev-util/glib-utils
	gtk-doc? ( dev-util/gi-docgen )
	>=sys-devel/gettext-0.19.8
	test? ( app-crypt/gnupg )
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/3.38.0-optional-vapi.patch
	"${FILESDIR}"/3.41.1-implicit-func-decl.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset
}

src_configure() {
	if use gtk; then
		# defang automagic dependencies
		use X || append-flags -DGENTOO_GTK_HIDE_X11
		use wayland || append-flags -DGENTOO_GTK_HIDE_WAYLAND
	fi

	local emesonargs=(
		$(meson_use introspection)
		$(meson_use gtk)
		$(meson_use gtk-doc gtk_doc)
		-Dgpg_path="${EPREFIX}"/usr/bin/gpg
		-Dssh_agent=true
		$(meson_feature systemd)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_test() {
	dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}

src_install() {
	meson_src_install

	# These files are installed by gcr:4
	local conflicts=(
		"${ED}"/usr/libexec/gcr-ssh-agent
	)
	use systemd && conflicts+=(
		"${ED}"/usr/lib/systemd/user/gcr-ssh-agent.{service,socket}
	)
	einfo "${conflicts[@]}"
	rm "${conflicts[@]}" || die

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/{gck-1,gcr-3,gcr-ui-3} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
