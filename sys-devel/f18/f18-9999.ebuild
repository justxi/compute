# Copyright

EAPI=7

inherit cmake-utils llvm

DESCRIPTION="F18 Fortran Compiler"
HOMEPAGE="https://github.com/flang-compiler/f18"

if [[ ${PV} == *9999 ]] ; then
        EGIT_REPO_URI="https://github.com/flang-compiler/f18"
        EGIT_BRANCH="master"
	EGIT_COMMIT="86ae6e6cc85c46958c2446d754650026ba26ff86"
        inherit git-r3
        KEYWORDS="**"
fi

LICENSE=""
SLOT="0"
IUSE="+debug"

DEPEND="${RDEPEND}"
RDEPEND="sys-devel/llvm"

CMAKE_MAKEFILE_GENERATOR="emake"

src_prepare() {
	sed -e "s:DESTINATION lib:DESTINATION lib64:" -i ${S}/lib/semantics/CMakeLists.txt
	sed -e "s:DESTINATION lib:DESTINATION lib64:" -i ${S}/lib/common/CMakeLists.txt
	sed -e "s:DESTINATION lib:DESTINATION lib64:" -i ${S}/lib/evaluate/CMakeLists.txt
	sed -e "s:DESTINATION lib:DESTINATION lib64:" -i ${S}/lib/parser/CMakeLists.txt
	sed -e "s:DESTINATION lib:DESTINATION lib64:" -i ${S}/lib/decimal/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {

	# this must be fixed
	CFLAGS=""
	CXXFLAGS=""
	LDFLAGS=""

	local llvm_prefix=$(get_llvm_prefix -b)
	local LLVM="${llvm_prefix}/lib64/cmake/llvm"

        local mycmakeargs=(
		-DLLVM_DIR=${llvm_prefix}
        )

	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

        cmake-utils_src_configure
}

src_compile() {
	# compiling with multiple cores consumes to much ram
	cd ${BUILD_DIR}
	make -j1
}
