#include "csc_resource.h"
void* cleaners[MaxCleanerCount];
int cleanerCursor = 0;
int registerCleaner(void (*func)()){
  if(cleanerCursor>=MaxCleanerCount){
    return 0;
  }
  cleaners[cleanerCursor++] = func;
  return 1;
}
void cleanUp(){
  for(int index = 0;index<cleanerCursor;index++){
    void (*handler)() = cleaners[index];
    handler();
  }
}
