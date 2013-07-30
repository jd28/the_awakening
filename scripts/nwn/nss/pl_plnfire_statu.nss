#include "pc_funcs_inc"

void main(){
    if(GetLocalInt(OBJECT_SELF, "PL_PLNFIRE_STATUES"))
        return;

    object oPC = GetLastUsedBy();

    if(GetIsInCombat(oPC)){
        ErrorMessage(oPC, "You are unable to use this device in the heat of battle!");
        return;
    }

    object oArea = GetArea(OBJECT_SELF);
    int nStatuesOn = GetLocalInt(oArea, "PL_PLNFIRE_STATUES");
    nStatuesOn++;
    ActionCastSpellAtObject(SPELL_FLAME_STRIKE, oPC, METAMAGIC_ANY, TRUE);

    if(nStatuesOn == 4){
        object oDoor1 = GetNearestObjectByTag("ms_hell_3to4");
        UnlockAndOpenDoor(oDoor1);
        object oDoor2 = GetNearestObjectByTag("ms_hell_3to5");
        UnlockAndOpenDoor(oDoor2);
        object oDoor3 = GetNearestObjectByTag("ms_hell_3to6");
        UnlockAndOpenDoor(oDoor3);
        object oDoor4 = GetNearestObjectByTag("ms_hell_3to7");
        UnlockAndOpenDoor(oDoor4);

        DeleteLocalInt(oArea, "PL_PLNFIRE_STATUES");
        DeleteLocalIntFromNearestObjectsByTag(GetTag(OBJECT_SELF), "PL_PLNFIRE_STATUES", oPC);
    }
    else{
        SetLocalInt(oArea, "PL_PLNFIRE_STATUES", nStatuesOn);
        SetLocalInt(OBJECT_SELF, "PL_PLNFIRE_STATUES", 1);
    }
}
