OPENMX_VERSION="3.9.7"
OPENMX_MA_REVISION=1
OPENMX_RELEASE_DATE=21Sep15

__NAME__=openmx
__VERSION__=${OPENMX_VERSION}
__MA_REVISION__=${OPENMX_MA_REVISION}

__VERSION_MM__=$(echo $__VERSION__ | cut -d. -f1,2)
__VERSION_PATCH__=$(echo $__VERSION__ | cut -d. -f3)
