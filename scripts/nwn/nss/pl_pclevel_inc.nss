// tall_inc
//
// Description: 
//
// Credits: Code originally derived from Higher Ground Legendary Leveler by FunkySwerve.  <LINK>

#include "info_inc"
#include "pc_funcs_inc"
#include "nwnx_inc"

//--------------------------------DECLARATIONS--------------------------------//

// This function checks for whether or not the PC gains a feat this level. By default it
// is set to one every three levels, carrying the progression of character feats onward from
// the last standard one received at 39, adding new feats starting at level 42 and ending at
// level 60. It is easily modified so that you can assign feats at whatever levels desired.
int GetGainsFeatOnlevelUp(int level);

// This function checks for whether or not the PC gains a stat this level. By default it
// is set to one every two levels, doubling the progression of character stats onward from
// the last standard one received at 40, adding new stats starting at level 42 and ending at
// level 60. It is easily modified so that you can assign stats at whatever levels desired.
int GetGainsStatOlevelUp(int level);

// This function tells the caller whether the PC gains +1 to saving throws this level. By default
// it is set to one every four levels, halving the progression of character saves onward from
// the last standard increase received at 40, increasing saves starting at level 44 and ending at
// level 60. It is easily modified so that you can increase saves at whatever levels desired.
int GetGainsSavesOnlevelUp(int level);

// This function is where any other requirements besides experence and level
// are added to GetHasXPForNextLL. It returns TRUE by default unless modified.
int GetCanGainLL(object pc);

// This function determines whether a skill is available to the charcter and should appear on the
// skill list, based on the character's control class, the amount of points they have remaining,
// the cost of the skill for the control class, and their current skill level in the skill.
int GetIsSkillAvailable(object pc, int skill, int class);

struct CreatureSkills GetLegendaryLevelSkills(object pc, int base = TRUE);

// This function determines whether a feat is available to the charcter and should appear on the
// feat list, based on the character's control class, whether they meet the feat's requirements,
// whether they already have the feat, and whether the feat is restricted.
int GetIsFeatAvailable(object pc, int feat, int class);
// This function determines whether a feat is available to the charcter and should appear on the
// feat list, based on the character's control class, whether they meet the feat's requirements,
// whether they already have the feat, and whether the feat is restricted.
int GetMeetsCustomFeatReq(object pc, int feat, int nControl);
// This function tells nwnx_funcs to add a stat point to the specified stat.

int GetGainsFeatOnLevelUp(int level){
    // If the players next level modulo 3 = 0, this is.. it is a multiple of
    // three, they gain a feat.
	return (level % 3) == 0;
}

int GetGainsStatOnLevelUp(int level){
    // If the players next level modulo 2 = 0, this is.. it is a multiple of
    // two, they gain a stat point.
	return (level % 2) == 0;
}

int GetGainsSavesOnLevelUp(int level){
    // If the players next level modulo 4 = 0, this is.. it is a multiple of
    // 4, they get saves.
	return (level % 4) == 0;
}

int GetCanGainLL(object pc){
    //Any quest, item, money req.s will have to be tested for here...
    return TRUE;
}

struct CreatureAbilities GetAbilities(object pc, int base = TRUE){
	struct CreatureAbilities ca;
	ca.a_str = GetAbilityScore(pc, ABILITY_STRENGTH, base); 
	ca.a_dex = GetAbilityScore(pc, ABILITY_DEXTERITY, base);
	ca.a_con = GetAbilityScore(pc, ABILITY_CONSTITUTION, base);
	ca.a_int = GetAbilityScore(pc, ABILITY_INTELLIGENCE, base);
	ca.a_wis = GetAbilityScore(pc, ABILITY_WISDOM, base);
	ca.a_cha = GetAbilityScore(pc, ABILITY_CHARISMA, base);
	
	return ca;
}

struct CreatureSkills GetSkills(object pc, int base = TRUE){
	struct CreatureSkills skills;
	skills.sk_aniemp	= GetSkillRank( SKILL_ANIMAL_EMPATHY, pc, base);
    skills.sk_conc		= GetSkillRank( SKILL_CONCENTRATION, pc, base);
    skills.sk_distrap	= GetSkillRank( SKILL_DISABLE_TRAP, pc, base);
    skills.sk_disc		= GetSkillRank( SKILL_DISCIPLINE, pc, base);
    skills.sk_heal		= GetSkillRank( SKILL_HEAL, pc, base);
    skills.sk_hide		= GetSkillRank( SKILL_HIDE, pc, base);
    skills.sk_listen	= GetSkillRank( SKILL_LISTEN, pc, base);
    skills.sk_lore		= GetSkillRank( SKILL_LORE, pc, base);
    skills.sk_movesil	= GetSkillRank( SKILL_MOVE_SILENTLY, pc, base);
    skills.sk_openlock	= GetSkillRank( SKILL_OPEN_LOCK, pc, base);
    skills.sk_parry		= GetSkillRank( SKILL_PARRY, pc, base);
    skills.sk_perform	= GetSkillRank( SKILL_PERFORM, pc, base);
    skills.sk_persuade	= GetSkillRank( SKILL_PERSUADE, pc, base);
    skills.sk_ppocket	= GetSkillRank( SKILL_PICK_POCKET, pc, base);
    skills.sk_search	= GetSkillRank( SKILL_SEARCH, pc, base);
    skills.sk_settrap	= GetSkillRank( SKILL_SET_TRAP, pc, base);
    skills.sk_spcraft	= GetSkillRank( SKILL_SPELLCRAFT, pc, base);
    skills.sk_spot		= GetSkillRank( SKILL_SPOT, pc, base);
    skills.sk_taunt		= GetSkillRank( SKILL_TAUNT, pc, base);
    skills.sk_umd		= GetSkillRank( SKILL_USE_MAGIC_DEVICE, pc, base);
    skills.sk_appraise	= GetSkillRank( SKILL_APPRAISE, pc, base);
    skills.sk_tumble	= GetSkillRank( SKILL_TUMBLE, pc, base);
    skills.sk_ctrap		= GetSkillRank( SKILL_CRAFT_TRAP, pc, base);
    skills.sk_bluff		= GetSkillRank( SKILL_BLUFF, pc, base);
    skills.sk_intim		= GetSkillRank( SKILL_INTIMIDATE, pc, base);
    skills.sk_carmor	= GetSkillRank( SKILL_CRAFT_ARMOR, pc, base);
    skills.sk_cweapon	= GetSkillRank( SKILL_CRAFT_WEAPON, pc, base);
	skills.sk_ride		= GetSkillRank( SKILL_RIDE, pc, base);

	return skills;
}

struct CreatureSkills GetLegendaryLevelSkills(object pc, int base = TRUE){
	struct CreatureSkills skills;
	skills.sk_aniemp	= GetSkillRank( SKILL_ANIMAL_EMPATHY, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_ANIMAL_EMPATHY));
    skills.sk_conc		= GetSkillRank( SKILL_CONCENTRATION, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_CONCENTRATION));
    skills.sk_distrap	= GetSkillRank( SKILL_DISABLE_TRAP, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_DISABLE_TRAP));
    skills.sk_disc		= GetSkillRank( SKILL_DISCIPLINE, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_DISCIPLINE));
    skills.sk_heal		= GetSkillRank( SKILL_HEAL, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_HEAL));
    skills.sk_hide		= GetSkillRank( SKILL_HIDE, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_HIDE));
    skills.sk_listen	= GetSkillRank( SKILL_LISTEN, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_LISTEN));
    skills.sk_lore		= GetSkillRank( SKILL_LORE, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_LORE));
    skills.sk_movesil	= GetSkillRank( SKILL_MOVE_SILENTLY, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_MOVE_SILENTLY));
    skills.sk_openlock	= GetSkillRank( SKILL_OPEN_LOCK, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_OPEN_LOCK));
    skills.sk_parry		= GetSkillRank( SKILL_PARRY, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_PARRY));
    skills.sk_perform	= GetSkillRank( SKILL_PERFORM, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_PERFORM));
    skills.sk_persuade	= GetSkillRank( SKILL_PERSUADE, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_PERSUADE));
    skills.sk_ppocket	= GetSkillRank( SKILL_PICK_POCKET, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_PICK_POCKET));
    skills.sk_search	= GetSkillRank( SKILL_SEARCH, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_SEARCH));
    skills.sk_settrap	= GetSkillRank( SKILL_SET_TRAP, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_SET_TRAP));
    skills.sk_spcraft	= GetSkillRank( SKILL_SPELLCRAFT, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_SPELLCRAFT));
    skills.sk_spot		= GetSkillRank( SKILL_SPOT, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_SPOT));
    skills.sk_taunt		= GetSkillRank( SKILL_TAUNT, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_TAUNT));
    skills.sk_umd		= GetSkillRank( SKILL_USE_MAGIC_DEVICE, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_USE_MAGIC_DEVICE));
    skills.sk_appraise	= GetSkillRank( SKILL_APPRAISE, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_APPRAISE));
    skills.sk_tumble	= GetSkillRank( SKILL_TUMBLE, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_TUMBLE));
    skills.sk_ctrap		= GetSkillRank( SKILL_CRAFT_TRAP, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_CRAFT_TRAP));
    skills.sk_bluff		= GetSkillRank( SKILL_BLUFF, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_BLUFF));
    skills.sk_intim		= GetSkillRank( SKILL_INTIMIDATE, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_INTIMIDATE));
    skills.sk_carmor	= GetSkillRank( SKILL_CRAFT_ARMOR, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_CRAFT_ARMOR));
    skills.sk_cweapon	= GetSkillRank( SKILL_CRAFT_WEAPON, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_CRAFT_WEAPON));
	skills.sk_ride		= GetSkillRank( SKILL_RIDE, pc, base) + GetLocalInt(pc, "LL_SKILL_"+IntToString(SKILL_RIDE));

	return skills;
}

int GetIsSkillAvailable(object pc, int skill, int class){
    int cost, max, rank;
    int class_skill = GetIsClassSkill(class, skill);

    if(class_skill == -1) return FALSE;

    if (class_skill){
        cost = 1;
        max = GetLocalInt(pc, "LL_LEVEL") + 4;
    }
    else{
        cost = 2;
        max = (GetLocalInt(pc, "LL_LEVEL") + 4) / 2;
    }
	
	rank = GetSkillRank(skill, pc, TRUE) + GetLocalInt(pc, "LL_SKILL_"+IntToString(skill));

    return (GetLocalInt(pc, "LL_SKILL_POINTS") >= cost && rank < max);
}

int GetMeetsCustomFeatReq(object pc, int feat, int class){
    // Auto Still Spell
    if(class == CLASS_TYPE_BARD){
       if (feat ==  FEAT_EPIC_AUTOMATIC_STILL_SPELL_3 ||
           feat ==  FEAT_EPIC_AUTOMATIC_STILL_SPELL_2 ||
           feat ==  FEAT_EPIC_AUTOMATIC_STILL_SPELL_1)
       {
            if(GetAbilityScore(pc, ABILITY_CHARISMA, TRUE) > 10 && GetLevelByClass(CLASS_TYPE_BARD, pc) >= 17
               && GetHasFeat(FEAT_STILL_SPELL, pc) && GetSkillRank(SKILL_SPELLCRAFT, pc, TRUE) >= 27)
            {
                if(feat == FEAT_EPIC_AUTOMATIC_STILL_SPELL_3
                    && GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_2, pc))
                {   // Auto Still 3
                    return TRUE;
                }
                else if(feat ==  FEAT_EPIC_AUTOMATIC_STILL_SPELL_2
                    && GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_1, pc))
                {   // Auto Still 2
                    return TRUE;
                }
                else if(feat ==  FEAT_EPIC_AUTOMATIC_STILL_SPELL_1)
                {   // Auto Still 1
                    return TRUE;
                }
            }
        }
        else if(feat == FEAT_EPIC_SPELL_FOCUS_ABJURATION    && GetKnowsFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, pc))
            return TRUE;
        else if(feat == FEAT_EPIC_SPELL_FOCUS_CONJURATION   && GetKnowsFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, pc))
            return TRUE;
        else if(feat == FEAT_EPIC_SPELL_FOCUS_DIVINATION    && GetKnowsFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION, pc))
            return TRUE;
        else if(feat == FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT   && GetKnowsFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, pc))
            return TRUE;
        else if(feat == FEAT_EPIC_SPELL_FOCUS_EVOCATION     && GetKnowsFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, pc))
            return TRUE;
        else if(feat == FEAT_EPIC_SPELL_FOCUS_ILLUSION      && GetKnowsFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, pc))
            return TRUE;
        else if(feat == FEAT_EPIC_SPELL_FOCUS_NECROMANCY    && GetKnowsFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, pc))
            return TRUE;
        else if(feat == FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION && GetKnowsFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, pc))
            return TRUE;
    }

    return FALSE;
}

int GetIsFeatAvailable(object pc, int feat, int class){
    int stat = GetGainsStatOnLevelUp(GetLocalInt(pc, "LL_LEVEL")) ? GetLocalInt(pc, "LL_STAT") : -1;
    struct CreatureSkills sk = GetLegendaryLevelSkills(pc);
	int class_pos = GetLocalInt(pc, "LL_CLASS_POSITION");
	int class_lvl = GetLocalInt(pc, "LL_CLASSLEVEL_"+IntToString(class_pos));

    if(GetFeatIsFirstLevelOnly(feat)) return FALSE;
    if (GetKnowsFeat(feat, pc) && feat != 13) return FALSE;//only Extra Turning (13) may be taken multiple times

    // Custom Feat Requirements:
    if(GetMeetsCustomFeatReq(pc, feat, class))
        return TRUE;

	if(GetIsClassGrantedFeat(class, feat) == class_lvl){
        SetLocalInt(pc, "LL_FEAT_"+IntToString(GetLocalInt(pc, "LL_FEAT_COUNT")), feat+1 );
        IncrementLocalInt(pc, "LL_FEAT_COUNT");
		return FALSE;
	}

    if (!GetIsClassGeneralFeat(class, feat) && !GetIsClassBonusFeat(class, feat))
        return FALSE; //if it's not a class skill and it's not a general skill return FALSE
    
	if (GetMeetsLevelUpFeatRequirements (pc, feat, class, stat, sk))
        return TRUE;

    return FALSE;
}

void LegendaryLevelCleanup(){
}

void LegendaryLevelComplete(object pc){
    LevelUp(pc);
    ExecuteScript("pl_levelup", pc);
}

void LoadPCSkills(object pc, int base = TRUE, string prefix="SKILL_"){
    int i;
    for(i = 0; i < 28; i++){
        SetLocalInt(pc, prefix + IntToString(i), GetSkillRank(i , pc, base));
    }
}

void LegendaryLevelLoad(object pc){
	
	int class1, class2, class3, level1, level2, level3, new_level;

	class1 = GetClassByPosition(1, pc) + 1;

	class2 = GetClassByPosition(2, pc);
	if(class2 == CLASS_TYPE_INVALID)
		class2 = 0;
	else
		class2++;

	class3 = GetClassByPosition(3, pc);
	if(class3 == CLASS_TYPE_INVALID)
		class3 = 0;
	else
		class3++;

    level1 = GetLevelByClass(class1 - 1, pc);
    if(class2 > 0){
        level2 = GetLevelByClass(class2 - 1, pc);
    }
    if(class3 > 0){
        level3 = GetLevelByClass(class3 - 1, pc);
    }

	new_level = level1 + level2 + level3 + 1;

    SetLocalInt(pc, "LL_CLASS_1", class1); 
    SetLocalInt(pc, "LL_CLASSLEVEL_1", level1);
    SetLocalInt(pc, "LL_CLASS_2", class2); 
    SetLocalInt(pc, "LL_CLASSLEVEL_2", level2);
   	SetLocalInt(pc, "LL_CLASS_3", class3); 
    SetLocalInt(pc, "LL_CLASSLEVEL_3", level3);
    SetLocalInt(pc, "LL_LEVEL", new_level);

}
