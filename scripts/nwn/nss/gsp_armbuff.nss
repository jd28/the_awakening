//::///////////////////////////////////////////////
//:: Magic Vestment
//:: X2_S0_MagcVest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants a +1 AC bonus to armor touched per 3 caster
  levels (maximum of +5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 09, 2003
//:: 2003-07-29: Rewritten, Georg Zoeller

#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    object oArmor;
    int nCap, nBonus, nVis, nAmount;
    float fDuration, fDelay;
    
    int bSingleTarget = TRUE;
    int bShields      = FALSE;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    switch (si.id){
        case SPELL_MAGIC_VESTMENT:
            bShields  = TRUE;
            nVis      = VFX_IMP_GLOBE_USE;
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_HOURS);

            if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, si.caster))
                nBonus = 2;

            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, si.caster))
                bSingleTarget = FALSE;

            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, si.caster))
                nCap = GetLevelByClass(si.class, si.caster) / 5;
            else
                nCap = GetLevelByClass(si.class, si.caster) / 6;

        break;
        case SPELL_STONEHOLD:
            nVis      = VFX_COM_CHUNK_STONE_MEDIUM;
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            si.target = si.caster;
        break;
    }

    if(bSingleTarget){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        oArmor = GetTargetedOrEquippedArmor(si.target, bShields);
        if(oArmor == OBJECT_INVALID){
            FloatingTextStrRefOnCreature(83826, si.caster);
            return;
        }

        switch(si.id){
            case SPELL_MAGIC_VESTMENT:
                nAmount = GetItemEnhancementBonus(oArmor) + nBonus;
                if(nAmount > nCap)     nAmount = nCap;
                else if (nAmount == 0) nAmount = 1;
                    
                AddACBonusToArmor(oArmor, fDuration, nAmount); 
            break;
            case SPELL_STONEHOLD:
                AddOnHitSpellToWeapon(oArmor, IP_CONST_ONHIT_CASTSPELL_ONHIT_CHAOSSHIELD, 40, fDuration);
            break;
        }

        //Apply the bonus effect and VFX impact
        ApplyVisualToObject(nVis, GetItemPossessor(oArmor));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oArmor), fDuration);
    }
    else{
        //Get the first target in the radius around the caster
        for(si.target = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, si.loc);
            si.target != OBJECT_INVALID;
            si.target = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, si.loc)){

            if(!GetIsReactionTypeFriendly(si.target) && !GetFactionEqual(si.target))
                continue;

            fDelay = GetRandomDelay(0.4, 1.1);
            //Fire spell cast at event for target
            SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

            oArmor = GetTargetedOrEquippedArmor(si.target, TRUE);
            if(oArmor == OBJECT_INVALID){
                FloatingTextStrRefOnCreature(83826, si.caster);
                continue;
            }

            switch(si.id){
                case SPELL_MAGIC_VESTMENT:
                    nAmount = GetItemEnhancementBonus(oArmor) + nBonus;
                    if(nAmount > nCap)     nAmount = nCap;
                    else if (nAmount == 0) nAmount = 1;
                        
                    AddACBonusToArmor(oArmor, fDuration, nAmount); 
                break;
            }

            //Apply the bonus effect and VFX impact
            ApplyVisualToObject(nVis, GetItemPossessor(oArmor));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oArmor), fDuration);
        }
    }
}
