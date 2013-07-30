//::///////////////////////////////////////////////
//:: x2_s2_whirl.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////

#include "gsp_func_inc"
void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0)
        return;

    struct SpellImpact impact = CreateSpellImpact();
    struct FocusBonus fb;
    int bImproved = (GetSpellId() == 645);// improved whirlwind

    impact.fRadius = RADIUS_SIZE_MEDIUM;


    if(GetLevelByClass(CLASS_TYPE_SHADOWDANCER, si.caster) > 0){
        si.clevel        = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, si.caster);
        impact.nDamDice  = si.clevel;
        impact.nDamType  = DAMAGE_TYPE_NEGATIVE;
        impact.nDamSides = 6;
    }
    else if(GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, si.caster) > 0){
        si.clevel        = GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, si.caster);
        impact.nDamDice  = si.clevel;
        impact.nDamType  = DAMAGE_TYPE_SLASHING;
        impact.nDamSides = 10;
    }
    else{
        si.clevel        = GetHitDice(si.caster);
        if(si.clevel > 40)
            si.clevel = 40;
        impact.nDamDice  = si.clevel;
        impact.nDamType  = DAMAGE_TYPE_SLASHING;
        impact.nDamSides = 4;
    }

    /* Play random battle cry */
    switch (d10()){
        case 1: PlayVoiceChat(VOICE_CHAT_BATTLECRY1); break;
        case 2: PlayVoiceChat(VOICE_CHAT_BATTLECRY2); break;
        case 3: PlayVoiceChat(VOICE_CHAT_BATTLECRY3); break;
    }

    // * GZ, Sept 09, 2003 - Added dust cloud to improved whirlwind
    if (bImproved){
      effect eVis = EffectVisualEffect(460);
      DelayCommand(3.0f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,OBJECT_SELF));
    }

    ActionPlayAnimation(22);
    DelayCommand(3.0f, ApplyTouchImpactToShape(si, impact, fb));

    if(bImproved)
        DelayCommand(3.5f, ApplyTouchImpactToShape(si, impact, fb));
    
}

