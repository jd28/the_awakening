#include "gsp_func_inc"
#include "pl_pcinvo_inc"
#include "x2_inc_toollib"

//Blackstaff

// updated to TA2

int GetOnHitDC(int clevel){
    if(clevel >= 51)
        return 25;
    else if(clevel >= 41)
        return 20;
    else if(clevel >= 31)
        return 15;
    else if(clevel >= 21)
        return IP_CONST_ONHIT_SAVEDC_26;
    else if(clevel >= 11)
        return IP_CONST_ONHIT_SAVEDC_14;
    else
        return 8;
}

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nAmount, nVis = VFX_IMP_SUPER_HEROISM, bDrow, nBonus = 1, nCap, bSingleTarget = TRUE;
    int bDual = FALSE;
    int nDamType, nWpnVFX, nNoStack;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    float fDuration, fDelay;
    struct EquippedWeapons ew;

    if(si.id == SPELL_GREATER_MAGIC_WEAPON && GetIsObjectValid(si.item)
       && GetTag(si.item) == "pl_subitem_011"){
        ew = GetTargetedOrEquippedWeapon(si.target, FALSE, FALSE);
        bDrow = TRUE;
        si.clevel = GetLevelIncludingLL(si.caster);
        if(si.caster != GetItemPossessor(ew.oOnHand)){
            ErrorMessage(si.caster, "You may only use this on weapons in your possession!");
            return;
        }
    }
    switch(si.id){
        // Weapons
        case SPELL_MAGIC_WEAPON:
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_HOURS);
            nAmount = 1;
        break;
        case SPELL_GREATER_MAGIC_WEAPON:
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_HOURS);

            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, si.caster))
                nBonus = 2;
            else if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, si.caster))
                nBonus = 1;
            else{
                nAmount = si.clevel / 5;
                if(nAmount == 0)     nAmount = 1;
                else if(nAmount > 6) nAmount = 6;
            }

            if(!bDrow && GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, si.caster))
                bSingleTarget = FALSE;

            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, si.caster))
                nCap = GetLevelByClass(si.class, si.caster) / 5;
            else
                nCap = GetLevelByClass(si.class, si.caster) / 6;
        break;
        case SPELL_KEEN_EDGE:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, si.caster))
                bSingleTarget = FALSE;
            fDuration = MetaDuration(si, 10 * si.clevel, DURATION_IN_TURNS);
        break;
        case SPELL_BLESS_WEAPON:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, si.caster))
                bSingleTarget = FALSE;
            fDuration = MetaDuration(si, 2 * si.clevel, DURATION_IN_TURNS);
        break;
        case SPELL_FLAME_WEAPON:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, si.caster))
                bSingleTarget = FALSE;
            if(si.clevel > 20) si.clevel = 20;
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            nVis = VFX_IMP_PULSE_FIRE;
            nDamType = DAMAGE_TYPE_FIRE;
            nNoStack = SPELL_DARKFIRE;
            nWpnVFX = ITEM_VISUAL_FIRE;
        break;
        case SPELL_DARKFIRE:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, si.caster))
                bSingleTarget = FALSE;
            if(si.clevel > 20) si.clevel = 20;
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            nVis = VFX_IMP_PULSE_FIRE;
            nDamType = DAMAGE_TYPE_FIRE;
            nNoStack = SPELL_FLAME_WEAPON;
            nWpnVFX = ITEM_VISUAL_FIRE;
        break;
        case SPELL_DEAFENING_CLANG:
            if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, si.caster))
                bSingleTarget = FALSE;
            fDuration = MetaDuration(si, si.clevel);
        break;
        case SPELL_HOLY_SWORD:
            fDuration = MetaDuration(si, si.clevel);
            nVis = VFX_IMP_GOOD_HELP;
        break;
        case SPELL_BLADE_THIRST:
            si.target = si.caster;
            nVis = VFX_IMP_SUPER_HEROISM;
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_HOURS);

            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, si.caster))
                nBonus = 2;
            else if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, si.caster))
                nBonus = 1;
            else{
                nAmount = si.clevel / 5;
                if(nAmount == 0)     nAmount = 1;
                else if(nAmount > 6) nAmount = 6;
            }

            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, si.caster))
                nCap = GetLevelByClass(si.class, si.caster) / 5;
            else
                nCap = GetLevelByClass(si.class, si.caster) / 6;

            bDual = TRUE;
        break;
        case SPELLABILITY_AS_DARKNESS:
            si.target = si.caster;
            si.clevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, si.caster);
            fDuration = MetaDuration(si, si.clevel);
            bDual = TRUE;
        break;
        case TASPELL_SHADOW_STRIKE:
            si.target = si.caster;
            si.clevel = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, si.caster);
            fDuration = MetaDuration(si, si.clevel);
            bDual = TRUE;
        break;
        case 1514: // Hellfire
            si.clevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, si.caster);
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            bDual = TRUE;
        break;
    }

    if(bSingleTarget){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        if(si.id == SPELL_GREATER_MAGIC_WEAPON || si.id == SPELL_KEEN_EDGE)
            ew = GetTargetedOrEquippedWeapon(si.target, bDual, TRUE);
        else
            ew = GetTargetedOrEquippedWeapon(si.target, bDual, FALSE);

        if(!GetIsObjectValid(ew.oOnHand)){
            FloatingTextStrRefOnCreature(83615, si.caster);
            return;
        }

        switch(si.id){
            // Weapons
            case SPELL_MAGIC_WEAPON:
                AddEnhancementToEquippedWeapons(ew, 1, fDuration);
            break;
            case SPELL_GREATER_MAGIC_WEAPON:
                if(nAmount == 0)
                    nAmount = GetItemEnhancementBonus(ew.oOnHand) + nBonus;

                AddEnhancementToEquippedWeapons(ew , nAmount, fDuration);
                if(bDrow){
                    itemproperty ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN, GetOnHitDC(si.clevel), IP_CONST_ABILITY_STR);
                    IPSafeAddItemProperty(ew.oOnHand, ip, fDuration);
                }
            break;
            case SPELL_KEEN_EDGE:
                AddMiscPropertyToEquippedWeapons(ew, ItemPropertyKeen(), fDuration);
            break;
            case SPELL_BLESS_WEAPON:
                AddDmgBonusToEquippedWeapons(ew, fDuration, IP_CONST_DAMAGEBONUS_2d6, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_RACIALTYPE_UNDEAD);
                AddVisualToEquippedWeapons(ew, ITEM_VISUAL_HOLY, fDuration);
            break;
            case SPELL_FLAME_WEAPON:
            case SPELL_DARKFIRE:
                // No stack with dark fire.
                if(GetLocalInt(ew.oOnHand, "OnHitEnd_" + IntToString(nNoStack)))
                    RemoveOnHitSpell(ew.oOnHand, nNoStack);
                if(bDual && GetLocalInt(ew.oOffHand, "OnHitEnd_" + IntToString(nNoStack)))
                    RemoveOnHitSpell(ew.oOffHand, nNoStack);

                AddOnHitDamageToEquippedWeapons(si, ew, DAMAGE_TYPE_FIRE, si.clevel, fDuration);
                AddVisualToEquippedWeapons(ew, nWpnVFX, fDuration);
            break;
            case SPELL_DEAFENING_CLANG:
                AddDmgBonusToEquippedWeapons(ew, fDuration, IP_CONST_DAMAGEBONUS_3, IP_CONST_DAMAGETYPE_SONIC);
                AddOnHitSpellToEquippedWeapons(ew, 137, 5, fDuration );
                AddVisualToEquippedWeapons(ew, ITEM_VISUAL_SONIC, fDuration);
            break;
            case SPELL_HOLY_SWORD:
                AddMiscPropertyToEquippedWeapons(ew, ItemPropertyHolyAvenger(), fDuration);
            break;
            case SPELL_BLADE_THIRST:
                if(nAmount == 0)
                    nAmount = GetItemEnhancementBonus(ew.oOnHand) + nBonus;

                AddEnhancementToEquippedWeapons(ew, nAmount, fDuration);
                if(GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES, si.caster) && si.caster == GetItemPossessor(ew.oOnHand))
                    AddOnHitDamageToEquippedWeapons(si, ew, DAMAGE_TYPE_DIVINE, GetLevelByClass(CLASS_TYPE_RANGER, si.caster) / 3, fDuration);
            break;
            case SPELLABILITY_AS_DARKNESS:
            case TASPELL_SHADOW_STRIKE:
                si.clevel /= 5;
                if(si.clevel > 0){
                    AddDmgBonusToEquippedWeapons(ew, fDuration, IPGetDamageBonusConstantFromNumber(si.clevel), IP_CONST_DAMAGETYPE_NEGATIVE);
                    AddVisualToEquippedWeapons(ew, ITEM_VISUAL_EVIL, fDuration);
                }
            break;
            case 1514: //Hellfire
                if(si.clevel >= 40 ){
                    AddDmgBonusToEquippedWeapons(ew, fDuration, CEP_IP_CONST_DAMAGEBONUS_4d10, IP_CONST_DAMAGETYPE_FIRE);
                }
                else if(si.clevel >= 30 ){
                    AddDmgBonusToEquippedWeapons(ew, fDuration, CEP_IP_CONST_DAMAGEBONUS_3d10, IP_CONST_DAMAGETYPE_FIRE);
                }
                else if(si.clevel >= 20 ){
                    AddDmgBonusToEquippedWeapons(ew, fDuration, DAMAGE_BONUS_2d10, IP_CONST_DAMAGETYPE_FIRE);
                }
                else
                    return;

                AddVisualToEquippedWeapons(ew, ITEM_VISUAL_FIRE, fDuration);
            break;
        }

        //Apply the bonus effect and VFX impact
        ApplyVisualToObject(nVis, GetItemPossessor(ew.oOnHand));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(ew.oOnHand), fDuration);
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

            if(si.id == SPELL_GREATER_MAGIC_WEAPON ||
               si.id == SPELL_KEEN_EDGE){ // Allow ranged
                ew = GetTargetedOrEquippedWeapon(si.target, bDual, TRUE);
            }
            else{
                ew = GetTargetedOrEquippedWeapon(si.target, bDual, FALSE);
            }
            if(!GetIsObjectValid(ew.oOnHand)){
                FloatingTextStrRefOnCreature(83615, si.caster);
                continue;
            }

            switch(si.id){
                // Weapons
                case SPELL_MAGIC_WEAPON:
                    fDuration = MetaDuration(si, si.clevel, DURATION_IN_HOURS);
                    AddEnhancementToEquippedWeapons(ew, 1, fDuration);
                break;
                case SPELL_GREATER_MAGIC_WEAPON:
                    if(nAmount == 0)
                        nAmount = GetItemEnhancementBonus(ew.oOnHand) + nBonus;

                    AddEnhancementToEquippedWeapons(ew, nAmount, fDuration);
                break;
                case SPELL_KEEN_EDGE:
                    AddMiscPropertyToEquippedWeapons(ew, ItemPropertyKeen(), fDuration);
                break;
                case SPELL_BLESS_WEAPON:
                    AddDmgBonusToEquippedWeapons(ew, fDuration, IP_CONST_DAMAGEBONUS_2d6, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_RACIALTYPE_UNDEAD);
                    AddVisualToEquippedWeapons(ew, ITEM_VISUAL_HOLY, fDuration);
                break;
                case SPELL_FLAME_WEAPON:
                case SPELL_DARKFIRE:
                    // No stack with dark fire.
                    if(GetLocalInt(ew.oOnHand, "OnHitEnd_" + IntToString(nNoStack)))
                        RemoveOnHitSpell(ew.oOnHand, nNoStack);
                    if(bDual && GetLocalInt(ew.oOffHand, "OnHitEnd_" + IntToString(nNoStack)))
                        RemoveOnHitSpell(ew.oOffHand, nNoStack);

                    AddOnHitDamageToEquippedWeapons(si, ew, DAMAGE_TYPE_FIRE, si.clevel, fDuration);
                    AddVisualToEquippedWeapons(ew, nWpnVFX, fDuration);
                break;
                case SPELL_DEAFENING_CLANG:
                    AddDmgBonusToEquippedWeapons(ew, fDuration, IP_CONST_DAMAGEBONUS_3, IP_CONST_DAMAGETYPE_SONIC);
                    AddOnHitSpellToEquippedWeapons(ew, 137, 5, fDuration );
                    AddVisualToEquippedWeapons(ew, ITEM_VISUAL_SONIC, fDuration);
                break;
                case SPELL_HOLY_SWORD:
                    AddMiscPropertyToEquippedWeapons(ew, ItemPropertyHolyAvenger(), fDuration);
                break;
            }
            //Apply the bonus effect and VFX impact
            ApplyVisualToObject(nVis, GetItemPossessor(ew.oOnHand));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(ew.oOnHand), fDuration);
        }
    }
}
