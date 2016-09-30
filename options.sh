#!/bin/bash

# Script configuration
REQUIRED_TOOLS="sed grep gawk"
LOGFILE=options.log

# Print usage instructions
function usage() {
    if [ ! -z "${TARGET_OS}${ENVIRONMENT}" ]; then
        echo "[WARNING] Only displaying help."
        echo "[WARNING] Additional options ignored."
        echo
    fi
    echo "Usage: ${SCRIPTNAME} [OPTION]..."
    echo "Demonstrate command line parsing in bash for Waratek build engineer exam."
    echo
    echo "-o, --operating-system    <rhel | sles>                Target operating system"
    echo "-b, --builder             <virtualbox | amazon-ebs>    Build environment"
    echo "-x, --xtrace                                           Enable script debugging"
    echo "-h, --help                                             Print this message"
    echo
    echo "Examples:"
    echo "    ${SCRIPTNAME} -o rhel -b virtualbox"
    echo
    echo "    ${SCRIPTNAME} --operating-system sles \ "
    echo "    ${SCRIPTNAME//?/ } --builder amazon-ebs    \ "
    echo "    ${SCRIPTNAME//?/ } --xtrace"
    echo
}

# Print error messages
function error() {
    ERR=$1
    shift
    echo -n "[ERROR] ${SCRIPTNAME}: "
    case ${ERR} in
        1)  echo "No options specified."
            ;;
        2)  echo "needs bash version 4 or greater. The current bash version is ${BASH_VERSION}."
            ;;
        3)  echo "Unknown parameter: $1"
            ;;
        4)  echo "Invalid target OS: $1"
            ;;
        5)  echo "Target OS specified without environment."
            ;;
        6)  echo "Invalid build environment: $1"
            ;;
        7)  echo "Build environment specified without target OS."
            ;;
        8)  echo "xtrace specified without target OS or build environment"
            ;;
        9)  echo "$1 required in path"
            ;;
        10) echo "Missing target OS or environment"
            ;;
        *)  echo "Undefined error"
            echo ${ERR}
            echo $*
            ;;
    esac
    echo
    echo "Run '${SCRIPTNAME} -h' for help."
    exit ${ERR}
}

SCRIPTNAME="$(basename $0)"

# Check bash version
if [ ${BASH_VERSION:0:1} -lt 4 ]; then
    error 2
fi

# Process parameters
[ -z "${1}" ] && error 1
while [ "$1" != "" ]; do
    case ${1,,} in
        "-o"|"--operating-system")
            TARGET_OS=${2,,}
            shift
            ;;
        "-b"|"--builder")
            ENVIRONMENT=${2,,}
            shift
            ;;
        "-x"|"--xtrace")
            DEBUG=true
            ;;
        "-?"|"-h"|"--help")
            DISPLAY_USAGE=true
            ;;
        *)
            error 3 $1
            ;;
    esac
    shift
done

if [ "${DISPLAY_USAGE}" == "true" ]; then
    usage
    exit
fi

# Validate parameters
if [ "${DEBUG}" == "true" ] && [ -z "${TARGET_OS}${ENVIRONMENT}" ]; then
    error 8
fi

if [ ! -z "${TARGET_OS}" ] && [ -z "${ENVIRONMENT}" ]; then
    error 5
fi

if [ ! -z "${ENVIRONMENT}" ] && [ -z "${TARGET_OS}" ]; then
    error 7
fi

if [ -z "${TARGET_OS}${ENVIRONMENT}" ]; then
    error 10
fi

if [ "${TARGET_OS}" != "sles" ] && [ "${TARGET_OS}" != "rhel" ]; then
    error 4 ${TARGET_OS}
fi

if [ "${ENVIRONMENT}" != "virtualbox" ] && [ "${ENVIRONMENT}" != "amazon-ebs" ]; then
    error 6 ${ENVIRONMENT}
fi

# Validate environment
for t in ${REQUIRED_TOOLS}; do
    which ${t} >>/dev/null
    [ $? -ne 0 ] && error 9 ${t}
done

# Enable logging
exec 1> >(sed -e "s/^/[$(date +%Y-%m-%d:%H:%M:%S)] /" | tee -a  ${LOGFILE} ) 2>&1

# Perform action
[ "${DEBUG}" == "true" ] && echo "xtrace on"
echo "Executing using:"
echo "    Target OS   = ${TARGET_OS}"
echo "    Environment = ${ENVIRONMENT}"
echo
echo "Done."
exit
