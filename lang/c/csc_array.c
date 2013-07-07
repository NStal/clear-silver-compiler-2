#include "csc_array.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#define MAX_ARRAY_COUNT 1024*10
#define DEFAULT_ARRAY_BUFFER_COUNT 128
csc_array CSCArrayStructBuffer[MAX_ARRAY_COUNT];
int CSCArrayAvailableCursor = 0;
void clean_array(){
  CSCArrayAvailableCursor = 0;
}
csc_array* allocArray(void){
  if(++CSCArrayAvailableCursor>MAX_ARRAY_COUNT){
    die("Array Used Up");
    return NULL;
  }
  csc_array* result = CSCArrayStructBuffer+CSCArrayAvailableCursor; 
  if(!result->elements || result->_bufferLength <= 0){
    if(result->elements){
      free(result->elements);
    }
    result->elements = calloc(DEFAULT_ARRAY_BUFFER_COUNT,sizeof(void*)); 
    result->_bufferLength = DEFAULT_ARRAY_BUFFER_COUNT;
  }
  result->length = 0;
  return result;
}
void increaseArrayBufferSize(csc_array* array){
  assert(array);
  int length = array->_bufferLength;
  if(length>0){
    length*=2;
  }else{
    length = DEFAULT_ARRAY_BUFFER_COUNT;
  }
  void* ptr = realloc(array->elements,length*sizeof(void*));
  if(!ptr){
    die("Fail To Realloc\n");
    return;
  }
  array->elements = ptr;
  array->_bufferLength = length;
  return;
}
void cscArrayPush(csc_array* array,void* ptr){
  if(array->length == array->_bufferLength){
    increaseArrayBufferSize(array);
  }
  array->elements[array->length++] = ptr;
}
void* cscArrayPop(csc_array* array){
  if(array->length == 0){
    return NULL;
  }
  return array->elements+(--array->length);
}
void* cscArrayGet(csc_array* array,int index){
  if(array->length <= index){
    return NULL;
  }
  return array->elements[index];
}





