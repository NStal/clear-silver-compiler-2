#ifndef _CSC_ARRAY_H_INCLUDED
#define _CSC_ARRAY_H_INCLUDED
#include "./csc_core.h"
void * csc_ptr;

typedef struct csc_array{
  void* elements; //pointer to elements
  INT32 elementSize;
  
}csc_array;

#endif /*_CSC_ARRAY_H_INCLUDED*/
