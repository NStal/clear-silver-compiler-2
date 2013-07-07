import os
csExePath = "./cs-bin/out/Debug/cs"

os.system("time %s -h case/efficient-test.hdf -c case/efficient-test.cs" % csExePath)

os.system("time ../lang/c/test/efficient-test.o case/efficient-test.hdf")
