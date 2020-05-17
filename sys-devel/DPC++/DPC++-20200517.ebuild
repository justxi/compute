# Copyright

EAPI=7

inherit cmake-utils

DESCRIPTION="Intel DPC++ compiler"
HOMEPAGE="https://github.com/intel/llvm"
SRC_URI="https://github.com/intel/llvm/archive/${PV}.tar.gz -> Intel-DPC++-${PV}.tar.gz"

KEYWORDS="**"

LICENSE=""
SLOT="0"
IUSE="cuda"

# Intel´s SYCL need "cl_ext_intel.h"
RDEPEND="dev-libs/ocl-icd
	cuda? ( >=dev-util/nvidia-cuda-toolkit-10.1 )"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-lang/python:2.7
	dev-util/spirv-tools"

CMAKE_BUILD_TYPE=Release

S=${WORKDIR}/llvm-${PV}

CMAKE_USE_DIR=${S}/llvm

src_configure() {

	llvm_targets_to_build="X86"
	sycl_build_pi_cuda="OFF"

	if use cuda; then
		llvm_targets_to_build+=";NVPTX"
		sycl_build_pi_cuda="ON"
	fi

        local mycmakeargs=(
		-DLLVM_ENABLE_ASSERTIONS=ON
                -DLLVM_TARGETS_TO_BUILD=${llvm_targets_to_build}
		-DLLVM_EXTERNAL_PROJECTS="sycl;llvm-spirv;opencl-aot;xpti;libdevice"
		-DLLVM_EXTERNAL_SYCL_SOURCE_DIR=${S}/sycl
		-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=${S}/llvm-spirv
		-DLLVM_EXTERNAL_XPTI_SOURCE_DIR=${S}/xpti
		-DLLVM_EXTERNAL_LIBDEVICE_SOURCE_DIR=${S}/libdevice
		-DLLVM_ENABLE_PROJECTS="clang;llvm-spirv;sycl;opencl-aot;xpti;libdevice"
		-DLIBCLC_TARGETS_TO_BUILD=""
		-DSYCL_BUILD_PI_CUDA=${sycl_build_pi_cuda}
		-DLLVM_BUILD_TOOLS=ON
		-DSYCL_ENABLE_WERROR=ON
                -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/intel-sycl"
		-DSYCL_INCLUDE_TESTS=ON
                -DLLVM_ENABLE_DOXYGEN=OFF
                -DLLVM_ENABLE_SPHINX=OFF
		-DBUILD_SHARED_LIBS=OFF
		-DSYCL_ENABLE_XPTI_TRACING=ON
		-DOpenCL_INCLUDE_DIR=/usr/include/
		-DOpenCL_LIBRARY=/usr/lib64/libOpenCL.so.1.0.0
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/intel-sycl/share/man"
		-Wno-dev
        )

#               -DLLVM_VERSION_SUFFIX=sylc

#               -DLLVM_INSTALL_UTILS=ON
#		-DLLVM_BUILD_DOCS=NO

#               -DLLVM_ENABLE_EH=ON
#               -DLLVM_ENABLE_RTTI=ON

#        use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

        cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile deploy-sycl-toolchain deploy-opencl-aot
}




