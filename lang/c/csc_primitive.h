#ifndef _CSC_PRIMITIVE_H_
#define _CSC_PRIMITIVE_H_

typedef struct csc_string {
  INT32 length;    //4byte
  char* buffer;    //4byte
}csc_string;       //8byte

typedef INT64 csc_int;//8byte

#endif /* _CSC_PRIMITIVE_H_ */
