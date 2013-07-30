///////////////////////////////////////////////////////////////////////////////
// file: con_port
// script type: Action Taken
// description: This script will turn any placable into portal.  Make sure you
//      make them Useable and Plot! Limitation: If you require a key, you
//      cannot currently also take gold.
// variables:
//      Name               Type        Description
//      ----               ----        -----------
//      "port_no_combat"   int         If set to 1 the PC will not be able to use the placeable in combat.
//      "port_delay"       int         Delay in seconds before a PC is ported, default is no delay.
//      "port_key"         string      The tag of the item necessary to use the placeable. See limitations.
//      "port_key_msg"     string      The message sent if PC does not have the key.
//      "port_key_take"    int         If set to 1 the item specified by the "port_key" variable will be taken.
//      "port_effect"      int         The effect to apply when the PC is ported.  Unsummon is 99.
//      "port_gold"        int         Amount of gold needed to port.  See limitations.
///////////////////////////////////////////////////////////////////////////////
#include "pc_funcs_inc"
#include "mod_funcs_inc"

void main(){

    object oPC = GetPCSpeaker(), oPorter = OBJECT_SELF, oKey;
    string sWaypoint = GetLocalString(oPorter, "port_way_1");
    float fDelay = IntToFloat(GetLocalInt(oPorter, "port_delay"));
    int bNoCombat = GetLocalInt(oPorter, "port_no_combat");
    string sKeyTag = GetLocalString(oPorter, "port_key");
    string sNoKeyMsg = GetLocalString(oPorter, "port_key_msg");
    int bDestroyKey = GetLocalInt(oPorter, "port_key_take");
    int nEffect = GetLocalInt(oPorter, "port_effect");
    int nTakeGold = GetLocalInt(oPorter, "port_gold");

    //if (!GetIsPC(oPC)) return;

    Logger(oPC, VAR_DEBUG_DEV, LOGLEVEL_NONE, "Porter: %s, Waypoint: %s, Delay: %s, No Combat: %s, Key Tag: %s, No Key Message: %s, " +
           "Destroy Key: %s, Gold: %s, Effect: %s", GetName(oPorter), sWaypoint, IntToString(GetLocalInt(oPorter, "port_delay")),
           IntToString(bNoCombat), sKeyTag, sNoKeyMsg, IntToString(bDestroyKey), IntToString(nTakeGold), IntToString(nEffect));


    if(sKeyTag != ""){
        oKey = GetItemPossessedBy(oPC, sKeyTag);
        if(GetIsObjectValid(oKey)){ // Do they have the key?
            if(bDestroyKey) DestroyObject(oKey);
        }
        else{
            if(sNoKeyMsg != "")
                SendMessageToPC(oPC, C_RED+sNoKeyMsg+C_END);
            return;
        }
    }
    else if(nTakeGold > 0){
        if(GetGold(oPC) >= nTakeGold){
            TakeGoldFromCreature(nTakeGold, oPC, TRUE);
        }
        else{
            SendMessageToPC(oPC, C_RED+"You must have " + IntToString(nTakeGold) + " gold pieces to port."+C_END);
            return;
        }
    }
    DelayCommand(fDelay, JumpSafeToWaypoint(sWaypoint, oPC));

    //Apply whatever visual effect, if any.
    if(nEffect > 0){
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nEffect), oPC);
    }
}
