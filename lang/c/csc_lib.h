#ifndef _CSC_LIB_H_
#define _CSC_LIB_H_
#include "csc_core.h"
#include "hdf.h"
void CSEcho(const char* msg,int length);
void CSVar(CSValue* value);
HdfNode* ToHDF(CSValue* refer);
void HdfSetReferByChars(const char*,HdfNode* node);
CSValue* CSOperate_dotRef(CSValue* a,CSValue* b);
CSValue* CSOperate_isEqual(CSValue* a,CSValue* b);
CSValue* CSOperate_forceHDFRef(CSValue* value);
CSValue* CSOperate_forceNumber(CSValue* value);
CSValue* CSOperate_dynamicRef(CSValue* a,CSValue* b);
CSValue* newCSNumber(int number);
CSValue* newCSRefer(const char* msg,int length);
CSValue* newCSString(const char* chars,int length);
CSValue* CSOperate_add(CSValue* a,CSValue* b);
void PrintBuffer(void);
int CSIf(CSValue* value);
void SetCSPool(HdfPool* pool);
void intToChars(char* buffer,int value); 
void clean_OutPutBuffer();
#endif /* _CSC_LIB_H_ */
