#!/usr/bin/python

from argparse import ArgumentParser
from lxml.html import parse

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("version",help='Version of Yocto Quick Start Guide to scrape.')
    parser.add_argument("dist",help='Distribution to scrape packages for.')
    args = parser.parse_args()
    
    #TODO: download page
    url = "http://www.yoctoproject.org/docs/%s/yocto-project-qs/yocto-project-qs.html" % args.version
    doc = parse(url)
    
    #find the distribution code block (there must be a less fragile method...
    dist = args.dist.lower()
    if(dist == 'ubuntu' or dist == 'debian'):
        text = doc.xpath('//*[@id="qs"]/div[3]/div[2]/div[3]/div[4]/div[3]/ul/li[1]/pre/text()')
        text = text[0].strip().replace('$ sudo apt-get install','').replace('\n','').replace('\\','')
        text = text.split()
        tmp = ''
        for pkg in text:
            tmp = tmp + pkg + ' '
        print tmp.strip()
    elif(dist == 'fedora'):
        text = doc.xpath('//*[@id="qs"]/div[3]/div[2]/div[3]/div[4]/div[3]/ul/li[2]/pre/text()')
        text = text[0].strip().replace('$ sudo dnf install','').replace('\n','').replace('\\','')
        text = text.split()
        tmp = ''
        for pkg in text:
            tmp = tmp + pkg + ' '
        print tmp.strip()
    elif(dist == 'opensuse' or dist == 'suse'):
        text = doc.xpath('//*[@id="qs"]/div[3]/div[2]/div[3]/div[4]/div[3]/ul/li[3]/pre/text()')
        text = text[0].strip().replace('$ sudo zypper install','').replace('\n','').replace('\\','')
        text = text.split()
        tmp = ''
        for pkg in text:
            tmp = tmp + pkg + ' '
        print tmp.strip()
    elif(dist == 'centos' or dist == 'redhat'):
        text = doc.xpath('//*[@id="qs"]/div[3]/div[2]/div[3]/div[4]/div[3]/ul/li[4]/pre/text()')
        text = text[0].strip().replace('$ sudo yum install','').replace('\n','').replace('\\','')
        text = text.split()
        tmp = ''
        for pkg in text:
            tmp = tmp + pkg + ' '
        print tmp.strip()
    else:
        exit(-1) #TODO:better error handling...
    