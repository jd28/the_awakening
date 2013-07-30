#include "mod_funcs_inc"
#include "vfx_inc"
#include "nw_i0_generic"

void DropIce(){
    int i;
    float fDelay = 0.2;
    location lLoc = GetLocation(OBJECT_SELF), lNew;

    for(i = 0; i <= 5; i++){
        lNew = MoveLocation(lLoc, IntToFloat(Random(360)+1), IntToFloat(Random(20)+5));
        DelayCommand(fDelay, ApplyVisualAtLocation(VFX_FNF_ICESTORM, lNew));
        fDelay += 0.3;
    }

}

void main(){
    if(GetLocalInt(OBJECT_SELF, "IceDrop"))
        return;

    SetLocalInt(OBJECT_SELF, "IceDrop", TRUE);

    ClearAllActions(TRUE);
    ActionSpeakString("Raaaaaaaaaauuuuuurrrrrrrrrgggggghhhhh");
    ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT);
    ActionDoCommand(DropIce());
    ActionDoCommand(SetCommandable(TRUE));
    ActionDoCommand(DetermineCombatRound());
    SetCommandable(FALSE);

}

