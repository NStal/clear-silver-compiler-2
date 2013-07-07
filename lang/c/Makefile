all : target_source run_target


test: compile_test run_test

compile_test : test_hdf_parser

test_hdf_parser :
	gcc test/test_hdf_parser.c hdf_parser.c csc_primitive.c hdf.c csc_common.c csc_array.c csc_types.c -o test/test_hdf_parser.o -g -I ./ --std=c99 -O3

target_source : 
	gcc hdf_parser.c csc_primitive.c hdf.c csc_common.c csc_array.c csc_types.c csc_lib.c csc_resource.c ../../test/case/efficient-test.c -o test/efficient-test.o -I ./ --std=c99 -O3 -g -pg
run_target :
	./test/efficient-test.o ../../test/case/efficient-test.hdf
run_test : 
	./test/test_hdf_parser.o "test/test.hdf"
