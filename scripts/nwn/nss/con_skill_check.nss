////////////////////////////////////////////////////////////////////////////////
// Vuldrick's Universal Skill Checker
// Created:  11/09/06
// Modified: 11/09/06
////////////////////////////////////////////////////////////////////////////////
// Renamed con_skill_check for script unity.
////////////////////////////////////////////////////////////////////////////////
// The following is a list of possible Skills to check for.  The Skill
// checked for is controlled with an INT set on the NPC that has this
// script being called from his/her convo.  The number representing the
// Skill is shown in the list below.
////////////////////////////////////////////////////////////////////////////////
/*
    1 = SKILL_ANIMAL_EMPATHY
    2 = SKILL_APPRAISE
    3 = SKILL_BLUFF
    4 = SKILL_CONCENTRATION
    5 = SKILL_CRAFT_ARMOR
    6 = SKILL_CRAFT_TRAP
    7 = SKILL_CRAFT_WEAPON
    8 = SKILL_DISABLE_TRAP
    9 = SKILL_DISCIPLINE
    10 = SKILL_HEAL
    11 = SKILL_HIDE
    12 = SKILL_INTIMIDATE
    13 = SKILL_LISTEN
    14 = SKILL_LORE
    15 = SKILL_MOVE_SILENTLY
    16 = SKILL_OPEN_LOCK
    17 = SKILL_PARRY
    18 = SKILL_PERFORM
    19 = SKILL_PERSUADE
    20 = SKILL_PICK_POCKET
    21 = SKILL_SEARCH
    22 = SKILL_SET_TRAP
    23 = SKILL_SPELLCRAFT
    24 = SKILL_SPOT
    25 = SKILL_TAUNT
    26 = SKILL_TUMBLE
    27 = SKILL_USE_MAGIC_DEVICE
    28 = SUBSKILL_EXAMINETRAP
    29 = SUBSKILL_FLAGTRAP
    30 = SUBSKILL_RECOVERTRAP

There are three 'generic' DCs we can check for:  DC_EASY, DC_MEDIUM, and DC_HARD

    1 = DC_EASY
    2 = DC_MEDIUM
    3 = DC_HARD
*/
#include "nw_i0_tool"
int StartingConditional(){
    // Determine the Skill being checked by looking for a local int on the NPC
    int iSkill = GetLocalInt(OBJECT_SELF,"Skill");
    // Determine the DC of the skill check by looking for a local int on the NPC
    int iDC = GetLocalInt(OBJECT_SELF,"DC");

    // Set up the skill to be checked based on the above table
    switch(iSkill){
        case 1: iSkill = SKILL_ANIMAL_EMPATHY; break;
        case 2: iSkill = SKILL_APPRAISE; break;
        case 3: iSkill = SKILL_BLUFF; break;
        case 4: iSkill = SKILL_CONCENTRATION; break;
        case 5: iSkill = SKILL_CRAFT_ARMOR; break;
        case 6: iSkill = SKILL_CRAFT_TRAP; break;
        case 7: iSkill = SKILL_CRAFT_WEAPON; break;
        case 8: iSkill = SKILL_DISABLE_TRAP; break;
        case 9: iSkill = SKILL_DISCIPLINE; break;
        case 10: iSkill = SKILL_HEAL; break;
        case 11: iSkill = SKILL_HIDE; break;
        case 12: iSkill = SKILL_INTIMIDATE; break;
        case 13: iSkill = SKILL_LISTEN; break;
        case 14: iSkill = SKILL_LORE; break;
        case 15: iSkill = SKILL_MOVE_SILENTLY; break;
        case 16: iSkill = SKILL_OPEN_LOCK; break;
        case 17: iSkill = SKILL_PARRY; break;
        case 18: iSkill = SKILL_PERFORM; break;
        case 19: iSkill = SKILL_PERSUADE; break;
        case 20: iSkill = SKILL_PICK_POCKET; break;
        case 21: iSkill = SKILL_SEARCH; break;
        case 22: iSkill = SKILL_SET_TRAP; break;
        case 23: iSkill = SKILL_SPELLCRAFT; break;
        case 24: iSkill = SKILL_SPOT; break;
        case 25: iSkill = SKILL_TAUNT; break;
        case 26: iSkill = SKILL_TUMBLE; break;
        case 27: iSkill = SKILL_USE_MAGIC_DEVICE; break;
        case 28: iSkill = SUBSKILL_EXAMINETRAP; break;
        case 29: iSkill = SUBSKILL_FLAGTRAP; break;
        case 30: iSkill = SUBSKILL_RECOVERTRAP; break;
    }

    // Set up the DC to be checked based on the above table
    switch(iDC){
        case 1: iDC = DC_EASY; break;
        case 2: iDC = DC_MEDIUM; break;
        case 3: iDC = DC_HARD; break;
        default: iDC = DC_EASY;
    }

    // Perform desired skill check
    if(!(AutoDC(iDC, iSkill, GetPCSpeaker())))
        return FALSE;

    return TRUE;
}
