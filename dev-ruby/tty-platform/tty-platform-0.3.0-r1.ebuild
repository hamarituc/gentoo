# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="tty-platform.gemspec"

inherit ruby-fakegem

DESCRIPTION="Query methods for detecting different operating systems"
HOMEPAGE="https://github.com/piotrmurach/tty-platform"
SRC_URI="https://github.com/piotrmurach/tty-platform/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

all_ruby_prepare() {
	echo '-rspec_helper' > .rspec || die
}
