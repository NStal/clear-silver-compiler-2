#ifndef _CSC_TYPES_H_
#define _CSC_TYPES_H_
#include "csc_primitive.h"
#include "csc_hdf.h"
#pragma pack(push)
#pragma pack(1)

struct HdfNode;
typedef struct csc_hdfRefer {
  csc_string query;        //4byte
  struct HdfNode* hdfNode; //4byte
}csc_hdfRefer;             //8byte

typedef struct CSNumber {
  INT32 type;
  csc_int number;
} CSNumber;

typedef struct CSString {
  INT32 type;
  csc_string string;
} CSString;

typedef struct CSRefer {
  INT32 type;
  csc_hdfRefer refer;
} CSRefer;

typedef union CSValue {
  INT32 type;
  CSNumber asNumber;
  CSString asString;
  CSRefer asRefer;
}CSValue;

typedef struct HdfNode{
  csc_array children;
  union CSValue value;
}HdfNode;
;
#pragma pack(pop)

#endif /* _CSC_TYPES_H_ */
