effect eEffect;
location lTarget;
object oTarget;

//Created by Guile 3/12/07
//Put this on action taken in the conversation editor
#include "nw_i0_tool"
#include "pc_funcs_inc"


void main(){

    object oPC = GetPCSpeaker();
    effect eEffect;
    if (GetGold(oPC) < 1000000)
        return;

    TakeGoldFromCreature(1000000, oPC, TRUE);

    switch(Random(16)+1){
        case 1: // Port
        break;
        case 2:
            GiveTakeXP(oPC, 1000);
            FloatingTextStringOnCreature("You have gained much knowlege about your abilities.", oPC, FALSE);
        break;
        case 3:
            GiveTakeGold( oPC, 50000);
            FloatingTextStringOnCreature("You pockets are overloaded with Gold!", oPC);
        break;
        case 4: // Item
        break;
        case 5:
            eEffect = EffectConcealment(70);
            eEffect = EffectLinkEffects(eEffect, EffectSpellResistanceIncrease(50));
            eEffect = EffectLinkEffects(eEffect, EffectAttackIncrease(10));
            eEffect = EffectLinkEffects(eEffect, EffectACIncrease(10));
            eEffect = SupernaturalEffect(eEffect);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, TurnsToSeconds(10));
            FloatingTextStringOnCreature("You are temporarially empowered with Godly Powers!", oPC, FALSE);
        break;
        case 6:
           AssignCommand(oPC, TakeGoldFromCreature(GetGold(oPC), oPC, TRUE));
           FloatingTextStringOnCreature("All of your gold has been turned to lead!", oPC, FALSE);
        break;
        case 7: //item
        break;
        case 8:
            eEffect = EffectCurse(6, 6, 6, 6, 6, 6);
            eEffect = EffectLinkEffects(eEffect, EffectDeaf());
            eEffect = EffectLinkEffects(eEffect, EffectSlow());
            eEffect = EffectLinkEffects(eEffect, EffectSavingThrowDecrease(SAVING_THROW_ALL, 12, SAVING_THROW_TYPE_ALL));
            eEffect = SupernaturalEffect(eEffect);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget);
            FloatingTextStringOnCreature("You have been bestowed with a vile curse!", oPC, FALSE);
        break;
        case 9:
            GiveTakeXP(oPC, -3000);
            FloatingTextStringOnCreature("You have lost a lot of memories and experiences!", oPC, FALSE);
        break;
        case 10:// Item
        break;
        case 11:
            GiveTakeXP(oPC, 2000);
            FloatingTextStringOnCreature("You have gained vast knowled you never knew you had!", oPC, FALSE);
        break;
        case 12:
            eEffect = EffectDeath();
            eEffect = SupernaturalEffect(eEffect);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
            FloatingTextStringOnCreature("Your heart has stopped beating!", oPC, FALSE);
        break;
        case 13:
            GiveTakeGold(oPC, 200000);
            FloatingTextStringOnCreature("Your pockets are overflowing with gold!", oPC, FALSE);
        break;
        case 14:
            eEffect = EffectDeath();
            eEffect = SupernaturalEffect(eEffect);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
            ActionCastSpellAtObject(SPELL_IMPLOSION, oPC, METAMAGIC_ANY, TRUE, 36, PROJECTILE_PATH_TYPE_DEFAULT, FALSE);
            FloatingTextStringOnCreature("Someone or Something has cast an evil spell at you!", oPC, FALSE);
        break;
        case 15: //Port
        break;
        case 16:
           GiveTakeXP(oPC, 2000);
           GiveTakeGold(oPC, 2000000);
           FloatingTextStringOnCreature("It seems fortune has finally found you!", oPC, FALSE);
        break;
    }
}
