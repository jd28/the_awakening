#include "nwnx_inc"
#include "vfx_inc"

void main(){
    if(GetLocalInt(OBJECT_SELF, "Polyed")) return;

    if(GetCurrentHitPoints() < GetMaxHitPoints() / 4){
        SetLocalInt(OBJECT_SELF, "Polyed", TRUE);

        ApplyVisualToObject(VFX_IMP_POLYMORPH, OBJECT_SELF);
        SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_DRAGON_BLACK);
        SetBaseAttackBonus(6);
        ModifyAbilityScore(OBJECT_SELF, ABILITY_STRENGTH, 20);

        SetCurrentHitPoints(OBJECT_SELF, 4000);
        SpeakString("YE'LL DIE THIS DAY!!!");
        SetImmortal(OBJECT_SELF, FALSE);
    }
}
