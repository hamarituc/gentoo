# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DIST_AUTHOR=SUNDQUIST
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Google AdWords API Perl Client Library"
HOMEPAGE="https://github.com/googleads/googleads-perl-lib"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Class-Load
	dev-perl/Class-Std-Fast
	dev-perl/Crypt-OpenSSL-RSA
	dev-perl/Data-Uniqid
	dev-perl/TimeDate
	dev-perl/File-HomeDir
	dev-perl/HTTP-Server-Simple
	dev-perl/IO-Socket-SSL
	dev-perl/JSON-Parse
	dev-perl/LWP-Protocol-https
	dev-perl/libwww-perl
	dev-perl/Log-Log4perl
	dev-perl/Math-Random-MT
	>=dev-perl/SOAP-WSDL-2.00.10
	dev-perl/Template-Toolkit
	dev-perl/URI
	dev-perl/XML-LibXML
	dev-perl/XML-Simple
	dev-perl/XML-XPath
"

BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
	test? (
		dev-perl/Config-Properties
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		dev-perl/Test-MockObject
	)
"
