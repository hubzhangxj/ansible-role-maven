#!/bin/bash

#CURDIR=$(cd `dirname $0`; pwd)
#set in configure.yml responding to scripts
#echo "export MAVEN_HOME=/usr/local/maven/apache-maven-3.3.9" >> /etc/profile
#echo "export PATH=$PATH:$MAVEN_HOME/bin" >> /etc/profile

##################################################################################
# Const Variables, PATH
###################################################################################
export LANG=C
export LC_ALL=C

SITE='tests/test.yml'
DEBUG=''
bench_build=`filename ${0}`
INVENTORY='tests/inventory'
REMOTE_USER='root'
EXTRA_VARS='ansible_sudo_pass=root'
###################################################################################
# Usage
###################################################################################
Usage()
{

cat << EOF
Usage: ./${bench_build} [options]
Options:
	-h, --help: Display help information
	-i INVENTORY, --inventory-file=INVENTORY
                        specify inventory host path
                        (default=/etc/ansible/hosts)
	-u REMOTE_USER, --user=REMOTE_USER
			connect as this user (default=None)
	-e EXTRA_VARS, --extra-vars=EXTRA_VARS
                        set additional variables as key=value or YAML/JSON
	-v, --verbose   verbose mode (-vvv for more, -vvvv to enable
                        connection debugging)
Example:
	./${bench_build} --help
	./estuary/build.sh clean --builddir=./workspace
	./sailing/build.sh --builddir=./workspace --deploy=iso -a Estuary
	./sailing/build.sh --builddir=./workspace --deploy=iso -a China
	./sailing/build.sh --builddir=./workspace --deploy=usb:/dev/sdb --deploy=iso
	./sailing/build.sh --builddir=./workspace --distro=Ubuntu,CentOS  --capacity=50,50 --deploy=usb:/dev/sdb --deploy=iso
EOF
}	
	
###################################################################################
# Get all args
###################################################################################

while test $# != 0
do
        case $1 in
        	--*=*) ac_option=`expr "X$1" : 'X\([^=]*\)='` ; ac_optarg=`expr "X$1" : 'X[^=]*=\(.*\)'` ; ac_shift=: ;;
        	-*) ac_option=$1 ; ac_optarg=$2; ac_shift=shift ;;
        	*) ac_option=$1 ; ac_shift=: ;;
        esac

        case $ac_option in
                clean) CLEAN=yes ;;
                -h | --help) Usage ; exit 0 ;;
		-i | --inventory-file) INVENTORY=$ac_optarg ;;
                -u | --user) REMOTE_USER=$ac_optarg ;;
		--capacity) CAPACITY=$ac_optarg ;;
		-e | --extra-vars) EXTRA_VARS=$ac_optarg ;;
                #-a) if [ x"$ac_optarg" = x"China" ]; then DOWNLOAD_FTP_ADDR=$CHINA_INTERAL_FTP_ADDR; fi ;;
                *) Usage ; echo "Unknown option $1" ; exit 1 ;;
        esac
	
        $ac_shift
        shift
done

###################################################################################
# Deployment benchmark
###################################################################################
benchmark_deploy()
{
    source /etc/profile
    #pushd ../../ > /dev/null
    ansible-playbook -i ${INVENTORY} ${SITE} ${DEBUG} --user=${REMOTE_USER} --extra-vars=${EXTRA_VARS} 
    #popd > /dev/null
}

if ! benchmark_deploy; then
	echo -e "\033[31mError! Benchmark deploy failed!\033[0m" ; exit 1
fi
