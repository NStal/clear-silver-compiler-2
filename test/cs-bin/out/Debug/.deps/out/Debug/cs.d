cmd_out/Debug/cs := flock out/Debug/linker.lock g++   -o out/Debug/cs -Wl,--start-group out/Debug/obj.target/cs/cs/cs.o out/Debug/obj.target/src/libneo.a -Wl,--end-group 
