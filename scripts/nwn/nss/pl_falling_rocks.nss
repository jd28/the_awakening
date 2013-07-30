void RockDamage(object oRocks, location lImpact)
{
    float fDelay = GetDistanceBetweenLocations(GetLocation(oRocks), lImpact)/20;
    int nDamage = d12(40);
    effect eDam;
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lImpact, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.

        //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, 42, SAVING_THROW_TYPE_NONE);
        //Set the damage effect
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_PLUS_ONE);
        if(nDamage > 0){
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lImpact, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

void main(){
    object oPC = GetEnteringObject();
    if(!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
        return;

    vector vPos = GetPosition(oPC);
    vPos.z += 10.0f;
    location lRocks = Location(GetArea(oPC), vPos, GetFacing(oPC));
    location lImpact = GetLocation(oPC);
    int nRoll = d3();

    effect eImpact = EffectVisualEffect(354);
    effect eImpac1 = EffectVisualEffect(460);

    //SendMessageToPC(oPC, IntToString(nRoll));

    if(nRoll == 2){
        //Create invisible placeable
        object oRock = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lRocks);
        //AssignCommand(oRock , ActionCastFakeSpellAtLocation(775, lImpact));
        AssignCommand(oRock , DelayCommand(1.5f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lImpact)));
        AssignCommand(oRock , DelayCommand(1.7f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpac1, lImpact)));
        AssignCommand(oRock , DelayCommand(1.5f, RockDamage(oRock, lImpact)));
        DelayCommand(8.0f, DestroyObject(oRock));
    }
}
