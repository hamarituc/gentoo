# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Tool for extracting and creating optimised Xbox ISO images"
HOMEPAGE="https://sourceforge.net/projects/extract-xiso/"
if [[ ${PV} == *_p* ]] ; then
	SRC_URI="https://github.com/XboxDev/extract-xiso/archive/refs/tags/build-$(ver_cut 5).tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-build-$(ver_cut 5)
else
	SRC_URI="https://downloads.sourceforge.net/extract-xiso/${P}.tar.gz"
	S="${WORKDIR}"/${PN}
fi

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
