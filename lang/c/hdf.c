#include "hdf.h"
HdfPool __globalHdfPool;
HdfPool* createHdfPool(INT32 length){
  if(__globalHdfPool.valid){
    die("currently only support a string hdf pool");
  }
  __globalHdfPool.buffer = calloc(length,sizeof(HdfNode));
  __globalHdfPool.length = length;
  __globalHdfPool.valid = true;
  return &__globalHdfPool;
}
void freePool(HdfPool* pool){
  assert(pool);
  if(pool->valid == 0){
    printf("free invalid pool.");
    return;
  } 
  free(pool->buffer);
  pool->valid = 0;
  pool->length = 0;
  pool->cursor = 0;
  pool->buffer = NULL;
  return;
}
HdfNode* allocHdfNode(HdfPool* pool){
  assert(pool);
  if(pool->cursor == pool->length){
    die("Reach Capacity Of HdfPool");
  }
  return pool->buffer+pool->cursor++;
}
void setPoolOffset(HdfPool* pool,INT32 offset){
  assert(pool);
  assert(offset >= 0);
  pool->cursor = offset;
}
void clearPool(HdfPool* pool){
  assert(pool);
  pool->cursor = 0;
  memset(pool->buffer,0,pool->length*sizeof(HdfNode));
}
