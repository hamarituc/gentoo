# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

UPSTREAM_PV=${PV/_/-}
UPSTREAM_PV=${UPSTREAM_PV/rc/RC}

DESCRIPTION="CLI to interact with Scala and Java"
HOMEPAGE="https://scala-cli.virtuslab.org/"
SRC_URI="
	!amd64? ( !arm64? (
		https://github.com/VirtusLab/scala-cli/releases/download/v${UPSTREAM_PV}/scala-cli
			-> scala-cli-non-native-${UPSTREAM_PV}
	) )
	amd64? (
		https://github.com/VirtusLab/scala-cli/releases/download/v${UPSTREAM_PV}/scala-cli-x86_64-pc-linux.gz
			-> scala-cli-amd64-${UPSTREAM_PV}.gz
	)
	arm64? (
		https://github.com/VirtusLab/scala-cli/releases/download/v${UPSTREAM_PV}/scala-cli-aarch64-pc-linux.gz
			-> scala-cli-arm64-${UPSTREAM_PV}.gz
	)
"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# A JRE is not strictly required if native images of scala-cli are used
# (amd64, arm64). However we may want a system JRE anyway, and having JRE
# in RDEPEND reduces the chances that scala-cli needs to install one
# for the user.
RDEPEND="
	>=virtual/jre-11
	sys-libs/zlib
"
BDEPEND="!amd64? ( !arm64? ( >=virtual/jre-11 ) )"

QA_TEXTRELS="*"
QA_FLAGS_IGNORED="/usr/bin/scala-cli"

src_prepare() {
	default

	if use amd64; then
		mv scala-cli-amd64-${UPSTREAM_PV} scala-cli || die
	elif use arm64; then
		mv scala-cli-arm64-${UPSTREAM_PV} scala-cli || die
	else
		mv scala-cli-non-native-${UPSTREAM_PV} scala-cli || die
	fi

	chmod +x scala-cli || die
}

src_compile() {
	for shell in bash zsh; do
		./scala-cli install-completions \
					--shell ${shell} \
					--env \
					--output "${S}" \
					> ${shell}-completion || die
	done
}

src_install() {
	dobin scala-cli

	newbashcomp bash-completion scala-cli

	insinto /usr/share/zsh/site-functions
	doins zsh/_scala-cli
}
