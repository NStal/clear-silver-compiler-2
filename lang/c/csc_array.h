#ifndef _CSC_ARRAY_H_INCLUDED
#define _CSC_ARRAY_H_INCLUDED
#include "csc_core.h"
#include "string.h"
void * csc_ptr;

typedef struct csc_array{
  void** elements; //pointer to elements
  int length;
  int _bufferLength;
}csc_array;
csc_array* allocArray();
void cscArrayPush(csc_array* array,void* ptr);
void* cscArrayPop(csc_array* array);
void* cscArrayGet(csc_array* array,int index);
void clean_array();
#endif /*_CSC_ARRAY_H_INCLUDED*/
