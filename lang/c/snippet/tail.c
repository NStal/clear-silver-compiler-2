
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
  int times = 1000*100;
  HdfPool* pool = createHdfPool(HDF_POOL_LENGTH);
  SetCSPool(pool);
  
  parseHdf(&hdfString,pool);
  while(--times>0){
    //printf("%d",times);
    ensureHdfPoolRoot(pool);
    CSC_HdfInterpreter();
    clean_primitive();
    clean_Hdf();
    clean_CSValue();
    clean_hdfRefer();
    clean_array();
    clean_OutPutBuffer();
    //cleanUp();
  }
  PrintBuffer();
  return 0;
}
