#include "x0_i0_anims"

void BreathFire(){
    //SpeakString("Attempting to Breath Fire");

    location lLoc = GetLocation(GetWaypointByTag("pl_faire_firetarget"));
    //if(oTarget == OBJECT_INVALID)
    //    SpeakString("No target!!");

    ActionPlayAnimation(ANIMATION_FIREFORGET_SALUTE);
    //ActionCastSpellAtLocation(690, lLoc, METAMAGIC_ANY, TRUE);
    //DelayCommand(0.5f, ClearActions(2000));
    DelayCommand(1.0f, ActionCastSpellAtLocation(690, lLoc, METAMAGIC_ANY, TRUE));


    DelayCommand(RoundsToSeconds(d3()+1), BreathFire());
}

void main(){
    if(!GetLocalInt(OBJECT_SELF, "BreathingFire")){
        SetLocalInt(OBJECT_SELF, "BreathingFire", TRUE);
        DelayCommand(6.0f, BreathFire());
    }
}
