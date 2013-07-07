#include "csc_types.h"
#define MaxCSValue 1024*1024
CSValue CSValueBuffer[MaxCSValue];
int CSValueBufferCursor = 0;
void clean_CSValue(){
  memset(CSValueBuffer,0,sizeof(CSValue)*CSValueBufferCursor);
  CSValueBufferCursor = 0; 
}
CSValue* allocCSValue(){
  return CSValueBuffer+CSValueBufferCursor++;
}
CSValue* allocCSString(csc_string* string){
  CSValue* value = allocCSValue();
  value->asString.type = CS_TYPE_STRING;
  value->asString.string = string;
  return value;
}
CSValue* allocCSRefer(csc_string* string){
  CSValue* value = allocCSValue(); 
  value->asRefer.type = CS_TYPE_REFER;
  value->asRefer.refer = allocHdfRefer();
  value->asRefer.refer->query = string;
  return value;
}
#define MaxHdfRefer 1024*1024
csc_hdfRefer HdfReferStructBuffer[MaxHdfRefer];
int HdfReferCursor = 0;
void clean_hdfRefer(){
  memset(HdfReferStructBuffer,0,sizeof(csc_hdfRefer)* HdfReferCursor);
  HdfReferCursor = 0;
}
csc_hdfRefer* allocHdfRefer(){
  return HdfReferStructBuffer+HdfReferCursor++;
}
