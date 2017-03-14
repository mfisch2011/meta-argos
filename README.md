# Argos Core Components

The meta-argos layer provides the OpenEmbedded layer for the 
components of the Argos project.  The source code and design 
files for the components are in separate repositories.

## Component Layers

### meta-core
The recipe for the enhanced domain controller application and a 
minimal console image.

### meta-virtual-hud
The recipe for the virtual Heads Up Display (HUD) device and an 
image suitable for supporting 3D rendering.

## Install and Setup
### Automated setup

Download and run setup-development-env.sh from (URL TBD).  This will
install the required depedencies, the latest Yocto project for
supported distributions, the required OpenEmbedded (OE) layers, and
the Argos OE layers.

### Manual Setup 

#### Yocto Setup

Follow the Yocto Quick Start guide appropriate for your system.  The 
table below identifies the version of the Quick Start Guide and Poky
release for supported distributions and versions.

##### Poky 2.2 (aka morty branch)
Quick Start Guide: http://www.yoctoproject.org/docs/2.2/yocto-project-qs/yocto-project-qs.html

CentOS/RedHat: 7.x

Debian/GNU Linux: 8.x

Fedora: 22, 23, 24

openSUSE: 13.2, 42.1

Ubuntu: 14.04, 14.10, 15.04, 15.10, 16.04

TODO:add other Poky releases


#### Required OpenEmbedded Layers

In the Yocto root directory execute the following: 

git clone -b morty git://git.openembedded.org/openembedded-core 

git clone -b morty git://git.openembedded.org/meta-openembedded 

git clone -b morty git://github.com/geontech/meta-redhawk-sdr.git 

#### Argos Components

git clone git://github.com/mfisch2011/meta-argos-core.git

Then edit your build/conf/bblayers.conf to include a reference to 
meta-argos-core at the end of the list.

## Initialize Build Environment and Build Test Image

source oe-init-build-env

bitbake core-minimal-image

## Run Test Image

runqemu qemux86

TODO: Provide instructions about entering/exiting virtual instance.
