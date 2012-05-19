# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="New Relic Server Monitor Daemon"
HOMEPAGE="http://newrelic.com/features/server-monitoring"
SRC_URI="http://download.newrelic.com/server_monitor/release/${P}-linux.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-linux"

pkg_setup() {
	enewgroup newrelic
	enewuser newrelic -1 -1 -1 newrelic
}

src_install() {
	if [[ "${ARCH}" == "amd64" ]]; then
		NR_ARCH="x64"
	elif [[ "${ARCH}" == "x86" ]]; then
		NR_ARCH="x86"
	else
		die "Unsupported architecture (${ARCH})"
	fi

	dosbin "scripts/nrsysmond-config"
	newsbin "daemon/nrsysmond.${NR_ARCH}" "nrsysmond"
	newinitd "${FILESDIR}/newrelic-sysmond.initd" "newrelic-sysmond"

	keepdir "/etc/newrelic"
	insinto "/etc/newrelic"
	doins nrsysmond.cfg

	keepdir "/var/run/newrelic"
	fowners newrelic.newrelic "/var/run/newrelic"
	fperms 0775 "/var/run/newrelic"

	keepdir "/var/log/newrelic"
	fowners newrelic.newrelic "/var/log/newrelic"
	fperms 0775 "/var/log/newrelic"

	dodoc INSTALL.txt LICENSE.txt
}

pkg_postinst() {
	elog "Before starting the daemon you must set your license key with:"
	elog "    nrsysmond-config --set license_key=\$YOUR_KEY"
}

