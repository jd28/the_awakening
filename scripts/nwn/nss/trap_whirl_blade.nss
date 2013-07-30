#include "gsp_func_inc"

void ResetWhirlingBlades()
{
    object oTrap = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");

    DeleteLocalInt(OBJECT_SELF,"TRP_TRIGGERED");

    if(GetIsObjectValid(oTrap))
    {
        AssignCommand(oTrap, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
        //DestroyObject(oTrap,1.0);
        //DeleteLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW");
    }
}

void DoWhirlBladeDamage(){
    if(!GetLocalInt(OBJECT_SELF,"TRP_TRIGGERED"))
        return;

    SpeakString("Attempting to Damage");

    DelayCommand(1.0f, DoWhirlBladeDamage());

    object oTrap = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");
    int nDC = 55;
    int nDamage = d20(60);
    effect eDamage;
    float fDelay;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0f, GetLocation(oTrap));
    while(oTarget != OBJECT_INVALID){
        fDelay = GetRandomDelay();
        if(!ReflexSave(oTarget, nDC, SAVING_THROW_TYPE_TRAP)){
            if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                nDamage /= 2;
        }
        else if (GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget)){
            nDamage = 0;
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_REFLEX_SAVE_THROW_USE), oTarget));
        }
        else
            nDamage /= 2;

        if(nDamage > 0){
            eDamage = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);

            DelayCommand(fDelay, ApplyVisualToObject(VFX_COM_BLOOD_REG_RED, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 5.0f, GetLocation(oTrap));
    }

}

void TrapPlayAnim(object oTrap){
   SpeakString("Playing Animation");
   AssignCommand(oTrap, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
}
void main(){

    object oPC = GetEnteringObject();

    if(GetLocalInt(OBJECT_SELF,"TRP_TRIGGERED"))
        return;

    SetLocalInt(OBJECT_SELF,"TRP_TRIGGERED",1);

    object oTrap = GetNearestObjectByTag("WhirllingBlade", oPC);
    if(oTrap == OBJECT_INVALID)
        SpeakString("Invalid Trap!");

    SetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ",oTrap);

    TrapPlayAnim(oTrap);
    //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,EffectAreaOfEffect(40),GetLocation(oTrap),120.0);
    DelayCommand(0.5f, DoWhirlBladeDamage());
    DelayCommand(120.0, ResetWhirlingBlades());
}
