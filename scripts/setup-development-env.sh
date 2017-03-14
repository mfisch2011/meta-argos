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

#query system for information
#TODO:will uname ever be deprecated in favor of lsb_release?  
#right now maintain for compatibility
DISTRO=$(uname -s)
ARCH=$(uname -m)
VER=$(uname -r)

#install dependencies
case
Ubuntu)
	#TODO:add VER variations...
	#TODO:there used to be a warning about lib-css and special
	#instructions to remove and setup deps in apt, but it's
	#disappeared.  may be a bit of fiddling to figure this out
	
	apt-get install --yes gawk wget git-core diffstat unzip \
	texinfo gcc-multilib build-essential chrpath socat 
	libsdl1.2-dev xterm
	;;
Fedora)
	dnf install --yes gawk make wget tar bzip2 gzip python3 \
	unzip perl patch diffutils diffstat git cpp gcc gcc-c++ \
	glibc-devel texinfo chrpath ccache perl-Data-Dumper \
	perl-Text-ParseWords perl-Thread-Queue perl-bignum socat \
	findutils which SDL-devel xterm
	;;
openSUSE)
	zypper install --yes python gcc gcc-c++ git chrpath make \
	wget python-xml diffstat makeinfo python-curses patch socat \
	libSDL-devel xterm
	;;
CentOS)
RedHat)
	yum install --yes gawk make wget tar bzip2 gzip python unzip \
	perl patch diffutils diffstat git cpp gcc gcc-c++ glibc-devel \
	texinfo chrpath socat perl-Data-Dumper perl-Text-ParseWords \
	perl-Thread-Queue SDL-devel xterm
	;;
*)
echo "Warning untested OS.  You may attempt a manual install, but exiting auto config script."
exit -1
	;;
esac

#git poky and checkout morty branch
git clone -b morty git://git.yoctoproject.org/poky

#get redhawk-sdr depedencies
git clone -b morty git://git.openembedded.org/openembedded-core poky/openembedded-core
git clone -b morty git://git.openembedded.org/meta-openembedded poky/meta-oe

#git redhawk-sdr meta-layer
git clone -b morty http://github.com/GeonTech/meta-redhawk-sdr.git poky/meta-redhawk-sdr

#git argos repository and link into poky build tree
git clone https://github.com/mfisch2011/meta-argos.git poky/meta-argos
