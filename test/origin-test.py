#!/bin/python2
import os
csExePath = "./cs-bin/out/Debug/cs"
for test in filter(lambda x:x.find(".cs") == len(x)-3,os.listdir("case/")):
    test = "case/"+test
    print test
    os.system("%s -h case/test.hdf -c %s > %s" % (csExePath,test,test+".gold"))
        
    
