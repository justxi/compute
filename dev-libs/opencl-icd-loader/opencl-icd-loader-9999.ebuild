EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Khronos OpenCL ICD Loader"
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-ICD-Loader"

EGIT_REPO_URI="https://github.com/KhronosGroup/OpenCL-ICD-Loader"
EGIT_BRANCH="master"
EGIT_COMMIT="e6e30ab9c7a61c171cf68d2e7f5c0ce28e2a4eae"

KEYWORDS="**"
LICENSE=""
SLOT="0"
IUSE="+khronos-headers"

RDEPEND=""
DEPEND="${RDEPEND}"

CMAKE_BUILD_TYPE=Release

S="${WORKDIR}/${P}"

src_unpack() {
        git-r3_fetch "${EGIT_REPO_URI}"
        git-r3_checkout "${EGIT_REPO_URI}"

	EGIT_COMMIT="0d5f18c6e7196863bc1557a693f1509adfcee056"
        git-r3_fetch "https://github.com/KhronosGroup/OpenCL-Headers"
        git-r3_checkout "https://github.com/KhronosGroup/OpenCL-Headers" "${WORKDIR}/OpenCL-Headers"

	mv "${WORKDIR}/OpenCL-Headers/CL" ${S}/inc || die "Can't move header files"
}

src_install() {
        default
	cmake-utils_src_install

        OCL_DIR="/usr/$(get_libdir)/OpenCL/vendors/opencl-icd-loader"
        dodir ${OCL_DIR}/{,include}

        # Install vendor library
        mv -f "${ED}/usr/$(get_libdir)"/libOpenCL* "${ED}${OCL_DIR}" || die "Can't install vendor library"

	chrpath -d "${BUILD_DIR}/test/driver_stub/libOpenCLDriverStub.so"
	cp "${BUILD_DIR}/test/driver_stub/libOpenCLDriverStub.so" "${ED}${OCL_DIR}" || "Can't install vendor library"

        # Install vendor headers
        if use khronos-headers; then
                cp -r "${S}/inc/CL" "${ED}${OCL_DIR}/include" || die "Can't install vendor headers"
        fi
}

pkg_postinst() {
        eselect opencl set --use-old ${PN}
}

