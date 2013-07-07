#include "csc_core.h"
#define MaxCleanerCount 32

int registerCleaner(void (*funct)());
void cleanUp();
