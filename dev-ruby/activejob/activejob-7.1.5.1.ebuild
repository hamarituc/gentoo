# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Job framework with pluggable queues"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/globalid-0.3.6
"

ruby_add_bdepend "
	test? (
		dev-ruby/mocha
		dev-ruby/zeitwerk
	)"

all_ruby_prepare() {
	# Set test environment to our hand.
	sed -i -e '/load_paths/d' test/helper.rb || die "Unable to remove load paths"

	# Remove all currently unpackaged queues.
	sed -i -e 's/que queue_classic resque sidekiq sneakers sucker_punch backburner//' \
		-e 's/delayed_job//' Rakefile || die
	sed -i -e '/SneakersAdapter/ s:^:#:' test/cases/exceptions_test.rb || die
	rm -f test/cases/delayed_job_adapter_test.rb || die
}
