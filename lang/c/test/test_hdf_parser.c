#include <stdio.h>
#include <stdlib.h>
#include "csc_core.h"
#include "hdf.h"
#include "hdf_parser.h"
#define maxHdfStringLength 1024*1024*10
char buffer[maxHdfStringLength];
int main(int argc, char *argv[]){
  csc_string hdfString = {(INT32)0,buffer};
  FILE* fp = NULL;
  if(argc != 2){
    printf("usage program <hdf_path>\n");
    return -1;
  }
  
  fp = fopen(argv[1],"r+");
  if(fp == NULL){
    printf("hdf file %s not exists.\n",argv[1]);
    return -1;
  }
  while(true){
    int count = fread(hdfString.buffer+hdfString.length,1,1024,fp);
    if(count>0){
      hdfString.length += count;
      if(maxHdfStringLength <= hdfString.length){
	printf("hdf file is too long(over 10m)");
	return -1;
      }
    }else{
      break;
    } 
  }
  
  hdfString.buffer[hdfString.length] = '\0';
  printf("load from path \"%s\" length %d\n",argv[1],hdfString.length);
  printf("test_sizeof(\"123456789\"): %d\n",sizeof("123456789"));
  HdfPool* pool = createHdfPool(HDF_POOL_LENGTH);
  printf("start parse hdf\n");
  parseHdf(&hdfString,pool);
  ensureHdfPoolRoot(pool);
  printf("end parse hdf\n");
  printHdfTree(pool->root,0);
  return 0;
}
