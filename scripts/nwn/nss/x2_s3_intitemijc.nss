//::///////////////////////////////////////////////
//:: User Defined OnHitCastSpell code
//:: x2_s3_onhitcast
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-22
//:://////////////////////////////////////////////

//#include "x2_inc_itemprop"
//#include "x2_inc_intweapon"
#include "gsp_func_inc"
#include "nwnx_inc"

// Spells...
// SPELL_BLADE_THIRST
// SPELL_DARKFIRE
// SPELL_DEAFENING_CLANG
// SPELL_FLAME_WEAPON
// SPELLABILITY_AS_DARKNESS
/*
void SetItemPropertiesFromSpellDurations (object oItem, int nSpellId, float fDur) {
    object oCreator = GenCreator();
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip)) {
        if (GetItemPropertyDurationType(ip) == DURATION_TYPE_TEMPORARY &&
            GetItemPropertySpellId(ip) == nSpellId) {
            RemoveItemProperty(oItem, ip);
            AssignCommand(oCreator, DelayCommand(0.1, AddItemProperty(DURATION_TYPE_TEMPORARY, ip, oItem, fDur)));
        }
        ip = GetNextItemProperty(oItem);
    }
}

void DegradeOnHitProperties (object oWeapon, itemproperty ip, int nSpellId, int nDegrade, object oCreator) {
    if (!GetIsObjectValid(oWeapon) || !GetIsItemPropertyValid(ip))
        return;
    if (GetIsObjectValid(oCreator)                &&
        GetArea(oCreator) == GetArea(OBJECT_SELF) &&
        GetFactionEqual(oCreator, OBJECT_SELF)    &&
        !GetPCOption(oCreator, PCOPTION_NOAUTOREBUFF)) {
        int nHasSpell = GetHasSpell(nSpellId, oCreator);
        if (nHasSpell > 0) {
            DecrementRemainingSpellUses(oCreator, nSpellId);
            if (nHasSpell > GetHasSpell(nSpellId, oCreator)) {
                FloatingTextStringOnCreature(C_MED_ORANGE + "* Auto-recasting " +
                    SFGetSpellName(nSpellId) + " for " + GetName(OBJECT_SELF) + "! *" + C_END,
                    oCreator, FALSE);
                SetLocalInt(oWeapon, "OnHitCreatorRests_" + IntToString(nSpellId), GetLocalInt(oCreator, "Rests"));
                return;
            }
            FloatingTextStringOnCreature(C_MED_ORANGE + "* Unable to auto-recast " +
                SFGetSpellName(nSpellId) + " for " + GetName(OBJECT_SELF) + "! *" + C_END,
                oCreator, FALSE);
        } else {
            FloatingTextStringOnCreature(C_MED_ORANGE + "* No casts left to refresh " +
                SFGetSpellName(nSpellId) + " for " + GetName(OBJECT_SELF) + "! *" + C_END,
                oCreator, FALSE);
        }
    }
    float fDur = GetItemPropertyDurationRemaining(ip) / 2.0;
    SetItemPropertiesFromSpellDurations(oWeapon, nSpellId, fDur);
    if (GetIsObjectValid(oCreator))
        SetLocalInt(oWeapon, "OnHitCreatorRests_" + IntToString(nSpellId), GetLocalInt(oCreator, "Rests"));
    string sBy = GetLocalString(oWeapon, "OnHitCreatorName_" + IntToString(nSpellId));
    if (sBy != "")
        sBy = "(by " + sBy + ") ";
    FloatingTextStringOnCreature(C_MED_ORANGE + "* The " + SFGetSpellName(nSpellId) + " effect " +
        sBy + "on your " + GetName(oWeapon) + " has degraded! *" + C_END, OBJECT_SELF, FALSE);
}
*/

void main(){
    object oCaster = OBJECT_SELF;
    object oWeapon = GetSpellCastItem();
    object oTarget = GetSpellTargetObject();
    object oCreator;

    int nVis = GetLocalInt(oWeapon, "OnHitVFX"), nSpell;
    int bUnblockable = FALSE;
    string sProp;

    // TYPE,DICE,SIDES,BONUS
    string sDamages = GetLocalString(oWeapon, "OnHitDamages");
    string sHeal = GetLocalString(oWeapon, "OnHitHeal");

    //string sEffects = GetLocalString(oWeapon, "OnHitEffects");
    string sScripts = GetLocalString(oWeapon, "OnHitScripts");
    int nBreach = GetLocalInt(oWeapon, "OnHitBreach"), nEnd;


    // If there is no End then there is no effect.
    nSpell = SPELL_BLADE_THIRST;
    if((nEnd = GetLocalInt(oWeapon, "OnHitEnd_" + IntToString(nSpell))) > 0){
        oCreator = GetLocalObject(oWeapon, "OnHitCreator_" + IntToString(nSpell));
        // If duration is over, creator is invalid, or creator has rested: remove effects
        if(GetLocalInt(GetModule(), "MOD_RESET_TIMER") >= nEnd
           || !GetIsObjectValid(oCreator)
           || GetLocalInt(oWeapon, "OnHitRests_" + IntToString(nSpell)) < GetLocalInt(oCreator, "Rests"))
        {
            RemoveOnHitSpell(oWeapon, nSpell);
        }
        else if (GetLocalInt( oCaster, "FE_"+IntToString(GetRacialType(oTarget)))
                 && (sProp = GetLocalString(oWeapon, "OnHitDamages_" + IntToString(nSpell))) != "") {
            bUnblockable = TRUE;
            if (sDamages != "")
                sDamages += " " + sProp;
            else
                sDamages = sProp;

            if (sHeal != "")
                sHeal += " " + sProp;
            else
                sHeal = sProp;
        }
    }

    nSpell = SPELL_DARKFIRE;
    if((nEnd = GetLocalInt(oWeapon, "OnHitEnd_" + IntToString(nSpell))) > 0){
        oCreator = GetLocalObject(oWeapon, "OnHitCreator_" + IntToString(nSpell));
        // If duration is over, creator is invalid, or creator has rested: remove effects
        if(GetLocalInt(GetModule(), "MOD_RESET_TIMER") >= nEnd
           || !GetIsObjectValid(oCreator)
           || GetLocalInt(oWeapon, "OnHitRests_" + IntToString(nSpell)) < GetLocalInt(oCreator, "Rests"))
        {
            RemoveOnHitSpell(oWeapon, nSpell);
        }
        else if ((sProp = GetLocalString(oWeapon, "OnHitDamages_" + IntToString(nSpell))) != "") {
            if (sDamages != "")
                sDamages += " " + sProp;
            else
                sDamages = sProp;
        }
    }

    nSpell = SPELL_FLAME_WEAPON;
    if((nEnd = GetLocalInt(oWeapon, "OnHitEnd_" + IntToString(nSpell))) > 0){
        oCreator = GetLocalObject(oWeapon, "OnHitCreator_" + IntToString(nSpell));
        // If duration is over, creator is invalid, or creator has rested: remove effects
        if(GetLocalInt(GetModule(), "MOD_RESET_TIMER") >= nEnd
           || !GetIsObjectValid(oCreator)
           || GetLocalInt(oWeapon, "OnHitRests_" + IntToString(nSpell)) < GetLocalInt(oCreator, "Rests"))
        {
            RemoveOnHitSpell(oWeapon, nSpell);
        }
        else if ((sProp = GetLocalString(oWeapon, "OnHitDamages_" + IntToString(nSpell))) != "") {
            if (sDamages != "")
                sDamages += " " + sProp;
            else
                sDamages = sProp;
        }
    }

    nSpell = SPELLABILITY_AS_DARKNESS;
    if((nEnd = GetLocalInt(oWeapon, "OnHitEnd_" + IntToString(nSpell))) > 0){
        oCreator = GetLocalObject(oWeapon, "OnHitCreator_" + IntToString(nSpell));
        // If duration is over, creator is invalid, or creator has rested: remove effects
        if(GetLocalInt(GetModule(), "MOD_RESET_TIMER") >= nEnd
           || !GetIsObjectValid(oCreator)
           || GetLocalInt(oWeapon, "OnHitRests_" + IntToString(nSpell)) < GetLocalInt(oCreator, "Rests"))
        {
            RemoveOnHitSpell(oWeapon, nSpell);
        }
        else if ((sProp = GetLocalString(oWeapon, "OnHitDamages_" + IntToString(nSpell))) != "") {
            if (sDamages != "")
                sDamages += " " + sProp;
            else
                sDamages = sProp;
        }
    }
/*
    nSpell = SPELLABILITY_BG_CONTAGION;
    if((nEnd = GetLocalInt(oWeapon, "OnHitEnd_" + IntToString(nSpell))) > 0){
        oCreator = GetLocalObject(oWeapon, "OnHitCreator_" + IntToString(nSpell));
        // If duration is over, creator is invalid, or creator has rested: remove effects
        if(GetLocalInt(GetModule(), "MOD_RESET_TIMER") >= nEnd
                || !GetIsObjectValid(oCreator)
                || GetLocalInt(oWeapon, "OnHitRests_" + IntToString(nSpell)) < GetLocalInt(oCreator, "Rests")){
            RemoveOnHitSpell(oWeapon, nSpell);
        }
        else if ((sProp = GetLocalString(oWeapon, "OnHitDamages_" + IntToString(nSpell))) != ""
                && !GetHasSpellEffect(SPELLABILITY_BG_CONTAGION, oTarget)) {
            
            struct SubString temp = GetFirstSubString(sProp, ",");
            effect eWound = EffectWounding(StringToInt(temp.first));
            SetEffectSpellId(eWound, SPELLABILITY_BG_CONTAGION);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWound, oTarget, RoundsToSeconds(5));
        }
    }
*/
    nSpell = SPELLABILITY_BARBARIAN_RAGE;
    if((nEnd = GetLocalInt(oWeapon, "OnHitEnd_" + IntToString(nSpell))) > 0){
        oCreator = GetLocalObject(oWeapon, "OnHitCreator_" + IntToString(nSpell));
        // If duration is over, creator is invalid, or creator has rested: remove effects
        if(GetLocalInt(GetModule(), "MOD_RESET_TIMER") >= nEnd
                || !GetIsObjectValid(oCreator)
                || GetLocalInt(oWeapon, "OnHitRests_" + IntToString(nSpell)) < GetLocalInt(oCreator, "Rests")){
            RemoveOnHitSpell(oWeapon, nSpell);
        }
        else if ((sProp = GetLocalString(oWeapon, "OnHitDamages_" + IntToString(nSpell))) != "") {
            if (sDamages != "")
                sDamages += " " + sProp;
            else
                sDamages = sProp;
        }
    }


/*
    if(GetHasSpellEffect(SPELL_DEAFENING_CLANG, oCaster))
    {
        nEnd = GetLocalInt(oWeapon, "OnHitEnd_" + IntToString(SPELL_DEAFENING_CLANG));
        if(nEnd && GetLocalInt(GetModule(), "MOD_RESET_TIMER") >= nEnd){
            RemoveOnHitSpell(oWeapon, SPELL_FLAME_WEAPON);
        }
        else{
            if ((sProp = GetLocalString(oWeapon, "OnHitDamages_" + IntToString(SPELL_DEAFENING_CLANG))) != "") {
                if (sDamages != "")
                    sDamages += " " + sProp;
                else
                    sDamages = sProp;
            }

        }
    }
*/
    struct SubString ss;
    // apply unique on-hit scripts
    if (sScripts != "") {
        ss.rest = sScripts;
        while (ss.rest != "") {
            ss = GetFirstSubString(ss.rest);
            ExecuteScript(ss.first, oCaster);
        }
    }
    // if any scripts set OnHitAbort, stop further on-hit processing; don't
     // check this in the script loop proper to ensure all scripts always fire.
    if (GetLocalInt(oWeapon, "OnHitAbort")) {
        DeleteLocalInt(oWeapon, "OnHitAbort");
        return;
    }

    // if the weapon has any added damage types (e.g. Flame Weapon), apply them
    if (sDamages != "") {
        int i, nDamage, nDamages = 0;
        effect eDamage;
        struct IntList il;
        ss.rest = sDamages;
        while (ss.rest != "") {
            ss = GetFirstSubString(ss.rest);
            il = GetIntList(ss.first, ",");
            switch (il.i1) {
                case -1:  // AA elemental bows
                    il.i1 = 5;
                    il.i2 = 20;
                    break;
                case -2:  // AA exotic bows
                    il.i1 = 4;
                    il.i2 = 20;
                    break;
            }
            if (nVis < 1) {
                switch (il.i0) {
                    case DAMAGE_TYPE_ACID:       nVis = VFX_COM_HIT_ACID;       break;
                    case DAMAGE_TYPE_COLD:       nVis = VFX_COM_HIT_FROST;      break;
                    case DAMAGE_TYPE_ELECTRICAL: nVis = VFX_COM_HIT_ELECTRICAL; break;
                    case DAMAGE_TYPE_FIRE:       nVis = VFX_COM_HIT_FIRE;       break;
                    case DAMAGE_TYPE_SONIC:      nVis = VFX_COM_HIT_SONIC;      break;
                    case DAMAGE_TYPE_DIVINE:     nVis = VFX_COM_HIT_DIVINE;     break;
                    case DAMAGE_TYPE_MAGICAL:    nVis = VFX_IMP_CHARM;          break;
                    case DAMAGE_TYPE_NEGATIVE:   nVis = VFX_COM_HIT_NEGATIVE;   break;
                    case DAMAGE_TYPE_POSITIVE:   nVis = VFX_IMP_MAGBLUE;        break;
                    default: nVis = VFX_COM_BLOOD_SPARK_MEDIUM; break;
                }
            }
            nDamage = il.i1 + il.i3;
            for (i = 0; i < il.i1; i++)
                nDamage += Random(il.i2);
            if (nDamages == 0)
                eDamage = EffectDamage(nDamage, il.i0);
            else
                eDamage = EffectLinkEffects(eDamage, EffectDamage(nDamage, il.i0));
            nDamages++;
        }
        // ensure added damage types don't cause kickback
        //if (GetLocalInt(oTarget, "Feedback_1_Type")) {
        //    SetLocalInt(oTarget, "FeedbackIgnore", nDamages);
        //    SetLocalObject(oTarget, "FeedbackIgnore", oCaster);
        //}
        if(bUnblockable)
            SetEffectInteger(eDamage, 17, 1);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    }
    // apply a visual effect if one was set, which may have been dynamically
     // determined in the damage loop
    if (nVis > 0)
        ApplyVisualToObject(nVis, oTarget);

    // If we have some heal on hit...
    if (sHeal != "") {
        int i, nDamage, nDamages = 0;
        effect eDamage;
        struct IntList il;
        ss.rest = sHeal;
        while (ss.rest != "") {
            ss = GetFirstSubString(ss.rest);
            il = GetIntList(ss.first, ",");

            nDamage = il.i1 + il.i3;
            for (i = 0; i < il.i1; i++)
                nDamage += Random(il.i2);
            if (nDamages == 0)
                eDamage = EffectHeal(nDamage);
            else
                eDamage = EffectLinkEffects(eDamage, EffectHeal(nDamage));
            nDamages++;
        }
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCaster);
    }


}

/*
    // apply special on-hit effects
    if (sEffects != "") {
        int nPos, nDurType, nSubType, bPetrify, bSelf, bLast = FALSE;
        float fDur;
        string sDur;
        effect eLink;
        struct IntList il;
        struct SubString css;
        ss.rest = sEffects;
        // parse each effect in turn
        while (ss.rest != "") {
            ss  = GetFirstSubString(ss.rest);
            css = GetFirstSubString(ss.first, "|");
            // if the effect has any pre-effect checks (e.g. random chance, saving throw),
            // make them before applying the effect
            if (css.rest != "") {
                ss.first = css.first;
                if (css.rest == "&") {
                    if (!bLast)
                        continue;
                } else if (css.rest == "^") {
                    if (!(bLast = !bLast))
                        continue;
                } else {
                    bLast = !CheckDynamic(css.rest, oTarget, OBJECT_SELF);
                    // CheckDynamic returns TRUE if they pass; we invert it above so
                    // bLast is 'did the last effect go through'
                    if (!bLast)
                        continue;
                }
            }

            if ((nPos = FindSubString(ss.first, "#")) >= 0) {
                nSpellId = StringToInt(GetStringRight(ss.first, GetStringLength(ss.first) - (nPos + 1)));
                ss.first = GetStringLeft(ss.first, nPos);
                if (GetHasSpellEffect(nSpellId, oTarget))
                    continue;
            } else
                nSpellId = -1;

            // check if the effect has an associated visual
            if ((nPos = FindSubString(ss.first, "/")) >= 0) {
                nVis     = StringToInt(GetStringRight(ss.first, GetStringLength(ss.first) - (nPos + 1)));
                ss.first = GetStringLeft(ss.first, nPos);
            } else
                nVis = 0;

            nSubType = 0;
            bPetrify = FALSE;
            bSelf    = FALSE;
            // check if the effect has a duration parameter specified; if so, apply it;
            // otherwise, determine the duration of the effect automatically
            if ((nPos = FindSubString(ss.first, ":")) >= 0) {
                sDur     = GetStringRight(ss.first, GetStringLength(ss.first) - (nPos + 1));
                ss.first = GetStringLeft(ss.first, nPos);
                // check if a subtype was specified
                if ((nPos = FindSubString(sDur, ":")) >= 0) {
                    string sSub = GetStringRight(sDur, 1);
                    if (sSub == "E")
                        nSubType = SUBTYPE_EXTRAORDINARY;
                    else if (sSub == "S")
                        nSubType = SUBTYPE_SUPERNATURAL;
                    sDur = GetStringLeft(sDur, nPos);
                }
                if ((nPos = FindSubString(sDur, "+")) >= 0) {
                    int nRandDur = StringToInt(GetStringRight(sDur, GetStringLength(sDur) - (nPos + 1)));
                    fDur = StringToFloat(GetStringLeft(sDur, nPos)) + Random(nRandDur);
                } else
                    fDur = StringToFloat(sDur);
                if (fDur < 0.0) {
                    fDur = 0.0;
                    nDurType = DURATION_TYPE_PERMANENT;
                } else if (fDur == 0.0)
                    nDurType = DURATION_TYPE_INSTANT;
                else
                    nDurType = DURATION_TYPE_TEMPORARY;

                int bFirst = TRUE;
                struct SubString sss;
                sss.rest = ss.first;
                while (sss.rest != "") {
                    sss = GetFirstSubString(sss.rest, ";");
                    il = GetIntList(sss.first, ",");
                    if (bFirst) {
                        bFirst = FALSE;
                        eLink  = EffectDynamic(il.i0, il.i1, il.i2, il.i3, il.i4, il.i5, il.i6);
                    } else
                        eLink = EffectLinkEffects(eLink, EffectDynamic(il.i0, il.i1, il.i2, il.i3, il.i4, il.i5, il.i6));
                }
            } else {
                il = GetIntList(ss.first, ",");
                if (il.i0 < 100) {
                    fDur     = 6.0;
                    nDurType = DURATION_TYPE_TEMPORARY;
                } else {
                    fDur     = 0.0;
                    nDurType = DURATION_TYPE_INSTANT;
                }
                if (il.i0 == EFFECT_TYPE_HEAL)
                    bSelf = TRUE;
                else if (il.i0 == EFFECT_TYPE_PETRIFY)
                    bPetrify = TRUE;
                eLink = EffectDynamic(il.i0, il.i1, il.i2, il.i3, il.i4, il.i5, il.i6);
            }
            if (bSelf) {
                if (GetCurrentHitPoints(oCaster) < GetMaxHitPoints(oCaster)) {
                    if (nVis > 0)
                        ApplyVisualToObject(nVis, oCaster);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oCaster);
                }
            } else {
                if (nVis > 0)
                    ApplyVisualToObject(nVis, oTarget);
                else if (nVis < 0)
                    eLink = EffectLinkEffects(eLink, EffectVisualEffect(-nVis));
                if (nSubType == SUBTYPE_EXTRAORDINARY)
                    eLink = ExtraordinaryEffect(eLink);
                else if (nSubType == SUBTYPE_SUPERNATURAL)
                    eLink = SupernaturalEffect(eLink);
                if (nSpellId >= 0)
                    SetEffectSpellId(eLink, nSpellId);
                if (bPetrify)
                    ApplyPetrifyEffect(nDurType, eLink, oTarget, fDur);
                else
                    ApplyEffectToObject(nDurType, eLink, oTarget, fDur);
            }
        }
    }

    if (nBreach != 0) {
        if (nBreach < 0) {
            int nLevel = GetHitDiceIncludingLLs(oCaster);
            if (nLevel > 60)
                nLevel = 60;
            DoBreachAndDispel(oTarget, nLevel, 100, 0, 0, SPELL_DISPEL_MAGIC);
        } else if (nBreach > 100) {
            DoBreachAndDispel(oTarget, nBreach - 100, 100, 6, 10, SPELL_MORDENKAINENS_DISJUNCTION);
        } else {
            DoBreachAndDispel(oTarget, 0, 0, nBreach, nBreach + 1);
        }
    }
*/
