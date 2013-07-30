/*
Requirements.
1. Present at the death of the Remnants of Khald'eran.
2. 25 Levels of Rogue, 20 levels of Shadowdancer, or 10 levels of Assasin.
3. 30 base Dexterity

Unique Power: If the above requirements are met,  twice per day the user of this item can cast a Sanctuary effect on themselves.

DC: 10 + Hide Skill / 2 (Max 70).  Duration: Hide Skill / 3 in Seconds (Max: 40 Seconds).
Cooldown: 90 Seconds.
*/
#include "pc_funcs_inc"
#include "x2_inc_switches"

void main(){
    object oPC = GetItemActivator();
    object oItem;
    int nEvent = GetUserDefinedItemEventNumber();
    int nDC = 10 + GetSkillRank(SKILL_HIDE, oPC) / 2;
    if(nDC > 70)
        nDC = 70;
    int nDuration = GetSkillRank(SKILL_HIDE, oPC) / 3;
    if(nDuration > 40)
        nDuration = 40;
    int nCooldown = 90 + nDuration;

    if(nEvent == X2_ITEM_EVENT_ACTIVATE){
        oItem = GetItemActivated();
        if(GetLevelByClassIncludingLL(CLASS_TYPE_ROGUE, oPC) < 25 &&
           GetLevelByClassIncludingLL(CLASS_TYPE_SHADOWDANCER, oPC) < 20 &&
           GetLevelByClassIncludingLL(CLASS_TYPE_ASSASSIN, oPC) < 10){

           ErrorMessage(oPC, "You must have 25 Levels of Rogue, 20 levels of Shadowdancer, or 10 levels of Assasin.  To use this item");
           return;
        }
        else if(GetLocalTimer(GetTag(oItem), oPC)){
            ErrorMessage(oPC, "You are unable to use this item yet!");
            return;
        }

        effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_INVISIBILITY));
        eLink = EffectLinkEffects(eLink, EffectSanctuary(nDC));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, IntToFloat(nDuration));

        SetLocalTimer(GetTag(oItem), IntToFloat(nCooldown), oPC);
    }
}
