#ifndef _CSC_CORE_H_
#define _CSC_CORE_H_
#include "platform.h"

#define LF     ((unsigned char) 10)
#define CR     ((unsigned char) 13)
#define CRLF   "\x0d\x0a"
#define csc_abs(value)       (((value) >= 0) ? (value) : - (value))

#define csc_max(val1, val2)  ((val1 < val2) ? (val2) : (val1))
#define csc_min(val1, val2)  ((val1 > val2) ? (val2) : (val1))

typedef struct csc_array_s  csc_array_s;

union CSValue;
struct CSNumber;
struct CSString;
struct CSRefer;

#define NDEBUG
#include <assert.h>
#include "basic_type.h"
#include "csc_const.h"
#include "csc_array.h"
#include "csc_types.h"
#include "csc_common.h"
#include "csc_primitive.h"
#include "hdf.h"
#endif /* _CSC_CORE_H_ */
