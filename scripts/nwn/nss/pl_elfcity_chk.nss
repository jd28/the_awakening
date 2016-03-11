#include "pc_funcs_inc"

int StartingConditional(){
    return StringToInt(GET("port:Nhrive:"+GetRedisID(GetPCSpeaker())));
}
