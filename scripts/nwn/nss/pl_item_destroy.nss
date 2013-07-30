#include "mod_funcs_inc"
#include "x2_inc_switches"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();

    if(nEvent != X2_ITEM_EVENT_ACTIVATE) return;

    object oPC = GetItemActivator();
    object oItem = GetItemActivated();
    object oSpellTarget = GetItemActivatedTarget();

    if(GetObjectType(oSpellTarget) != OBJECT_TYPE_ITEM){
        FloatingTextStringOnCreature(C_RED+"You may only destroy items!"+C_END, oPC, FALSE);
        return;
    }
    else if(GetItemPossessor(oSpellTarget) != oPC){
        FloatingTextStringOnCreature(C_RED+"You may only destroy items in your possession!"+C_END, oPC, FALSE);
        return;
    }

    // Check for any items we don't want people to destroy.

    SetPlotFlag(oSpellTarget, FALSE);
    AssignCommand(oSpellTarget, SetIsDestroyable(TRUE, FALSE, FALSE));
    DestroyObject(oSpellTarget, 0.2f);
}
