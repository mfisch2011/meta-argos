#!/bin/bash

###################################################################
## Name: setup-development-env.sh
## Version: 0.1
## Description: This script automates most of the tasks required
## to setup a basic Yocto build/development environment and
## fetches and configures the meta-layers that Argos depends on
## and finally fetches and configures the Argos meta-layers.
##
## (TODO:expand coverage beyond 2.2 release)
## Supported distributions: 
## Ubuntu - 14.04, 14.10, 15.04, 16.04
## Fedora - 22, 23, 24
## CentOS - 7.x
## Debian - 8.x
## openSUSE - 13.2, 42.1
##
## Usage:
##
## Post Install Structure:
## poky/						- base build directory
## poky/openembbeded-core		- OE redhawk-sdr depedency
## poky/meta-oe					- OE redhawk-sdr depedency
## poky/meta-redhawk-sdr		- redhawk-sdr layer
## poky/meta-argos-core			- argos core framework
## poky/meta-argos-virtual-hud	- virtual HUD recipies for argos
##
## TODO List:
## 0. need an automated way to append BBLAYERS in 
##    build/config/bblayers.conf to make the build system aware
##    of the depedency layers that we add.
## 1. need to determine what happened to meta-redhawk-sdr and/or
##    find an alterative since it seems to have been removed.
## 2. check on lsb_release and uname deprecation
## 3. expand coverage to previous releases (i.e. support other
##    distribution versions)
## 4. refactor the OE meta-layer setup into a function (if there
##    truely is enough commonality to support this)
## 5. research if we truely need all of the redhawk-sdr layer since
##    we may not use all recipies.  is it possible to only pull in
##    what we will use?
###################################################################

UBUNTU_MORTY_DEPS="gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev xterm"

#had to modify.  both python and python3 should be deps.
FEDORA_MORTY_DEPS="gawk make wget tar bzip2 gzip python python3 unzip perl patch diffutils diffstat git cpp gcc gcc-c++ glibc-devel texinfo chrpath ccache perl-Data-Dumper perl-Text-ParseWords perl-Thread-Queue perl-bignum socat findutils which SDL-devel xterm"
SUSE_MORTY_DEPS="python gcc gcc-c++ git chrpath make wget python-xml diffstat makeinfo python-curses patch socat libSDL-devel xterm"
CENTOS_MORTY_DEPS="gawk make wget tar bzip2 gzip python unzip perl patch diffutils diffstat git cpp gcc gcc-c++ glibc-devel texinfo chrpath socat perl-Data-Dumper perl-Text-ParseWords perl-Thread-Queue SDL-devel xterm"

#query system for information
#can't use lsb_release because it's not installed by default for Fedora/Red Hat/CentOS
PRETTY_NAME=$(cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f2 | sed 's/"//g')
DISTRO=$(echo "$PRETTY_NAME" | cut -d ' ' -f1)
VERSION=$(echo "$PRETTY_NAME" | cut -d ' ' -f2)
BRANCH=""

#TODO:how to run sudo inside script because we can't run git or build as root...

#install dependencies
case "$DISTRO-$VERSION" in

Ubuntu-16.04*|Ubuntu-15.04*|Ubuntu-14.*)
#TODO: 
# debian-8* doesn't work it complains about missing python3
# may be easy to fix, but it doesn't jive with the 2.2 quick 
# start guide.
sudo apt-get install --yes $UBUNTU_MORTY_DEPS
status=$?
if [ $status -ne 0 ] ; then
  exit $status
fi
BRANCH="morty"
;;

Fedora-24|Fedora-23|Fedora-22)

#TODO:
# There is a problem with this!  The dependencies aren't correct.  Dependencies call for python3, but bitbake complains about missing python.  On link from python3 to python.
sudo dnf install --assumeyes $FEDORA_MORTY_DEPS
status=$?
if [ $status -ne 0 ] ; then
  exit $status
fi
BRANCH="morty"
;;

openSUSE-13.2|openSUSE-42.1)
sudo zypper install --yes $SUSE_MORTY_DEPS
status=$?
if [ $status -ne 0 ] ; then
  exit $status
fi
BRANCH="morty"
;;

CentOS-7.*)
sudo yum install --yes $CENTOS_MORTY_DEPS
status=$?
if [ $status -ne 0 ] ; then
  exit $status
fi
BRANCH="morty"
;;

*)
echo "Warning $DISTRO $VERSION is untested.  You may attempt a manual install, but exiting auto config script."
exit -1
;;

esac

#git poky and checkout the appropriate branch
git clone -b $BRANCH git://git.yoctoproject.org/poky
cd poky

#TODO:temp to test dependancy installation...
source oe-init-build-env
bitbake core-image-sato

#TODO:recipes and meta layers...