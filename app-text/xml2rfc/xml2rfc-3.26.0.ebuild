# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Generates RFCs and IETF drafts from document source in XML"
HOMEPAGE="
	https://ietf-tools.github.io/xml2rfc/
	https://github.com/ietf-tools/xml2rfc/
	https://pypi.org/project/xml2rfc/
"
SRC_URI="
	https://github.com/ietf-tools/xml2rfc/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/platformdirs-3.6.0[${PYTHON_USEDEP}]
	dev-python/configargparse[${PYTHON_USEDEP}]
	dev-python/intervaltree[${PYTHON_USEDEP}]
	>=dev-python/google-i18n-address-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.1.2[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.1.1[${PYTHON_USEDEP}]
	dev-python/pycountry[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pypdf-3.2.1[${PYTHON_USEDEP}]
		dev-python/decorator[${PYTHON_USEDEP}]
		dev-python/dict2xml[${PYTHON_USEDEP}]
		dev-python/weasyprint[${PYTHON_USEDEP}]
		media-fonts/noto-cjk
	)
"

distutils_enable_tests unittest

src_prepare() {
	default
	# Disable broken PdfWriterTests.
	sed -i 's/ PdfWriterTests(unittest.TestCase):/ PdfWriterTests:/' test.py || die
}
