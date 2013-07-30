#include "area_inc"

void main(){
    int i = 1;
    object oPC = GetLastUsedBy();
    if(GetIsInCombat(oPC)){
        SendMessageToPC(oPC, "You may not use this in combat!");
        return;
    }
    else if(GetLocalInt(OBJECT_SELF, "PL_PLACE_USED")){
        return;
    }
    else if(GetLocalInt(OBJECT_SELF, "AreaCleaned")
            && !GetIsAreaClear(GetArea(oPC), oPC)){
        ErrorMessage(oPC, "Powerful forces that remain in the area keep you from using this!");
        return;
    }

    string sResref = GetLocalString(OBJECT_SELF, "Item" + IntToString(i));
    int nStack = GetLocalInt(OBJECT_SELF, "Item" + IntToString(i));

    SetLocalInt(OBJECT_SELF, "PL_PLACE_USED", TRUE);

    while(sResref != ""){
        CreateItemOnObject(sResref, oPC, ((nStack == 0) ? 1 : nStack));
        i++;
        sResref = GetLocalString(OBJECT_SELF, "Item" + IntToString(i));
        nStack = GetLocalInt(OBJECT_SELF, "Item" + IntToString(i));
    }

    int nDelay = GetLocalInt(OBJECT_SELF, "Delay");
    DelayCommand(IntToFloat(nDelay), DeleteLocalInt(OBJECT_SELF, "PL_PLACE_USED"));
}
