# Copyright

EAPI=7

inherit cmake-utils llvm

DESCRIPTION="F18 Fortran Compiler"
HOMEPAGE="https://github.com/flang-compiler/f18"

if [[ ${PV} == *9999 ]] ; then
        EGIT_REPO_URI="https://github.com/flang-compiler/f18"
        EGIT_BRANCH="master"
#	EGIT_COMMIT=""
        inherit git-r3
#        S="${WORKDIR}/${P}"
        KEYWORDS="**"
fi

LICENSE=""
SLOT="0"
IUSE=""

DEPEND="${RDEPEND}"
RDEPEND=""
# depend on llvm

CMAKE_BUILD_TYPE=Release
CMAKE_MAKEFILE_GENERATOR="emake"

src_configure() {

	local llvm_prefix=$(get_llvm_prefix -b)

	local LLVM="${llvm_prefix}/lib64/cmake/llvm"

        local mycmakeargs=(
		-DLLVM_DIR=${llvm_prefix}
        )
        cmake-utils_src_configure
}
