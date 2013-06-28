#ifndef _HDF_PARSER_H_
#define _HDF_PARSER_H_

#include "csc_core.h"
#include "hdf.h"
#define HDF_VALUE_TYPE_NUMBER 0
#define HDF_VALUE_TYPE_STRING 1
#define HDF_VALUE_TYPE_REFER 2
//though INT32 for a type tag is a little big luxury
//but for memory pack it's fast
#define isNumberNode(n) ((n).type == HDF_VALUE_TYPE_NUMBER)
#define isStringNode(n) ((n).type == HDF_VALUE_TYPE_STRING)
#define isReferNode(n) ((n).type == HDF_VALUE_TYPE_REFER)

void parseHdf(csc_string string,HdfPool* pool);

#endif /* _HDF_PARSER_H_ */
