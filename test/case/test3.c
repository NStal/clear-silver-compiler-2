#include <stdio.h>
#include <stdlib.h>
#include "csc_core.h"
#include "csc_lib.h"
#include "hdf.h"
#include "hdf_parser.h"
#include "csc_resource.h"

void CSC_HdfInterpreter(void);
void CSC_HdfInterpreter(){
  CSEcho("\n",1);
  CSEcho("\n\n\n",3);
  CSEcho("\n\nbefore weekday\n\n",18);
  //call-expand Date._weekday
  CSEcho("\n",1);
  CSValue* __CSVar_5=newCSRefer("Days",4);
  CSValue* refer10 = __CSVar_5;
  HdfNode* nodeRefer10 = ToHDF(refer10);
  for(int index10=0;index10 < nodeRefer10->children->length;index10++){
    HdfSetReferByChars("wday",(HdfNode*)cscArrayGet(nodeRefer10->children,index10));
    CSEcho("\n  ",3);
    while(1){// to simulate if else
      CSValue* __CSVar_7=newCSRefer("wday",4);
      CSValue* __CSVar_9=newCSRefer("Wow",3);
      CSValue* __CSVar_10=newCSRefer("Foo",3);
      CSValue* __CSVar_8=CSOperate_dotRef(__CSVar_9,__CSVar_10);
      CSValue* __CSVar_6=CSOperate_isEqual(__CSVar_7,__CSVar_8);
      if(CSIf(__CSVar_6)){
        CSEcho("\n    ",5);
	CSValue* __CSVar_12=newCSRefer("wday",4);
	CSValue* __CSVar_13=newCSRefer("Abbr",4);
	CSValue* __CSVar_11=CSOperate_dotRef(__CSVar_12,__CSVar_13);
	CSVar(__CSVar_11);
	CSEcho("\n  ",3);
        break;
      }
      break;
    }
    CSEcho("\n",1);
  }
  
  CSEcho("\n",1);
  while(1){// to simulate if else
    CSValue* __CSVar_16=newCSRefer("Wow",3);
    CSValue* __CSVar_17=newCSRefer("Foo",3);
    CSValue* __CSVar_15=CSOperate_dotRef(__CSVar_16,__CSVar_17);
    CSValue* __CSVar_18=newCSString("6",1);
    CSValue* __CSVar_14=CSOperate_isEqual(__CSVar_15,__CSVar_18);
    if(CSIf(__CSVar_14)){
      CSEcho("\n",1);
      CSValue* __CSVar_21=newCSRefer("Days",4);
      CSValue* __CSVar_22=newCSRefer("0",1);
      CSValue* __CSVar_20=CSOperate_dotRef(__CSVar_21,__CSVar_22);
      CSValue* __CSVar_23=newCSRefer("Abbr",4);
      CSValue* __CSVar_19=CSOperate_dotRef(__CSVar_20,__CSVar_23);
      CSVar(__CSVar_19);
      CSEcho("\n",1);
      break;
    }
    CSValue* __CSVar_26=newCSRefer("Wow",3);
    CSValue* __CSVar_27=newCSRefer("Foo",3);
    CSValue* __CSVar_25=CSOperate_dotRef(__CSVar_26,__CSVar_27);
    CSValue* __CSVar_28=newCSString("0",1);
    CSValue* __CSVar_24=CSOperate_isEqual(__CSVar_25,__CSVar_28);
    if(CSIf(__CSVar_24)){
      CSEcho("\n",1);
      CSValue* __CSVar_31=newCSRefer("Days",4);
      CSValue* __CSVar_32=newCSRefer("1",1);
      CSValue* __CSVar_30=CSOperate_dotRef(__CSVar_31,__CSVar_32);
      CSValue* __CSVar_33=newCSRefer("Abbr",4);
      CSValue* __CSVar_29=CSOperate_dotRef(__CSVar_30,__CSVar_33);
      CSVar(__CSVar_29);
      CSEcho("\n",1);
      break;
    }
    CSValue* __CSVar_36=newCSRefer("Wow",3);
    CSValue* __CSVar_37=newCSRefer("Foo",3);
    CSValue* __CSVar_35=CSOperate_dotRef(__CSVar_36,__CSVar_37);
    CSValue* __CSVar_38=newCSString("1",1);
    CSValue* __CSVar_34=CSOperate_isEqual(__CSVar_35,__CSVar_38);
    if(CSIf(__CSVar_34)){
      CSEcho("\n",1);
      CSValue* __CSVar_41=newCSRefer("Days",4);
      CSValue* __CSVar_42=newCSRefer("2",1);
      CSValue* __CSVar_40=CSOperate_dotRef(__CSVar_41,__CSVar_42);
      CSValue* __CSVar_43=newCSRefer("Abbr",4);
      CSValue* __CSVar_39=CSOperate_dotRef(__CSVar_40,__CSVar_43);
      CSVar(__CSVar_39);
      CSEcho("\n",1);
      break;
    }
    CSValue* __CSVar_46=newCSRefer("Wow",3);
    CSValue* __CSVar_47=newCSRefer("Foo",3);
    CSValue* __CSVar_45=CSOperate_dotRef(__CSVar_46,__CSVar_47);
    CSValue* __CSVar_48=newCSString("2",1);
    CSValue* __CSVar_44=CSOperate_isEqual(__CSVar_45,__CSVar_48);
    if(CSIf(__CSVar_44)){
      CSEcho("\n",1);
      CSValue* __CSVar_51=newCSRefer("Days",4);
      CSValue* __CSVar_52=newCSRefer("3",1);
      CSValue* __CSVar_50=CSOperate_dotRef(__CSVar_51,__CSVar_52);
      CSValue* __CSVar_53=newCSRefer("Abbr",4);
      CSValue* __CSVar_49=CSOperate_dotRef(__CSVar_50,__CSVar_53);
      CSVar(__CSVar_49);
      CSEcho("\n",1);
      break;
    }
    CSValue* __CSVar_56=newCSRefer("Wow",3);
    CSValue* __CSVar_57=newCSRefer("Foo",3);
    CSValue* __CSVar_55=CSOperate_dotRef(__CSVar_56,__CSVar_57);
    CSValue* __CSVar_58=newCSString("3",1);
    CSValue* __CSVar_54=CSOperate_isEqual(__CSVar_55,__CSVar_58);
    if(CSIf(__CSVar_54)){
      CSEcho("\n",1);
      CSValue* __CSVar_61=newCSRefer("Days",4);
      CSValue* __CSVar_62=newCSRefer("4",1);
      CSValue* __CSVar_60=CSOperate_dotRef(__CSVar_61,__CSVar_62);
      CSValue* __CSVar_64=newCSString("Ab",2);
      CSValue* __CSVar_65=newCSString("br",2);
      CSValue* __CSVar_63=CSOperate_add(__CSVar_64,__CSVar_65);
      CSValue* __CSVar_59=CSOperate_dynamicRef(__CSVar_60,__CSVar_63);
      CSVar(__CSVar_59);
      CSEcho("\n",1);
      break;
    }
    CSValue* __CSVar_68=newCSRefer("Wow",3);
    CSValue* __CSVar_69=newCSRefer("Foo",3);
    CSValue* __CSVar_67=CSOperate_dotRef(__CSVar_68,__CSVar_69);
    CSValue* __CSVar_70=newCSString("4",1);
    CSValue* __CSVar_66=CSOperate_isEqual(__CSVar_67,__CSVar_70);
    if(CSIf(__CSVar_66)){
      CSEcho("\n",1);
      CSValue* __CSVar_73=newCSRefer("Days",4);
      CSValue* __CSVar_74=newCSRefer("5",1);
      CSValue* __CSVar_72=CSOperate_dotRef(__CSVar_73,__CSVar_74);
      CSValue* __CSVar_75=newCSRefer("Abbr",4);
      CSValue* __CSVar_71=CSOperate_dotRef(__CSVar_72,__CSVar_75);
      CSVar(__CSVar_71);
      CSEcho("\n",1);
      break;
    }
    CSValue* __CSVar_78=newCSRefer("Wow",3);
    CSValue* __CSVar_79=newCSRefer("Foo",3);
    CSValue* __CSVar_77=CSOperate_dotRef(__CSVar_78,__CSVar_79);
    CSValue* __CSVar_80=newCSString("5",1);
    CSValue* __CSVar_76=CSOperate_isEqual(__CSVar_77,__CSVar_80);
    if(CSIf(__CSVar_76)){
      CSEcho("\n",1);
      CSValue* __CSVar_83=newCSRefer("Days",4);
      CSValue* __CSVar_84=newCSRefer("6",1);
      CSValue* __CSVar_82=CSOperate_dotRef(__CSVar_83,__CSVar_84);
      CSValue* __CSVar_85=newCSRefer("Abbr",4);
      CSValue* __CSVar_81=CSOperate_dotRef(__CSVar_82,__CSVar_85);
      CSVar(__CSVar_81);
      CSEcho("\n",1);
      break;
    }
    
    break;
  }
  CSEcho("\n",1);
  CSEcho("\n\nbefore echo\n\necho a variable: 3\n",34);
  //call-expand echo
  CSEcho("\n  ",3);
  CSValue* __CSVar_91=newCSRefer("Wow",3);
  CSValue* __CSVar_92=newCSRefer("Foo",3);
  CSValue* __CSVar_90=CSOperate_dotRef(__CSVar_91,__CSVar_92);
  CSValue* __CSVar_89=CSOperate_forceHDFRef(__CSVar_90);
  CSVar(__CSVar_89);
  CSEcho("\n",1);
  CSEcho("\necho a string: hellow world\n",29);
  //call-expand echo
  CSEcho("\n  ",3);
  CSValue* __CSVar_95=newCSString("hello world",11);
  CSValue* __CSVar_94=CSOperate_forceHDFRef(__CSVar_95);
  CSVar(__CSVar_94);
  CSEcho("\n",1);
  CSEcho("\necho a number: 5\n",18);
  //call-expand echo
  CSEcho("\n  ",3);
  CSValue* __CSVar_100=newCSRefer("5",1);
  CSValue* __CSVar_99=CSOperate_forceNumber(__CSVar_100);
  CSValue* __CSVar_98=CSOperate_forceHDFRef(__CSVar_99);
  CSVar(__CSVar_98);
  CSEcho("\n",1);
  CSEcho("\n\n",2);
  CSEcho("\n\necho a variable: 3\n",21);
  //call-expand call_echo
  CSEcho("\n",1);
  //call-expand echo
  CSEcho("\n  ",3);
  CSValue* __CSVar_109=newCSRefer("Wow",3);
  CSValue* __CSVar_110=newCSRefer("Foo",3);
  CSValue* __CSVar_108=CSOperate_dotRef(__CSVar_109,__CSVar_110);
  CSValue* __CSVar_107=CSOperate_forceHDFRef(__CSVar_108);
  CSVar(__CSVar_107);
  CSEcho("\n",1);
  CSEcho("\n",1);
  CSEcho("\necho a string: hellow world\n",29);
  //call-expand call_echo
  CSEcho("\n",1);
  //call-expand echo
  CSEcho("\n  ",3);
  CSValue* __CSVar_114=newCSString("hello world",11);
  CSValue* __CSVar_113=CSOperate_forceHDFRef(__CSVar_114);
  CSVar(__CSVar_113);
  CSEcho("\n",1);
  CSEcho("\n",1);
  CSEcho("\necho a number: 5\n",18);
  //call-expand call_echo
  CSEcho("\n",1);
  //call-expand echo
  CSEcho("\n  ",3);
  CSValue* __CSVar_121=newCSRefer("5",1);
  CSValue* __CSVar_120=CSOperate_forceNumber(__CSVar_121);
  CSValue* __CSVar_119=CSOperate_forceHDFRef(__CSVar_120);
  CSVar(__CSVar_119);
  CSEcho("\n",1);
  CSEcho("\n",1);
  CSEcho("\n\n",2);
  CSEcho("\n\n",2);
  CSEcho("\n\nthese tests show that local variables are live in sub calls \necho a variable: 3\n",82);
  //call-expand call_echo2
  CSEcho("\n  ",3);
  //call-expand echo2
  CSEcho("\n  ",3);
  CSValue* __CSVar_128=newCSRefer("Wow",3);
  CSValue* __CSVar_129=newCSRefer("Foo",3);
  CSValue* __CSVar_127=CSOperate_dotRef(__CSVar_128,__CSVar_129);
  CSVar(__CSVar_127);
  CSEcho("\n",1);
  CSEcho("\n",1);
  CSEcho("\necho a string: hellow world\n",29);
  //call-expand call_echo2
  CSEcho("\n  ",3);
  //call-expand echo2
  CSEcho("\n  ",3);
  CSValue* __CSVar_133=newCSString("hello world",11);
  CSVar(__CSVar_133);
  CSEcho("\n",1);
  CSEcho("\n",1);
  CSEcho("\necho a number: 5\n",18);
  //call-expand call_echo2
  CSEcho("\n  ",3);
  //call-expand echo2
  CSEcho("\n  ",3);
  CSValue* __CSVar_139=newCSRefer("5",1);
  CSValue* __CSVar_138=CSOperate_forceNumber(__CSVar_139);
  CSVar(__CSVar_138);
  CSEcho("\n",1);
  CSEcho("\n",1);
  CSEcho("\n\nafter echo\n\n",14);
  CSEcho("\n\ntesting macro calls in local vars in an each\n",47);
  CSValue* __CSVar_140=newCSRefer("Days",4);
  CSValue* refer123 = __CSVar_140;
  HdfNode* nodeRefer123 = ToHDF(refer123);
  for(int index123=0;index123 < nodeRefer123->children->length;index123++){
    HdfSetReferByChars("day",(HdfNode*)cscArrayGet(nodeRefer123->children,index123));
    CSEcho("\n  ",3);
    //call-expand print_day
    CSEcho("\n  ",3);
    CSValue* __CSVar_142=newCSRefer("day",3);
    CSVar(__CSVar_142);
    CSEcho(" == ",4);
    CSValue* __CSVar_144=newCSRefer("day",3);
    CSValue* __CSVar_145=newCSRefer("Abbr",4);
    CSValue* __CSVar_143=CSOperate_dotRef(__CSVar_144,__CSVar_145);
    CSVar(__CSVar_143);
    CSEcho("\n",1);
    CSEcho("\n  ",3);
    //call-expand echo
    CSEcho("\n  ",3);
    CSValue* __CSVar_151=newCSRefer("day",3);
    CSValue* __CSVar_152=newCSRefer("Abbr",4);
    CSValue* __CSVar_150=CSOperate_dotRef(__CSVar_151,__CSVar_152);
    CSValue* __CSVar_149=CSOperate_forceHDFRef(__CSVar_150);
    CSVar(__CSVar_149);
    CSEcho("\n",1);
    CSEcho("\n",1);
  }
  CSEcho("\n",1);
}


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
