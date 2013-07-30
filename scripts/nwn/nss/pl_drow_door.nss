#include "pc_funcs_inc"
#include "vfx_inc"

void main(){
    object oPC = GetPCSpeaker();
    object oCrest1 = GetItemPossessedBy(oPC, "pl_drow_h1_token");
    object oCrest2 = GetItemPossessedBy(oPC, "pl_drow_h2_token");
    object oCrest3 = GetItemPossessedBy(oPC, "pl_drow_h3_token");
    object oCrest4 = GetItemPossessedBy(oPC, "pl_drow_h4_token");

    if(oCrest1 == OBJECT_INVALID ||
       oCrest2 == OBJECT_INVALID ||
       oCrest3 == OBJECT_INVALID ||
       oCrest4 == OBJECT_INVALID)
    {
        ErrorMessage(oPC, "The door remains sealed");
        return;
    }

    DestroyObject(oCrest1);
    DestroyObject(oCrest2);
    DestroyObject(oCrest3);
    DestroyObject(oCrest4);

    SpeakString("The seal has been broken, you may enter.");

    ApplyVisualToObject(VFX_IMP_SUNSTRIKE, OBJECT_SELF);
    SetLocked(OBJECT_SELF, FALSE);
    DelayCommand(0.5f, ActionOpenDoor(OBJECT_SELF));
    DelayCommand(900.0f, ActionCloseDoor(OBJECT_SELF));
}
