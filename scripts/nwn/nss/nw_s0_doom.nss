//::///////////////////////////////////////////////
//:: Doom
//:: NW_S0_Doom.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If the target fails a save they recieve a -2
    penalty to all saves, attack rolls, damage and
    skill checks for the duration of the spell.

    July 22 2002 (BK): Made it mind affecting.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////


#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
    effect eLink = CreateDoomEffectsLink();

    float fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);

    GSPApplyEffectsToObject(si, TARGET_TYPE_STANDARD, eLink, eVis, SAVING_THROW_WILL,
                            SAVING_THROW_TYPE_MIND_SPELLS, fDuration, TRUE);
/*
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOOM));
        //Spell Resistance and Saving throw

        //* GZ Engine fix for mind affecting spell

        int nResult =       WillSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS);
        if (nResult == 2)
        {
            if (GetIsPC(OBJECT_SELF)) // only display immune feedback for PCs
            {
                FloatingTextStrRefOnCreature(84525, oTarget,FALSE); // * Target Immune
            }
            return;
        }

        nResult = (nResult || MyResistSpell(OBJECT_SELF, oTarget));
        if (!nResult)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, TurnsToSeconds(nLevel));
        }
    }
*/
}

