#!/usr/bin/python

import glob
from os import remove
import unittest
from metapackage import NSControl
from subprocess import call
from subprocess import check_output

def grep(lines,str2):
    for line in lines:
        if str2 in line:
            return line


class TestMetaPackage(unittest.TestCase):
    
    def test_Name(self):
        ctrl = NSControl()
        ctrl.setName('testName1')
        self.assertEqual('testName1', ctrl.getName(),'Failed getName')
        
    def test_Description(self):
        ctrl = NSControl()
        ctrl.setDescription('This is a test description.')
        self.assertEqual('This is a test description.',ctrl.getDescription(),'Failed getDescription')
        
    def test_Maintainer(self):
        ctrl = NSControl()
        ctrl.setMaintainer('Test Maintainer <test.maintainer@gmail.com>')
        self.assertEqual('Test Maintainer <test.maintainer@gmail.com>',ctrl.getMaintainer(),'Failed getMaintainer')
        
    def test_Version(self):
        ctrl = NSControl()
        ctrl.setVersion('1.12a')
        self.assertEqual('1.12a',ctrl.getVersion(),'Failed getVersion')
    
    def test_Packages(self):
        ctrl = NSControl()
        pkgs = ['test1','test2','test3']
        ctrl.setPackages(pkgs)
        self.assertEqual(pkgs,ctrl.getPackages(),'Failed getPackages')
    
    def test_Section(self):
        ctrl = NSControl()
        ctrl.setSection('TestSection')
        self.assertEqual('TestSection',ctrl.getSection(),'Failed getSection')
    
    def test_Application1(self):
        cmds = ['./meta-package','test-pkg','1.0','test1','test2','test3']
        call(cmds)
        test = check_output(['dpkg','-I','test-pkg_1.0_all.deb'])
        test = test.split('\n')
        self.assertEqual(' Package: test-pkg',grep(test,'Package: '))
        self.assertEqual(' Version: 1.0',grep(test,'Version: '))
        self.assertEqual(' Depends: test1, test2, test3',grep(test,'Depends: '))
        self.assertIsNone(grep(test,'Maintainer: '))
        self.assertIsNone(grep(test,'Description: '))
        for f in glob.glob("test-pkg*.deb"):
            remove(f)
            
    def test_Application2a(self):
        cmds = ['./meta-package','-m','Test Maintainer <test.maintainer@gmail.com>','test-pkg','2.0a','test4','test5','test6']
        call(cmds)
        test = check_output(['dpkg','-I','test-pkg_2.0a_all.deb'])
        test = test.split('\n')
        self.assertEqual(' Package: test-pkg',grep(test,'Package: '))
        self.assertEqual(' Version: 2.0a',grep(test,'Version: '))
        self.assertEqual(' Depends: test4, test5, test6',grep(test,'Depends: '))
        self.assertEqual(' Maintainer: Test Maintainer <test.maintainer@gmail.com>',grep(test,'Maintainer: '))
        self.assertIsNone(grep(test,'Description: '))
        for f in glob.glob("test-pkg*.deb"):
            remove(f)

    def test_Application2b(self):
        cmds = ['./meta-package','--maintainer','Test Maintainer <test.maintainer@gmail.com>','test-pkg','2.0b','test4','test5','test6']
        call(cmds)
        test = check_output(['dpkg','-I','test-pkg_2.0b_all.deb'])
        test = test.split('\n')
        self.assertEqual(' Package: test-pkg',grep(test,'Package: '))
        self.assertEqual(' Version: 2.0b',grep(test,'Version: '))
        self.assertEqual(' Depends: test4, test5, test6',grep(test,'Depends: '))
        self.assertEqual(' Maintainer: Test Maintainer <test.maintainer@gmail.com>',grep(test,'Maintainer: '))
        self.assertIsNone(grep(test,'Description: '))
        for f in glob.glob("test-pkg*.deb"):
            remove(f)

    def test_Application3a(self):
        cmds = ['./meta-package','-d','Test description.','test-pkg','3.0a','test1','test2','test3']
        call(cmds)
        test = check_output(['dpkg','-I','test-pkg_3.0a_all.deb'])
        test = test.split('\n')
        self.assertEqual(' Package: test-pkg',grep(test,'Package: '))
        self.assertEqual(' Version: 3.0a',grep(test,'Version: '))
        self.assertEqual(' Depends: test1, test2, test3',grep(test,'Depends: '))
        self.assertIsNone(grep(test,'Maintainer: '))
        self.assertEqual(' Description: Test description.',grep(test,'Description: '))
        for f in glob.glob("test-pkg*.deb"):
            remove(f)

    def test_Application3b(self):
        cmds = ['./meta-package','--description','Test description.','test-pkg','3.0b','test1','test2','test3']
        call(cmds)
        test = check_output(['dpkg','-I','test-pkg_3.0b_all.deb'])
        test = test.split('\n')
        self.assertEqual(' Package: test-pkg',grep(test,'Package: '))
        self.assertEqual(' Version: 3.0b',grep(test,'Version: '))
        self.assertEqual(' Depends: test1, test2, test3',grep(test,'Depends: '))
        self.assertIsNone(grep(test,'Maintainer: '))
        self.assertEqual(' Description: Test description.',grep(test,'Description: '))
        for f in glob.glob("test-pkg*.deb"):
            remove(f)
    
    #TODO: are there any other tests that we need to run?
            
if __name__ == '__main__':
    unittest.main()