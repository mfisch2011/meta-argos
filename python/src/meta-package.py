#!/usr/bin/python

#TODO:application documentation

#TODO:imports
import argparse
import os
from subprocess import call

#TODO:class documentation
class NSControl:
    
    _maintainer = ''
    _packages = []
    _version = 0.1
    _name = ''
    _description = ''
    _section = 'misc'
    
    def __init__(self):
        self._packages = []
        self._version = 0.1
        self._description = ''
        self._name = ''
        self._section = 'misc'
    
    def getPackages(self):
        return self._packages
    
    def setPackages(self,pkgs):
        #TODO:validate pkgs???
        self._packages = pkgs

    def getVersion(self):
        return self._version
    
    def setVersion(self,version):
        #TODO:validate version???
        self._version = version

    def getName(self):
        return self._name
    
    def setName(self,name):
        #TODO:validate name
        self._name = name
        
    def getDescription(self):
        return self._description
    
    def setDescription(self,description):
        #TODO:validate description
        self._description = description
        
    def getMaintainer(self):
        return self._maintainer
    
    def setMaintainer(self,maintainer):
        #TODO:validate maintainer
        self._maintainer = maintainer

    def build(self):
        tmpDir = "/tmp/" + self._name
        
        #build the temp directory
        if not os.path.exists(tmpDir):
            os.makedirs(tmpDir)
        
        #build the ns-control file
        f = open(tmpDir + "/ns-control",'w')
        f.write("Section: %s\n" % self._section)
        f.write("Standards-Version: 3.9.1\n\n")
        f.write("Package: %s\n" % self._name)
        f.write("Version: %s\n" % self._version)
        f.write("Maintainer: %s\n" % self._maintainer)
        pkgs =""
        for pkg in self._packages:
            pkgs = pkgs + pkg + ", "
        
        if(len(pkgs)>2):
            pkgs = pkgs[:-2]
        f.write("Depends: %s\n" % pkgs)
        f.write("Description: %s\n" % self._description)
        f.write("Files:\n")
        f.close()
        
        #build the .deb file
        call(['equivs-build',tmpDir+'/ns-control'])

#application command line execution...
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-d','--description',help="Description for the meta-package.")
    parser.add_argument('-m','--maintainer',help="Maintainer for the meta-package {Name} <e-mail address>")
    parser.add_argument('name',help="Name of the meta-package to build.")
    parser.add_argument('version',help='Package version to build.')
    parser.add_argument('packages',metavar='PKG',type=str,nargs='+',help='package to add to meta-package')
    args = parser.parse_args()
        
    ctrl = NSControl()
    ctrl.setName(args.name)
    if(args.description is not None):
        ctrl.setDescription(args.description)
    if(args.maintainer is not None):
        ctrl.setMaintainer(args.maintainer)
    ctrl.setPackages(args.packages)
    ctrl.setVersion(args.version)
    ctrl.build()
    