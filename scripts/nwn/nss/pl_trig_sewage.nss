void main(){
    object oPC = GetEnteringObject();
    object oPlace = GetNearestObjectByTag("pl_place_sewage", oPC);
    vector vVec = GetPosition(oPlace);
    vVec.x += 1.0f;
    //AssignCommand(oPlace, SpeakString("Attempting to shoot sewage"));
    location lNewLoc = Location(GetArea(oPlace), vVec, GetFacing(oPlace));
    ActionDoCommand(AssignCommand(oPlace,
        ActionCastFakeSpellAtLocation(SPELL_MESTILS_ACID_BREATH, GetLocation(OBJECT_SELF))));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_L), oPlace);
    DelayCommand(1.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_S), oPlace));
    //DelayCommand(3.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_ACID), oPlace));
}
