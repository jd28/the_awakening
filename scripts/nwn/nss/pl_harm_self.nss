#include "x2_inc_switches"
#include "gsp_func_inc"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this

    if(nEvent != X2_ITEM_EVENT_ACTIVATE)
        return;

    struct SpellInfo si;
    si.caster = GetItemActivator();
    si.target = si.caster;
    si.id = SPELL_HARM;

    Harm(si, GetMaxHitPoints(si.caster), 246, VFX_IMP_HEALING_G);
}
