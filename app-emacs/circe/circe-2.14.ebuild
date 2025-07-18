# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A great IRC client for Emacs"
HOMEPAGE="https://github.com/jorgenschaefer/circe
	https://www.emacswiki.org/emacs/Circe"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/jorgenschaefer/${PN}"
else
	SRC_URI="https://github.com/jorgenschaefer/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 ppc sparc x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( AUTHORS.md CONTRIBUTING.md NEWS.md README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup "${S}"
