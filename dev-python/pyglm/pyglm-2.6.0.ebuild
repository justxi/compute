# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 git-r3

DESCRIPTION="OpenGL Mathematics (GLM) library for Python"
HOMEPAGE="https://github.com/Zuzu-Typ/PyGLM"

LICENSE="Zlib"
SLOT="2.6"
KEYWORDS="~amd64"

EGIT_REPO_URI="https://github.com/Zuzu-Typ/PyGLM.git"
EGIT_COMMIT="2.6.0"
