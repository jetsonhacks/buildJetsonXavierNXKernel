#!/bin/bash
# Get the kernel source for NVIDIA Jetson Xavier NX Developer Kit, L4T
# Copyright (c) 2016-2021 Jetsonhacks 
# MIT License

# Install the kernel source for L4T
source scripts/jetson_variables.sh
#Print Jetson version
echo "$JETSON_DESCRIPTION"
#Print Jetpack version
echo "Jetpack $JETSON_JETPACK [L4T $JETSON_L4T]"
#Print Kernel Version

SOURCE_TARGET="/usr/src"
L4TTarget="32.6.1"
KERNEL_RELEASE="4.9"

function usage
{
    echo "usage: ./getKernelSources.sh [[-d directory ] | [-h]]"
    echo "-h | --help  This message"
}

# Iterate through command line inputs
while [ "$1" != "" ]; do
    case $1 in
        -d | --directory )      shift
				SOURCE_TARGET=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
# e.g. echo "${red}The red tail hawk ${green}loves the green grass${reset}"

LAST="${SOURCE_TARGET: -1}"
if [ $LAST != '/' ] ; then
   SOURCE_TARGET="$SOURCE_TARGET""/"
fi

INSTALL_DIR=$PWD

# Error out if something goes wrong
set -e


# Check to make sure we're installing the correct kernel sources
if [ $JETSON_L4T != $L4TTarget ] ; then
   echo ""
   tput setaf 1
   echo "==== L4T Kernel Version Mismatch! ============="
   tput sgr0
   echo ""
   echo "This repository branch is for installing the kernel sources for L4T "$L4TTarget 
   echo "You are attempting to use these kernel sources on a L4T "$JETSON_L4T "system."
   echo "The kernel sources do not match their L4T release!"
   echo ""
   echo "Please git checkout the appropriate kernel sources for your release"
   echo " "
   echo "You can list the tagged versions."
   echo "$ git tag -l"
   echo "And then checkout the latest version: "
   echo "For example"
   echo "$ git checkout v1.0-L4T"$JETSON_L4T
   echo ""
   exit
fi

# Check to see if source tree is already installed
PROPOSED_SRC_PATH="$SOURCE_TARGET""kernel/kernel-"$KERNEL_RELEASE
echo "Proposed source path: ""$PROPOSED_SRC_PATH"
if [ -d "$PROPOSED_SRC_PATH" ]; then
  tput setaf 1
  echo "==== Kernel source appears to already be installed! =============== "
  tput sgr0
  echo "The kernel source appears to already be installed at: "
  echo "   ""$PROPOSED_SRC_PATH"
  echo "If you want to reinstall the source files, first remove the directories: "
  echo "  ""$SOURCE_TARGET""kernel"
  echo "  ""$SOURCE_TARGET""hardware"
  echo "then rerun this script"
  exit 1
fi

export SOURCE_TARGET
# -E preserves environment variables
sudo -E ./scripts/getKernelSources.sh


