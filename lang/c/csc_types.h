#ifndef _CSC_TYPES_H_
#define _CSC_TYPES_H_
#include "csc_primitive.h"
#include "csc_hdf.h"
#include "csc_array.h"
#pragma pack(push)
#pragma pack(1)
#define CS_TYPE_UNDEFINED 0
#define CS_TYPE_STRING 1
#define CS_TYPE_REFER 2
#define CS_TYPE_NUMBER 3
struct HdfNode;
typedef struct csc_hdfRefer {
  csc_string* query;        //4byte
  struct HdfNode* hdfNode; //4byte
}csc_hdfRefer;             //8byte

typedef struct CSNumber {
  INT32 type;
  csc_int number;
} CSNumber;

typedef struct CSString {
  INT32 type;
  csc_string* string;
} CSString;

typedef struct CSRefer {
  INT32 type;
  csc_hdfRefer* refer;
} CSRefer;

typedef union CSValue { //8Byte
  INT32 type;
  CSNumber asNumber;
  CSString asString;
  CSRefer asRefer;
}CSValue;

CSValue* allocCSValue(void);
CSValue* allocCSString(csc_string* string);
CSValue* allocCSRefer(csc_string* string);
csc_hdfRefer* allocHdfRefer();
void clean_hdfRefer();
void clean_CSValue();
#pragma pack(pop)

#endif /* _CSC_TYPES_H_ */
