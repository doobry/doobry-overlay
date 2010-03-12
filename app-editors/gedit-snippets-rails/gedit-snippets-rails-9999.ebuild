# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git

DESCRIPTION="gedit smart indent plugin from gmate"
HOMEPAGE="http://blog.siverti.com.br/gmate/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/lexrupy/gmate.git"
EGIT_PROJECT="gmate"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-editors/gedit"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/gedit-2/plugins/snippets
	doins snippets/{erb,rhtml,rjs,rubyonrails}.xml
}