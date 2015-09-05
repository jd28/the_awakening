#include "pc_funcs_inc"
#include "nwnx_redis"
int StartingConditional(){
    return StringToInt(GET("port:Freeport:"+GetRedisID(GetPCSpeaker())));
}
