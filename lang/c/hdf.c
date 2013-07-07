#include "hdf.h"
HdfPool __globalHdfPool;
HdfPool* createHdfPool(INT32 length){
  if(__globalHdfPool.valid){
    die("currently only support a string hdf pool");
  }
  __globalHdfPool.buffer = calloc(length,sizeof(HdfNode));
  __globalHdfPool.length = length;
  __globalHdfPool.cursor = 0;
  __globalHdfPool.valid = true;
  return &__globalHdfPool;
}
void clean_Hdf(){
  __globalHdfPool.cursor = 0;
  __globalHdfPool.root = NULL;
  if(__globalHdfPool.buffer){
    memset(__globalHdfPool.buffer,0,__globalHdfPool.length * sizeof(HdfNode));
  }
}
void freePool(HdfPool* pool){
  assert(pool);
  if(pool->valid == 0){
    printf("free invalid pool.\n");
    return;
  } 
  free(pool->buffer);
  pool->valid = 0;
  pool->length = 0;
  pool->cursor = 0;
  pool->buffer = NULL;
  pool->root = NULL;
  return;
}
HdfNode* allocHdfNode(HdfPool* pool){
  assert(pool);
  if(pool->cursor == pool->length){
    die("Reach Capacity Of HdfPool");
  }
  
  HdfNode* node = pool->buffer+pool->cursor++;
  node->children = allocArray();
  node->value = allocCSValue();
  return node;
}
void ensureHdfPoolRoot(HdfPool* pool){
  if(pool->root)return;
  pool->root = allocHdfNode(pool);
  pool->root->route = NULL;
}
#define isHdfRoot(root,pool) (root==pool->root)
HdfNode* getHdfNodeFromNode(HdfPool* pool,PathString* path,HdfNode* root){
  ensureHdfPoolRoot(pool);
  HdfNode* cursor = root;
  int routeIndexStart = 0;
  int routeIndexEnd = 0;
  if(path->length == 0){
    return NULL;
  }
  while(true){
    //while not EOF string
    while(routeIndexEnd <=  path->length){
      //Meet a dot seperater
      if(path->buffer[routeIndexEnd] == '.' || routeIndexEnd == path->length){
	// meet a . or EOS
	// no matter what, get that node first
	assert(routeIndexEnd!=routeIndexStart);
	int childIndex = 0;
	int routeLength = routeIndexEnd - routeIndexStart;
	HdfNode* result = NULL;
	// route equal the any children?
	while(childIndex < cursor->children->length){
	  HdfNode* node = (HdfNode*)cscArrayGet(cursor->children,childIndex);
	  assert(node);
	  assert(node->route);
	  //same length => might equal
	  if(routeLength ==  node->route->length){
	    int cmpIndex = 0;
	    int equal = 1;
	    while(cmpIndex!=node->route->length){
	      if(path->buffer[routeIndexStart+cmpIndex]!=node->route->buffer[cmpIndex]){
		equal = 0;
		break;
	      }
	      cmpIndex++;
	    }
	    //it's you !
	    if(equal){
	      //does result an refer?
	      result = node;
	      break;
	    }
	    //sorry :( not this one
	  }
	  childIndex++;
	}
	
	//Hey, Did you find any thing?
	if(!result){
	  //not found : ( we add one
	  csc_string *route = cscStringFromChars(path->buffer,routeIndexStart,routeIndexEnd);
	  
	  result = addHdfEmptyChild(cursor,route,pool);
	}
	assert(result);
	cursor = result;
	//OK finaly we have the node
	if(routeIndexEnd == path->length){
	  //EOS the cursor is what we want
	  return cursor;
	}else{
	  routeIndexEnd++;
	  routeIndexStart = routeIndexEnd;
	}
      }else{
	routeIndexEnd++;
      }
    }
  }
}
HdfNode* getHdfNode(HdfPool* pool,PathString* path){
  ensureHdfPoolRoot(pool);
  HdfNode* cursor = pool->root;
  return getHdfNodeFromNode(pool,path,cursor);
}

HdfNode* getReferNodeRecursive(HdfPool* pool,CSValue* value){
  HdfNode* cursor = NULL;
  while(true){
    cursor = getReferNode(pool,value); 
    if(cursor->value->type == CS_TYPE_REFER){
      value = cursor->value;
      continue;
    }
    break;
  }
  return cursor;
}
HdfNode* getReferNode(HdfPool* pool,CSValue* value){
  assert(value->type == CS_TYPE_REFER);
  csc_hdfRefer* refer = value->asRefer.refer;
  assert(refer);
  if(refer->hdfNode){
    return refer->hdfNode;
  }
  HdfNode* node = getHdfNode(pool,(PathString*)refer->query);
  refer->hdfNode = node;
  return node;
}
HdfNode* setHdfValue(HdfPool* pool,PathString* path,CSValue* value){
  HdfNode* node = getHdfNode(pool,path);
  assert(value);
  node->value = value;
  return node;
}
void setPoolOffset(HdfPool* pool,INT32 offset){
  assert(pool);
  assert(offset >= 0);
  pool->cursor = offset;
}
void clearPool(HdfPool* pool){
  assert(pool);
  pool->cursor = 0;
  memset(pool->buffer,0,pool->length*sizeof(HdfNode));
}

HdfNode* addHdfEmptyChild(HdfNode* parent,csc_string* route,HdfPool* pool){
  HdfNode* node = allocHdfNode(pool);
  node->route = route;
  cscArrayPush(parent->children,(void*)node);
  return node;
}
void printHdfTree(HdfNode* node,int indent){
  int childIndex = 0;
  int indentIndex = 0;
  CSValue* value = node->value;
  for(;indentIndex<=indent;indentIndex++)printf("   ");
  cscPrintString(node->route);
  printf("->");
  if(value->type == CS_TYPE_UNDEFINED){
    printf("[//]");
  }else if(value->type == CS_TYPE_STRING){
    printf("string: \"");
    cscPrintString(value->asString.string);
    printf("\"");
  }else if(value->type == CS_TYPE_NUMBER){
    printf("int: %d:",value->asNumber.number);
  }else if(value->type == CS_TYPE_REFER){
    cscPrintString(value->asRefer.refer->query);
  }else{
    printf("unknow value");
  }
  
  printf(" Node.");
  if(node->children->length > 0){
    printf("childLength %d",node->children->length);
  }
  printf("\n");
  while(childIndex < node->children->length){
    HdfNode* child = (HdfNode*)cscArrayGet(node->children,childIndex);
    printHdfTree(child,indent+1);
    childIndex++;
  }
}
