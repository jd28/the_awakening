#include "srv_funcs_inc"

int StartingConditional()
{
    return (VerifyDMKey(GetPCSpeaker()) || VerifyAdminKey(GetPCSpeaker()));
}
