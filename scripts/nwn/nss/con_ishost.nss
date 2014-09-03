#include "srv_funcs_inc"

int StartingConditional()
{
    return VerifyAdminKey(GetPCSpeaker());
}
