# Copyright

EAPI=7

inherit cmake-utils

DESCRIPTION="Intel SYCL compiler"
HOMEPAGE="https://github.com/intel/llvm"

if [[ ${PV} == *9999 ]] ; then
        EGIT_REPO_URI="https://github.com/intel/llvm"
        EGIT_BRANCH="sycl"
	EGIT_COMMIT="3339c4579accc5b17304925a506b3bd27cebf95a"
        inherit git-r3
        S="${WORKDIR}/${P}"
        KEYWORDS="**"
fi

LICENSE=""
SLOT="0"
IUSE=""

# Intel´s SYCL need "cl_ext_intel.h"
RDEPEND="dev-libs/opencl-icd-loader"
DEPEND="${RDEPEND}
	dev-util/spirv-tools"

CMAKE_BUILD_TYPE=Release

CMAKE_USE_DIR=${S}/llvm

src_configure() {
        local mycmakeargs=(
                -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/intel-sycl"
                -DLLVM_TARGETS_TO_BUILD="X86"
		-DLLVM_EXTERNAL_PROJECTS="llvm-spirv;sycl"
		-DLLVM_ENABLE_PROJECTS="clang;llvm-spirv;sycl"
		-DLLVM_EXTERNAL_SYCL_SOURCE_DIR=${S}/sycl
		-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=${S}/llvm-spirv

		-DOpenCL_INCLUDE_DIR=/usr/lib64/OpenCL/vendors/opencl-icd-loader/include/
		-DOpenCL_LIBRARY=/usr/lib64/OpenCL/vendors/opencl-icd-loader/libOpenCL.so

                -DLLVM_VERSION_SUFFIX=sylc
                -DLLVM_INSTALL_UTILS=ON
		-DLLVM_BUILD_DOCS=NO
                -DLLVM_ENABLE_OCAMLDOC=OFF
                -DLLVM_ENABLE_SPHINX=NO
                -DLLVM_ENABLE_DOXYGEN=OFF
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/intel-sycl/share/man"
		-Wno-dev
        )

#                -DLLVM_ENABLE_EH=ON
#                -DLLVM_ENABLE_RTTI=ON

#        use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

        cmake-utils_src_configure
}
