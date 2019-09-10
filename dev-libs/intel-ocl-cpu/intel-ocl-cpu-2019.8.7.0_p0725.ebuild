# Coptyright
#

EAPI=7

DESCRIPTION="Experimental Intel CPU Runtime for OpenCL™ Applications with SYCL support"
HOMEPAGE="https://github.com/intel/llvm/"
SRC_URI="https://github.com/intel/llvm/releases/download/2019-08/oclcpuexp-2019.8.7.0.0725_rel.tar.gz"

KEYWORDS="~amd64"
SLOT="0"
LICENSE=""

S=${WORKDIR}

pkg_nofetch() {
        einfo "Please download the package"
        einfo
        einfo "    ${SRC_URI}"
        einfo
        einfo "and place into your distfiles directory."
}

src_install() {
        insinto /opt/intel/oclcpuexp/x64
        insopts -m 755
        doins "${WORKDIR}"/x64/*

	dodir /etc/OpenCL/vendors
	echo "/opt/intel/oclcpuexp/x64/libintelocl.so" > ${D}/etc/OpenCL/vendors/intel_expcpu.icd
	dodir /etc/ld.so.conf.d
	echo "/opt/intel/oclcpuexp/x64" > ${D}/etc/ld.so.conf.d/libintelopenclexp.conf
}
