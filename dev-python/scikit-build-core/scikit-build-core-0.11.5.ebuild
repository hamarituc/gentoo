# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Build backend for CMake based projects"
HOMEPAGE="
	https://github.com/scikit-build/scikit-build-core/
	https://pypi.org/project/scikit-build-core/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

# we always want [pyproject] extra
RDEPEND="
	app-alternatives/ninja
	dev-build/cmake
	>=dev-python/packaging-23.2[${PYTHON_USEDEP}]
	>=dev-python/pathspec-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/pyproject-metadata-0.5[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/build[${PYTHON_USEDEP}]
		>=dev-python/cattrs-22.2.0[${PYTHON_USEDEP}]
		dev-python/fastjsonschema[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
		>=dev-python/pytest-subprocess-1.5[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-subprocess )
distutils_enable_tests pytest

python_test() {
	local _EPYTEST_DESELECT=(
		# TODO / we don't package validate_pyproject anyway
		tests/test_schema.py::test_compare_schemas
	)
	local EPYTEST_IGNORE=(
		# needs unpackaged validate_pyproject
		tests/test_schema.py
	)

	epytest -m "not isolated and not network"
}
