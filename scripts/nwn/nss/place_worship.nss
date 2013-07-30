void main(){

    object oPC = GetLastUsedBy();

    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionPlayAnimation (ANIMATION_LOOPING_WORSHIP, 0.5, 3000.0));

}
