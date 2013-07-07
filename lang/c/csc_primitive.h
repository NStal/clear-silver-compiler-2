#ifndef _CSC_PRIMITIVE_H_
#define _CSC_PRIMITIVE_H_
#include "basic_type.h"
#include <string.h>
typedef struct csc_string {
  INT32 length;    //4byte
  char* buffer;    //4byte
}csc_string;       //8byte

typedef INT32 csc_int;//8byte
typedef union CSPrimitive {
  int number;
  csc_string* string;
}CSPrimitive;
csc_string* cscAllocString(int length);
csc_string* cscSubString(csc_string* string,int start,int end);
int cscIndexOf(csc_string* string,csc_string* target,int start);
int cscIndexOfChar(csc_string* string,char code,int start);
int cscStringEqual(csc_string* a,csc_string* b);
csc_string* cscStringAdd(csc_string* a,csc_string* b);
csc_string* cscStringJoinChar(csc_string* a,csc_string* b,char code);
csc_string* cscStringFromChars(const char* chars,int start,int end);
void cscPrintString(csc_string* string);
void clean_primitive();
#endif /* _CSC_PRIMITIVE_H_ */



