#include "x2_inc_switches"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    if(nEvent != X2_ITEM_EVENT_ACTIVATE)
        return;

    object oPC = GetItemActivator();        // The player who activated the item


    if(GetHasFeat(FEAT_DIVINE_MIGHT, oPC) && !GetHasSpellEffect(SPELL_DIVINE_MIGHT,oPC)){
        AssignCommand(oPC, ActionCastSpellAtObject(SPELL_DIVINE_MIGHT, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        //DecrementRemainingFeatUses(oPC, SPELL_DIVINE_MIGHT);
    }

    if(GetHasFeat(FEAT_DIVINE_SHIELD, oPC) && !GetHasSpellEffect(SPELL_DIVINE_SHIELD,oPC)){
        AssignCommand(oPC, ActionCastSpellAtObject(SPELL_DIVINE_SHIELD, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        //DecrementRemainingFeatUses(oPC, SPELL_DIVINE_MIGHT);
    }
/*
    if(GetHasFeat(FEAT_DIVINE_MIGHT, oPC) && !GetHasSpellEffect(SPELL_DIVINE_MIGHT,oPC)){
        AssignCommand(oPC, ActionUseFeat(FEAT_DIVINE_MIGHT, oPC));
        DecrementRemainingFeatUses(oPC, FEAT_DIVINE_MIGHT);
    }
    if(GetHasFeat(FEAT_DIVINE_SHIELD, oPC) && !GetHasSpellEffect(SPELL_DIVINE_SHIELD,oPC)){
        AssignCommand(oPC, ActionUseFeat(FEAT_DIVINE_SHIELD, oPC));
        DecrementRemainingFeatUses(oPC, FEAT_DIVINE_SHIELD);
    }
    if(GetHasFeat(FEAT_DIVINE_WRATH, oPC) && !GetHasSpellEffect(SPELLABILITY_DC_DIVINE_WRATH,oPC)){
        AssignCommand(oPC, ActionUseFeat(FEAT_DIVINE_WRATH, oPC));
        DecrementRemainingFeatUses(oPC, FEAT_DIVINE_WRATH);
    }
*/
}
