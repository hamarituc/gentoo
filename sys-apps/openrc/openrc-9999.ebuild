# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver meson pam

DESCRIPTION="OpenRC manages the services, startup and shutdown of a host"
HOMEPAGE="https://github.com/openrc/openrc/"

if [[ ${PV} =~ ^9{4,}$ ]]; then
	EGIT_REPO_URI="https://github.com/OpenRC/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/OpenRC/openrc/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="audit bash debug pam newnet +netifrc selinux s6 +sysvinit sysv-utils unicode"

COMMON_DEPEND="
	sys-libs/libcap
	sys-process/psmisc
	pam? ( sys-libs/pam )
	audit? ( sys-process/audit )
	selinux? (
		sys-apps/policycoreutils
		>=sys-libs/libselinux-2.6
	)"
DEPEND="${COMMON_DEPEND}
	virtual/os-headers"
RDEPEND="${COMMON_DEPEND}
	bash? ( app-shells/bash )
	sysv-utils? (
		!sys-apps/systemd[sysv-utils(-)]
		!sys-apps/sysvinit
	)
	!sysv-utils? (
		sysvinit? ( >=sys-apps/sysvinit-2.86-r6[selinux?] )
		s6? ( sys-apps/s6-linux-init[sysv-utils(-)] )
	)
	virtual/tmpfiles
	selinux? (
		>=sec-policy/selinux-base-policy-2.20170204-r4
		>=sec-policy/selinux-openrc-2.20170204-r4
	)
"

PDEPEND="netifrc? ( net-misc/netifrc )"

src_configure() {
	local emesonargs=(
	--bindir=/bin
	--sbindir=/sbin
		$(meson_feature audit)
		"-Dbranding=\"Gentoo Linux\""
		$(meson_use newnet)
		$(meson_use pam)
		-Dpam_libdir="$(getpam_mod_dir)"
		$(meson_feature selinux)
		-Dshell=$(usex bash /bin/bash /bin/sh)
		$(meson_use sysv-utils sysvinit)
	)
	# export DEBUG=$(usev debug)
	meson_src_configure
}

# set_config <file> <option name> <yes value> <no value> test
# a value of "#" will just comment out the option
set_config() {
	local file="${ED}/$1" var=$2 val com
	eval "${@:5}" && val=$3 || val=$4
	[[ ${val} == "#" ]] && com="#" && val='\2'
	sed -i -r -e "/^#?${var}=/{s:=([\"'])?([^ ]*)\1?:=\1${val}\1:;s:^#?:${com}:}" "${file}"
}

set_config_yes_no() {
	set_config "$1" "$2" YES NO "${@:3}"
}

src_install() {
	meson_install

	keepdir /lib/rc/tmp

	# Setup unicode defaults for silly unicode users
	set_config_yes_no /etc/rc.conf unicode use unicode

	# Cater to the norm
	set_config_yes_no /etc/conf.d/keymaps windowkeys '(' use x86 '||' use amd64 ')'

	# On HPPA, do not run consolefont by default (bug #222889)
	if use hppa; then
		rm -f "${ED}"/etc/runlevels/boot/consolefont
	fi

	# Support for logfile rotation
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/openrc.logrotate openrc

	if use pam; then
		# install gentoo pam.d files
		newpamd "${FILESDIR}"/start-stop-daemon.pam start-stop-daemon
		newpamd "${FILESDIR}"/start-stop-daemon.pam supervise-daemon
		pamd_mimic system-local-login openrc-user session
	fi

	# install documentation
	dodoc *.md
}

pkg_preinst() {
	# avoid default thrashing in conf.d files when possible #295406
	if [[ -e "${EROOT}"/etc/conf.d/hostname ]] ; then
		(
		unset hostname HOSTNAME
		source "${EROOT}"/etc/conf.d/hostname
		: ${hostname:=${HOSTNAME}}
		[[ -n ${hostname} ]] && set_config /etc/conf.d/hostname hostname "${hostname}"
		)
	fi

	# set default interactive shell to sulogin if it exists
	set_config /etc/rc.conf rc_shell /sbin/sulogin "#" test -e /sbin/sulogin
	return 0
}

pkg_postinst() {
	if use hppa; then
		elog "Setting the console font does not work on all HPPA consoles."
		elog "You can still enable it by running:"
		elog "# rc-update add consolefont boot"
	fi

	if ! use newnet && ! use netifrc; then
		ewarn "You have emerged OpenRc without network support. This"
		ewarn "means you need to SET UP a network manager such as"
		ewarn "	net-misc/netifrc, net-misc/dhcpcd, net-misc/connman,"
		ewarn " net-misc/NetworkManager, or net-vpn/badvpn."
		ewarn "Or, you have the option of emerging openrc with the newnet"
		ewarn "use flag and configuring /etc/conf.d/network and"
		ewarn "/etc/conf.d/staticroute if you only use static interfaces."
		ewarn
	fi

	if use newnet && [ ! -e "${EROOT}"/etc/runlevels/boot/network ]; then
		ewarn "Please add the network service to your boot runlevel"
		ewarn "as soon as possible. Not doing so could leave you with a system"
		ewarn "without networking."
		ewarn
	fi

	# added for 0.45 to handle seedrng/urandom switching (2022-06-07)
	if ver_replacing -lt 0.45 && ! [[ -x $(type rc-update) ]]; then
		if rc-update show boot | grep -q urandom; then
			rc-update del urandom boot
			rc-update add seedrng boot
		fi
	fi
}
