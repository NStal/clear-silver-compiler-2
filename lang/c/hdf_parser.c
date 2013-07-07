#include "hdf_parser.h"
#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#define MaxPathLength 1024*64
#define ParserMaxRecursive 1000
int ParserRecursiveCounter = 0;
#define StartRecursive() ParserRecursiveCounter++;	\
  //printf("recursive %d\n",ParserRecursiveCounter);	\
  if(ParserRecursiveCounter>= ParserMaxRecursive){	\
    die("Max Parser Recursive\n");			\
  }
#define EndRecursive() (ParserRecursiveCounter--)
#define CharIsWhiteSpace(str,index) (str->buffer[index] == ' ' || str->buffer[index] == '\n' || str->buffer[index] == '\t' || str->buffer[index] == '\r')

#define CharIsSpace(str,index) (string->buffer[index] ==' ')

#define SkipWhiteSpace(str,index)		\
  while(index<str->length){			\
    if(!CharIsWhiteSpace(str,index)){		\
      break;					\
    }						\
    index++;					\
  }

#define SkipSpace(str,index)			\
  while(index<str->length){			\
    if(!CharIsSpace(str,index)){		\
      break;					\
    }						\
    index++;					\
 }
#define CharInNumber(str,index) (str->buffer[index] <= 57 && str->buffer[index]>=47)
#define CharInAlphabet(str,index) (str->buffer[index] <= 122 && str->buffer[index]>=65)
#define CharInHdfQuery(str,index) (CharInNumber(str,index)||CharInAlphabet(str,index) || (str->buffer[index] == '.'))
#define EndOfString() (string->length<=index)

#ifdef OS_LINUX
#define EnterCode LF
#else
#define EnterCode CR
#endif

void parserAssert(int state,const char* msg){
  // here we do it again for runtime error report
  if(!state){
    printf(msg);
    printf("\n");
    die("Parser Fatal Error, Exit.\n");
  }
}
char* pathChars[MaxPathLength];
int parseHdf(csc_string *string,HdfPool* pool){
  int index = 0;
  //printf("parse hdf string of length %d\n",string->length);
  //printf("parse content of %s",string->buffer);
  PathString path;
  path.length = 0;
  path.buffer = (char*)pathChars;
  
  int length = parseHdfSubString(string,0,&path,pool);
  assert(length == string->length);
  if(length < string->length){
    die("Unexpect Hdf tail at position");
  }
  return length;
}
int parseHdfSubString(csc_string *string,int index,struct PathString* path,HdfPool* pool){
  StartRecursive();
  while(true){
    //skipWhiteSpace is a macro 
    // skip below
    //   key = value 
    // ^ 
    SkipWhiteSpace(string,index);
    if(index>=string->length){
      //printf("reach hdf string end\n");
      return string->length;
    }
    if(string->buffer[index] == '}'){
      return index;
    }
    parserAssert(CharInHdfQuery(string,index),"Unexpect token, should be CharInHdfQuery");
    //
    int startHdfQueryIndex = index;
    // parse below
    // key.p1.p2 = value
    // ^--------^
    while(CharInHdfQuery(string,index)){
      index++;
    }
    int endHdfQueryIndex = index;
    
    // skip below
    // key.p1.p2 = value
    //          ^
    
    SkipSpace(string,index);
    parserAssert(string->buffer[index] == '=' || string->buffer[index] == ':' || string->buffer[index] == '{',"HdfQuery Should Followed By = or {");
    // parse below
    // key.p1.p2 = value  \n
    //           ^-------^
    
    if(string->buffer[index] == '=' || string->buffer[index] == ':'){
      index++;
      SkipSpace(string,index); 
      int valueStart = index;
      index = cscIndexOfChar(string,EnterCode,index);
      if(index == -1){
	printf("at position %d",index);
	die("Unexpect Hdf End, Unclosed = value");
	return -1;
      }
      int valueEnd = index;
      csc_string* valueString = cscSubString(string,valueStart,valueEnd);
      
      CSValue* csValue = allocCSString(valueString);
      int flag = pushPathRoute(path,string,startHdfQueryIndex,endHdfQueryIndex);
      
      setHdfValue(pool,path,csValue);
      restorePathRoute(path,flag);
      
      continue;
      
    }else if (string->buffer[index] == '{'){
      
      // parse below
      // key.p1.p2 {
      //             ^ recursive parse...
      //     k1 = v1
      //     k2 = v2
      // }
      // ^ return here
      index++;
      int flag = pushPathRoute(path,string,startHdfQueryIndex,endHdfQueryIndex);
      index = parseHdfSubString(string,index,path,pool);
      restorePathRoute(path,flag);
      //something wrong...
      if(index==-1){
	return -1;
      }else if (index == string->length){
	//Un expect EOF with unclosed {
	die("Unexpect EOS with unclosed {");
	return -1;
      }
      assert(string->buffer[index] == '}');
      index++;
      continue;
      
    }else if (string->buffer[index] == '}'){
      return index;
      die("Unexpect Token After HdfQueryPathName\n");
    }
  }
  //This is a recursive safe method
  EndRecursive();
  return index;
}

int pushPathRoute(PathString* path,csc_string* source,int start,int end){
  int index = 0;
  int length = path->length;
  if(length>0){
    path->buffer[path->length++] = '.';
  }
  while(start+index<end){
    path->buffer[path->length++] = source->buffer[start+index++];
  }
  path->buffer[path->length] = '\0';
  return length;
}
void restorePathRoute(PathString* path,int flag){
  path->length = flag;
  path->buffer[path->length] = '\0';
  return;
}
//void popPathRoute(PathString* path){
//  int index = path->length -1;
//  while(index>0){
//    if(path->buffer[index] == '.'){
//      path->length = index;
//      path->buffer[index] == '\0'
//	return;
//    }
//    index--;
//  }
//  path->length = 0;
//  path->buffer[0] = '\0';
//  return;
//}
#undef CharIsSpace
#undef CharIsWhiteSpace
#undef CharInNumber
#undef CharInAlphabet
#undef CharInHdfQuery
#undef SkipWhiteSpace
#undef SkipSpace
#undef EndOfString




