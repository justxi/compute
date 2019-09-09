# Coptyright
#

EAPI=7

HOMEPAGE="https://github.com/intel/llvm/"
SRC_URI="https://github.com/intel/llvm/releases/download/2019-08/oclcpuexp-2019.8.7.0.0725_rel.tar.gz"

KEYWORDS="~amd64"
SLOT="0"
LICENSE=""

S=${WORKDIR}

src_install() {
        insinto /opt/intel/oclcpuexp/x64
        insopts -m 755
        doins "${WORKDIR}"/x64/*

	dodir /etc/OpenCL/vendors
	echo "/opt/intel/oclcpuexp/x64/libintelocl.so" > ${D}/etc/OpenCL/vendors/intel_expcpu.icd
	dodir /etc/ld.so.conf.d
	echo "/opt/intel/oclcpuexp/x64" > ${D}/etc/ld.so.conf.d/libintelopenclexp.conf
}
