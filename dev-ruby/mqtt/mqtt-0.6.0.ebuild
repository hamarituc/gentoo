# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_GEMSPEC="mqtt.gemspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Pure Ruby gem that implements the MQTT protocol"
HOMEPAGE="https://github.com/njh/ruby-mqtt"
SRC_URI="https://github.com/njh/ruby-mqtt/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="ruby-${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#: ; /SimpleCov/,/^  end/ s:^:#:' spec/spec_helper.rb || die
}
