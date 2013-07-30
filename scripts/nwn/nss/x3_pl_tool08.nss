//::///////////////////////////////////////////////
//:: Player Tool 8 Instant Feat
//:: x3_pl_tool08
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is a blank feat script for use with the
    10 Player instant feats provided in NWN v1.69.

    Look up feats.2da, spells.2da and iprp_feats.2da

*/
//:://////////////////////////////////////////////
//:: Created By: Brian Chung
//:: Created On: 2007-12-05
//:://////////////////////////////////////////////

#include "pc_funcs_inc"
#include "mod_funcs_inc"

void main(){
    string sTool = "PL_PLYRTOOL8";
    object oUser = OBJECT_SELF;
    int nRest = GetLocalInt(oUser, "Rests"), nUses;
    if(nRest > GetLocalInt(oUser, sTool+"_RESTS"))
        nUses = 0;
    else
        nUses = GetLocalInt(oUser, sTool+"_USES");

    //nUses++;
    //SetLocalInt(oUser, sTool+"_USES", nUses);
    //SetLocalInt(oUser, sTool+"_RESTS", nRest);

    SendMessageToPC(oUser, "Player Tool 10 activated.");

}
