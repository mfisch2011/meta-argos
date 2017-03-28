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
FEDORA_MORTY_DEPS="gawk make wget tar bzip2 gzip python3 unzip perl patch diffutils diffstat git cpp gcc gcc-c++ glibc-devel texinfo chrpath ccache perl-Data-Dumper perl-Text-ParseWords perl-Thread-Queue perl-bignum socat findutils which SDL-devel xterm"
SUSE_MORTY_DEPS="python gcc gcc-c++ git chrpath make wget python-xml diffstat makeinfo python-curses patch socat libSDL-devel xterm"
CENTOS_MORTY_DEPS="gawk make wget tar bzip2 gzip python unzip perl patch diffutils diffstat git cpp gcc gcc-c++ glibc-devel texinfo chrpath socat perl-Data-Dumper perl-Text-ParseWords perl-Thread-Queue SDL-devel xterm"

#query system for information
DISTRO=$(lsb_release -i | cut -d ':' -f2 | sed -e 's/^[ \t]*//')
VER=$(lsb_release -r | cut -d ':' -f2 | sed -e 's/^[ \t]*//')
BRANCH=""

#TODO:how to run sudo inside script because we can't run git or build as root...

#install dependencies
case "$DISTRO-$VERSION" in

Ubuntu-16.04)
Ubuntu-15.04)
Ubuntu-14.*)
Debian-8.*)
sudo apt-get install --yes $UBUNTU_MORTY_DEPS
BRANCH="morty"
;;

Fedora-24)
Fedora-23)
Fedora-22)
sudo dnf install --yes $FEDORA_MORTY_DEPS
BRANCH="morty"
;;

openSUSE-13.2)
openSUSE-42.1)
sudo zypper install --yes $SUSE_MORTY_DEPS
BRANCH="morty"
;;

CentOS-7.*)
sudo yum install --yes $CENTOS_MORTY_DEPS
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