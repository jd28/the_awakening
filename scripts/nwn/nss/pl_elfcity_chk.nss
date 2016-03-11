#include "pc_funcs_inc"
#include "pc_persist"

int StartingConditional(){
  return GetPersistantInt(GetPCSpeaker(), "port:Nhrive");
}
