# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

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
IUSE="cuda debug headers hsa spirv"

RDEPEND="dev-libs/libltdl
	!cuda? ( >=sys-devel/clang-6.0 )
	cuda? ( >=sys-devel/clang-6.0[llvm_targets_NVPTX] )
	hsa? ( >=sys-devel/clang-9.0[llvm_targets_AMDGPU] )
	spirv? ( >=dev-util/spirv-llvm-translator-8.0[test,tools] )
	debug? ( dev-util/lttng-ust )
	sys-apps/hwloc[cuda?]
	app-eselect/eselect-opencl"
DEPEND="${RDEPEND}
	dev-libs/ocl-icd
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DENABLE_CUDA=$(usex cuda)
		-DINSTALL_OPENCL_HEADERS=$(usex headers)
	)

	if use hsa; then
		mycmakeargs+=(
			-DENABLE_HSA=ON
			-DWITH_HSA_RUNTIME_DIR=/usr/
			-DWITH_HSA_RUNTIME_INCLUDE_DIR=/usr/include/hsa
			-DENABLE_HSAIL=OFF
		)
	fi

	if use spirv; then
		mycmakeargs+=(
			-DLLVM_SPIRV=/usr/lib/llvm/9/bin/llvm-spirv
		)
	fi

	cmake-utils_src_configure
}
