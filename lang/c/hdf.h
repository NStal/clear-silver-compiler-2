#ifndef _HDF_H_
#define _HDF_H_
#include "csc_core.h"
#include "csc_primitive.h"
#include "csc_array.h"
#include "csc_types.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
typedef struct HdfNode{
  struct csc_array* children;
  union CSValue* value;
  csc_string* route;
}HdfNode;
typedef struct HdfPool{
  HdfNode* buffer;
  HdfNode* root;
  INT32 length;
  INT32 cursor; // offset to the current available
  BYTE valid;
} HdfPool;
typedef struct PathString{
  int length;
  char* buffer;
}PathString;
//current only support a single hdf pool
HdfPool* createHdfPool(INT32 length);
void freeHdfPool(HdfPool* pool);
HdfNode* allocHdfNode(HdfPool* pool);
void setPoolOffset(HdfPool* pool,INT32 offset);
void clearPool(HdfPool* pool);
void freePool(HdfPool* pool);
HdfNode* addHdfEmptyChild(HdfNode* parent,csc_string* route,HdfPool* pool);
HdfNode* setHdfValue(HdfPool* pool,PathString* path,union CSValue* value);
HdfNode* getHdfNodeFromNode(HdfPool* pool,PathString* path,HdfNode* root);
HdfNode* getHdfNode(HdfPool* pool,PathString* path);
void printHdfTree(HdfNode* node,int indent); 
void ensureHdfPoolRoot(HdfPool* pool);
union CSValue;
HdfNode* getReferNodeRecursive(HdfPool* pool,union CSValue* refer);
HdfNode* getReferNode(HdfPool* pool,union CSValue* refer);
void clean_Hdf();
#endif /* _HDF_H_ */
