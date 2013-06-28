#ifndef _HDF_H_
#define _HDF_H_
#include "csc_core.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
typedef struct HdfPool{
  HdfNode* buffer;
  INT32 length;
  INT32 cursor;
  BYTE valid;
} HdfPool;
//current only support a single hdf pool
HdfPool* createHdfPool(INT32 length);
void freeHdfPool(HdfPool* pool);
HdfNode* allocHdfNode(HdfPool* pool);
void setPoolOffset(HdfPool* pool,INT32 offset);
void clearPool(HdfPool* pool);
void freePool(HdfPool* pool);
#endif /* _HDF_H_ */
