# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Portable Computing Language (an implementation of OpenCL)"
HOMEPAGE="http://portablecl.org"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pocl/${PN}"
else
	SRC_URI="https://github.com/pocl/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="cuda headers debug"

RDEPEND="dev-libs/libltdl
	!cuda? ( >=sys-devel/clang-6.0 )
	cuda? ( >=sys-devel/clang-6.0[llvm_targets_NVPTX] )
	debug? ( dev-util/lttng-ust )
	sys-apps/hwloc[cuda?]
	app-eselect/eselect-opencl"
DEPEND="${RDEPEND}
	dev-libs/ocl-icd
	virtual/pkgconfig"

PATCHES=("${FILESDIR}/install_option.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_CUDA=$(usex cuda)
		-DINSTALL_OPENCL_HEADERS=$(usex headers)
	)

	cmake-utils_src_configure
}
