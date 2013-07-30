#include "nwnx_inc"

void main()
{
    object oPC = GetPCSpeaker(), oKey;
    object oPorter = GetLocalObject(oPC, "PL_CONV_WITH");
    DeleteLocalObject(oPC, "PL_CONV_WITH");
    int anim = GetLocalInt(oPorter, "PL_CONV_PLAY_ANIM") - 1;

    if(anim >= 0){
        AssignCommand(oPC, ActionPlayAnimation(anim, 1.0, 2.0));

        BroadcastProjectileToObject(GetNearestObjectByTag("pl_elder_brain_obj"), oPC,  SPELL_ELECTRIC_JOLT);
    }
}
