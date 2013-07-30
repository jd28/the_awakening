///////////////////////////////////
//: dno_at_climb_2
//: Climb Check and JumpTo Waypoint.
//: DC 25 on STR & DEX Bonu's +D20 roll.
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
#include "pc_funcs_inc"

void main(){

    object oPC = GetPCSpeaker();
    object oPorter = GetLocalObject(oPC, "PL_CONV_WITH");
    DeleteLocalObject(oPC, "PL_CONV_WITH");
    if (!GetIsPC(oPC)) return;

    int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
    int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    int nMod = nStr + nDex;
    int nRoll = d20();
    int nResult = nMod + nRoll;

    if (nResult >= 24){
        SendMessageToPC(oPC, "You have climbed down the rope and are now at the bottom of the pit.");
    }
    else {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d20(4), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWENTY), oPC, 0.0);
        SendMessageToPC(oPC, "Your attempt to climb down the rope has failed, but at least you are at the bottom of the pit.");
    }

    JumpSafeToWaypoint(GetLocalString(oPorter, "Waypoint"), oPC);
}
