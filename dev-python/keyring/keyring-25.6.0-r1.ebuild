# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Provides access to the system keyring service"
HOMEPAGE="
	https://github.com/jaraco/keyring/
	https://pypi.org/project/keyring/
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/secretstorage-3.2[${PYTHON_USEDEP}]
	dev-python/jaraco-classes[${PYTHON_USEDEP}]
	dev-python/jaraco-context[${PYTHON_USEDEP}]
	dev-python/jaraco-functools[${PYTHON_USEDEP}]
	>=dev-python/jeepney-0.4.2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib-metadata-4.11.4[${PYTHON_USEDEP}]
	' 3.11)
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pyfakefs[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# this test fails if importlib-metadata returns more than one
		# entry, i.e. when keyring is installed already
		tests/test_packaging.py::test_entry_point
	)
	local EPYTEST_IGNORE=(
		# apparently does not unlock the keyring properly
		tests/backends/test_libsecret.py
		# hangs
		tests/backends/test_kwallet.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o addopts=
}
