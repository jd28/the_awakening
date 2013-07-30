///////////////////////////////////////////////////////////////////////////////
// file: place_portal
// event: OnUsed
// example item: Custom | Special | Custom 5 | "Generic Portal"
// description: This script will turn any placable into portal.  It will send
//      the player to a waypoint tagged "wp_<tag of portal>" It is Case Sensitive!
//      Make sure you make them Useable and Plot also! Limitation: If you require
//      a key, you cannot currently also take gold.
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
#include "mod_funcs_inc"
#include "pc_funcs_inc"

void main(){

    object oPC = GetLastUsedBy(), oPortal = OBJECT_SELF, oKey;
    string sWaypoint = "wp_" + GetTag(oPortal);
    float fDelay = IntToFloat(GetLocalInt(oPortal, "port_delay"));
    int bNoCombat = GetLocalInt(oPortal, "port_no_combat");
    string sKeyTag = GetLocalString(oPortal, "port_key");
    string sNoKeyMsg = GetLocalString(oPortal, "port_key_msg");
    string sMsg = GetLocalString(oPortal, "port_msg");
    string sPortTagged = GetLocalString(oPortal, "port_tagged");
    int bDestroyKey = GetLocalInt(oPortal, "port_key_take");
    int nEffect = GetLocalInt(oPortal, "port_effect");
    int nTakeGold = GetLocalInt(oPortal, "port_gold");

    string sQuest = GetLocalString(oPortal, "quest");
    int nQuestStatus = GetLocalInt(oPortal, "quest_status");

    if (!GetIsPC(oPC)) return;

    Logger(oPC, VAR_DEBUG_DEV, LOGLEVEL_NONE, "Portal: %s, Waypoint: %s, Delay: %s, No Combat: %s, Key Tag: %s, No Key Message: %s, " +
           "Destroy Key: %s, Gold: %s, Effect: %s", GetTag(oPortal), sWaypoint, IntToString(GetLocalInt(oPortal, "port_delay")),
           IntToString(bNoCombat), sKeyTag, sNoKeyMsg, IntToString(bDestroyKey), IntToString(nTakeGold), IntToString(nEffect));

    if (bNoCombat && GetIsInCombat(oPC)){
        SendMessageToPC(oPC, C_RED+"You are unable to port in combat."+C_END);
        return;
    }

    if(sQuest != ""){
        if(GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sQuest) < nQuestStatus){
            return;
        }
    }

    if(sKeyTag != ""){
        oKey = GetItemPossessedBy(oPC, sKeyTag);
        if(GetIsObjectValid(oKey)){ // Do they have the key?
            if(bDestroyKey) DestroyObject(oKey);
        }
        else{
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
    else if(sPortTagged != ""){
        if(!GetLocalInt(oPC, sPortTagged)) return;
    }

    if(sMsg != "")
        FloatingTextStringOnCreature(C_GOLD+sMsg+C_END, oPC, FALSE);

    DelayCommand(fDelay, JumpSafeToWaypoint(sWaypoint, oPC));

    //Apply whatever visual effect, if any.
    if(nEffect > 0){
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nEffect), oPC);
    }

}
