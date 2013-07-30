void DoDamage(object oPC){
    // If the player exited trigger don't damage
    if(!GetLocalInt(oPC, GetTag(OBJECT_SELF)))
        return;

    effect eDam = EffectDamage(d12(12), DAMAGE_TYPE_PIERCING);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);

    DelayCommand(2.0f, DoDamage(oPC));
}

void main(){
    object oPC = GetEnteringObject();

    // only pcs
    if(!GetIsPC(oPC) || GetIsDM(oPC))
        return;

    SetLocalInt(oPC, GetTag(OBJECT_SELF), TRUE);
    FloatingTextStringOnCreature("You are being attacked by pirhanas!", oPC, FALSE);
    DoDamage(oPC);
}
