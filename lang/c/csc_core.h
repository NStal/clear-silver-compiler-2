#ifndef _CSC_CORE_H_
#define _CSC_CORE_H_

#define LF     (u_char) 10
#define CR     (u_char) 13
#define CRLF   "\x0d\x0a"
#define csc_abs(value)       (((value) >= 0) ? (value) : - (value))
#define csc_max(val1, val2)  ((val1 < val2) ? (val2) : (val1))
#define csc_min(val1, val2)  ((val1 > val2) ? (val2) : (val1))

typedef struct csc_array_s  csc_array_s;
typedef int INT32;
typedef long INT64;
typedef unsigned char BYTE;
typedef unsigned int UINT32;
typedef unsigned long UINT64;
#define true 1
#define false 0

union CSValue;
struct CSNumber;
struct CSString;
struct CSRefer;

//#define NDEBUG
#include "assert.h"
#include "csc_const.h"
#include "csc_array.h"
#include "csc_types.h"
#include "csc_common.h"
#endif /* _CSC_CORE_H_ */







