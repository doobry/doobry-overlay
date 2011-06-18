# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

USE_RUBY="ruby18 ruby19 ree18"
RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="Web-flow and rendering framework putting the VC in MVC (part of Rails)."
HOMEPAGE="http://www.rubyonrails.org"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

ruby_add_rdepend "
~dev-ruby/activesupport-3.0.8
~dev-ruby/activemodel-3.0.8
>=dev-ruby/builder-2.1.2
<dev-ruby/builder-2.2
>=dev-ruby/i18n-0.5.0
<dev-ruby/i18n-0.6
>=dev-ruby/rack-1.2.1
<dev-ruby/rack-1.3
>=dev-ruby/rack-test-0.5.7
<dev-ruby/rack-test-0.6
>=dev-ruby/rack-mount-0.6.14
<dev-ruby/rack-mount-0.7
>=dev-ruby/tzinfo-0.3.23
<dev-ruby/tzinfo-0.4
>=dev-ruby/erubis-2.6.6
<dev-ruby/erubis-2.7
"

each_ruby_configure() {
	RUBY_FAKEGEM_EXTENSIONS=$(${RUBY} -r yaml -e "puts Gem::Specification.from_yaml(File::open('../metadata')).extensions")
	for e in ${RUBY_FAKEGEM_EXTENSIONS}; do
		local d=$(dirname ${e})
		if [ -e ${d}/extconf.rb ]; then
			${RUBY} -C${d} extconf.rb || die
		else
			ewarn "This gem has a extension that will not be built and so may not work."
		fi
	done
}

each_ruby_compile() {
	for e in ${RUBY_FAKEGEM_EXTENSIONS}; do
		local d=$(dirname ${e})
		if [ -e ${d}/extconf.rb ]; then
			emake -C$d || die
		fi
	done
}

each_ruby_install() {
	each_fakegem_install
	for e in ${RUBY_FAKEGEM_EXTENSIONS}; do
		local d=$(dirname ${e})
		if [ -e ${d}/extconf.rb ]; then
			sitearchdir=${D}/$(ruby_fakegem_gemsdir)/gems/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}/lib emake -e -C$d install-so
		fi
	done
}

ruby_fakegem_binwrapper() {
	(
		local gembinary=$1
		local newbinary=${2:-/usr/bin/$gembinary}
		local relativegembinary=${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}/bin/${gembinary}
		local binpath=$(dirname $newbinary)
		[[ ${binpath} = . ]] && binpath=/usr/bin

		local rubycmd=
		for implementation in ${USE_RUBY}; do
			use ruby_targets_${implementation} || continue
			if [ -z $rubycmd ]; then
				rubycmd="$(ruby_implementation_command ${implementation})"
			else
				rubycmd="/usr/bin/env ruby"
				break
			fi
		done

		cat - > "${T}"/gembin-wrapper-${gembinary} <<EOF
#!${rubycmd}
require 'rubygems'

version = ">= 0"

if ARGV.first =~ /^_(.*)_\$/ and Gem::Version.correct? \$1 then
  version = \$1
  ARGV.shift
end

gem '${RUBY_FAKEGEM_NAME}', version
load Gem.bin_path('${RUBY_FAKEGEM_NAME}', '${gembinary}', version)

EOF

		exeinto ${binpath:-/usr/bin}
		newexe "${T}"/gembin-wrapper-${gembinary} $(basename $newbinary)
	) || die "Unable to create fakegem wrapper"
}
