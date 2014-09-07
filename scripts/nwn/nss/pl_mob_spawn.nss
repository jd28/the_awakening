#include "pc_funcs_inc"

void CreateCreature(string resref, location loc) {
	object obj = CreateObject(OBJECT_TYPE_CREATURE, resref, loc, FALSE);
	SetLocalInt(obj, "DM_SPAWNED", TRUE);
}

void main(){

    int nEvent = GetUserDefinedItemEventNumber();
    object oPC = GetItemActivator(), oItem = GetItemActivated();
    object oTarget = GetItemActivatedTarget();
    string sResref;
    float fDelay;

    //Set the return value for the item event script
    // * X2_EXECUTE_SCRIPT_CONTINUE - continue calling script after executed script is done
    // * X2_EXECUTE_SCRIPT_END - end calling script after executed script is done
    int nResult = X2_EXECUTE_SCRIPT_END;
    if(nEvent != X2_ITEM_EVENT_ACTIVATE) return;

    int nCount = GetLocalInt(oItem, "PL_MOB_SPAWN_COUNT");
    if(!GetLocalInt(oItem, "PL_MOB_SPAWNING")){
        if(GetIsPC(oTarget) || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
            return;

        if(nCount > 10) {
            ErrorMessage(oPC, "Only 10 per widget.");
            return;
        }

        SetLocalString(oItem, "PL_MOB_SPAWN_"+IntToString(++nCount), GetResRef(oTarget));
        SetLocalInt(oItem, "PL_MOB_SPAWN_COUNT", nCount);
        SendMessageToPC(oPC, GetName(oTarget) + " has been added to Mob Spawn.");

        return;
    }

    location lLoc = GetItemActivatedTargetLocation();

    while(nCount > 0){
        sResref = GetLocalString(oItem, "PL_MOB_SPAWN_"+IntToString(nCount));
        if(sResref != "")
            DelayCommand((fDelay += 0.1), CreateCreature(sResref, lLoc));
        nCount--;
    }
}
