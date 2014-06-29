#include "mod_funcs_inc"

// This function returns the name of the designated ability score.
string GetAbilityName(int nStat, int nBrief = FALSE);

int GetAbilityBaseModifier(int ability, object pc = OBJECT_SELF);

// This function returns the name of the designated feat.
string GetFeatName(int nFeat);

// TRUE if feat is able to be taken only on the first level.
int GetFeatIsFirstLevelOnly(int feat);

string GetClassName(int nClass);

// This function determines the amount of HP that a character gets on levelup based on their
// control class, their CON modifier, and whether or not they've taken the toughness feat.
int GetHitPointsGainedOnLevelUp(int class);

int GetSkillCost(int class, int skill);

string GetSkillName(int nSkill, int nBrief = FALSE);
// This function determines and returns the amount of skill points a character will get each
// LL based on their control class, INT modifier, and their main race (humans get +1)
int GetSkillPointsGainedOlevelUp(object pc, int class);

// GetInnateSpellLevel
//  nSpell - a SPELL_* constant.
// returns -1 on spell not found, uses innate columns.
int GetInnateSpellLevel(int nSpell);

int GetInnateSpellLevelByClass(int nSpell, int nClass);

// GetSpellName
//  nSpell - a SPELL_* constant.
// returns the spell name, with underscores substituted for spaces.
string GetSpellName(int nSpell);

// GetIsSpellHarmful
//  nSpell - a SPELL_* constant.
// returns TRUE if this spell is hostile.
int GetIsSpellHarmful(int nSpell);

// GetSpellSchool
//  nSpell - a SPELL_* constant.
// returns the spell school constant. SPELL_SCHOOL_*
int GetSpellSchool(int nSpell);

// GetSpellSchoolName
//  nSpellSchool - a SPELL_SCHOOL_* constant
// returns the name of the constants specified
string GetSpellSchoolName(int nSpellSchool);

string GetMetaMagicName(int nMeta);

//////////////////////////////////////////////////////////////////////////////

int GetAbilityBaseModifier(int ability, object pc = OBJECT_SELF){
	return (GetAbilityScore(pc, ability, TRUE) - 10) / 2;
}

string GetAbilityName(int nStat, int nBrief = FALSE)
{
    string sReturn;
    switch (nStat)
    {
        case ABILITY_STRENGTH: sReturn = "Strength"; break;
        case ABILITY_DEXTERITY: sReturn = "Dexterity"; break;
        case ABILITY_CONSTITUTION: sReturn = "Constitution"; break;
        case ABILITY_INTELLIGENCE: sReturn = "Intelligence"; break;
        case ABILITY_WISDOM: sReturn = "Wisdom"; break;
        case ABILITY_CHARISMA: sReturn = "Charisma"; break;
    }
    return sReturn;
}

int GetSkillCost(int class, int skill){
	int res = GetIsClassSkill(class, skill);
	
	if(!res) 
		return 2;
	
	return res;
}

///////////////////////////////////////////////////////////////////////////////
// FUNCTION PROTOTYPES - Spells
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////

int GetSaveType(int nDamType);

///////////////////////////////////////////////////////////////////////////////
// FUNCTION DEFINITIONS - Spells
///////////////////////////////////////////////////////////////////////////////
int GetSaveType(int nDamType){
    int nSaveType = SAVING_THROW_TYPE_NONE;

    switch (nDamType) {
        case DAMAGE_TYPE_ACID:       nSaveType = SAVING_THROW_TYPE_ACID;        break;
        case DAMAGE_TYPE_COLD:       nSaveType = SAVING_THROW_TYPE_COLD;        break;
        case DAMAGE_TYPE_ELECTRICAL: nSaveType = SAVING_THROW_TYPE_ELECTRICITY; break;
        case DAMAGE_TYPE_FIRE:       nSaveType = SAVING_THROW_TYPE_FIRE;        break;
        case DAMAGE_TYPE_SONIC:      nSaveType = SAVING_THROW_TYPE_SONIC;       break;
        case DAMAGE_TYPE_DIVINE:     nSaveType = SAVING_THROW_TYPE_DIVINE;      break;
        case DAMAGE_TYPE_MAGICAL:    nSaveType = SAVING_THROW_TYPE_SPELL;       break;
        case DAMAGE_TYPE_NEGATIVE:   nSaveType = SAVING_THROW_TYPE_NEGATIVE;    break;
        case DAMAGE_TYPE_POSITIVE:   nSaveType = SAVING_THROW_TYPE_POSITIVE;    break;
    }
    return nSaveType;
}

int GetInnateSpellLevel(int nSpell){
    int nInnate = GetHashInt(GetModule(), VAR_HASH_SPELL_INFO, IntToString(nSpell));
    return (nInnate / 10) % 10;
}

int GetInnateSpellLevelByClass(int nSpell, int nClass){
    string sClass;
    switch(nClass){
        case CLASS_TYPE_BARD: sClass = "Bard"; break;
        case CLASS_TYPE_SORCERER: sClass = "Wiz_Sorc"; break;
    }
    if(sClass != "") return StringToInt(Get2DAString("spells", sClass, nSpell));
    else return -1;
}

string GetSpellName(int nSpell){
    int nStrRef = GetHashInt(GetModule(), VAR_HASH_SPELL_NAME, IntToString(nSpell));

    if(nStrRef >= 0) return GetStringByStrRef(nStrRef);

    return "";
}

int GetIsSpellHarmful(int nSpell){
    int nHarmful = GetHashInt(GetModule(), VAR_HASH_SPELL_INFO, IntToString(nSpell));
    return nHarmful % 10;
}

int GetSpellSchool(int nSpell){
    int nSchool = GetHashInt(GetModule(), VAR_HASH_SPELL_INFO, IntToString(nSpell));
    return (nSchool / 100) % 10;
}

string GetSpellSchoolName(int sp_school){
	switch(sp_school){
    	case SPELL_SCHOOL_ABJURATION:		return "Abjuration";
    	case SPELL_SCHOOL_CONJURATION: 		return "Conjuration";
    	case SPELL_SCHOOL_DIVINATION: 		return "Divination";
    	case SPELL_SCHOOL_ENCHANTMENT: 		return "Enchantment";
    	case SPELL_SCHOOL_EVOCATION: 		return "Evocation";
    	case SPELL_SCHOOL_GENERAL: 			return "General";
    	case SPELL_SCHOOL_ILLUSION:	 		return "Illusion";
    	case SPELL_SCHOOL_NECROMANCY: 		return "Necromancy";
    	case SPELL_SCHOOL_TRANSMUTATION:	return "Transmutation";
	}
    return "";
}

///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
// FUNCTION DEFINITIONS - Feats
///////////////////////////////////////////////////////////////////////////////

int GetFeatIsFirstLevelOnly(int feat){
    switch(feat)
    {
        case 378: return TRUE; break;
        case 379: return TRUE; break;
        case 380: return TRUE; break;
        case 381: return TRUE; break;
        case 382: return TRUE; break;
        case 384: return TRUE; break;
        case 386: return TRUE; break;
        case 388: return TRUE; break;
    }

    return FALSE;
}

string GetFeatName(int nFeat){
    return GetHashString(GetModule(), VAR_HASH_FEAT_NAME, IntToString(nFeat));
}

///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// FUNCTION DEFINITIONS - Abilities
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// FUNCTION DEFINITIONS - Skill
///////////////////////////////////////////////////////////////////////////////
string GetSkillName(int nSkill, int nBrief = FALSE){
    string sSkill;

    switch (nSkill){
        case 0:  sSkill = "Animal Empathy"; break;
        case 1:  sSkill = "Concentration"; break;
        case 2:  sSkill = "Disable Trap"; break;
        case 3:  sSkill = "Discipline"; break;
        case 4:  sSkill = "Heal"; break;
        case 5:  sSkill = "Hide"; break;
        case 6:  sSkill = "Listen"; break;
        case 7:  sSkill = "Lore"; break;
        case 8:  sSkill = "Move Silently"; break;
        case 9:  sSkill = "Open Lock"; break;
        case 10: sSkill = "Parry"; break;
        case 11: sSkill = "Perform"; break;
        case 12: sSkill = "Persuade"; break;
        case 13: sSkill = "Pick Pocket"; break;
        case 14: sSkill = "Search"; break;
        case 15: sSkill = "Set Trap"; break;
        case 16: sSkill = "Spellcraft"; break;
        case 17: sSkill = "Spot"; break;
        case 18: sSkill = "Taunt"; break;
        case 19: sSkill = "Use Magic Device"; break;
        case 20: sSkill = "Appraise"; break;
        case 21: sSkill = "Tumble"; break;
        case 22: sSkill = "Craft Trap"; break;
        case 23: sSkill = "Bluff"; break;
        case 24: sSkill = "Intimidate"; break;
        case 25: sSkill = "Craft Armor"; break;
        case 26: sSkill = "Craft Weapon"; break;
        default: sSkill = ""; break;
    }
    return sSkill;
}
// ****************************************************************************
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
// FUNCTION DEFINITIONS - Class
///////////////////////////////////////////////////////////////////////////////
string GetClassName(int nClass){

    string sClass;

    switch (nClass){
        case 0: sClass = "Barbarian"; break;
        case 1: sClass = "Bard"; break;
        case 2: sClass = "Cleric"; break;
        case 3: sClass = "Druid"; break;
        case 4: sClass = "Fighter"; break;
        case 5: sClass = "Monk"; break;
        case 6: sClass = "Paladin"; break;
        case 7: sClass = "Ranger"; break;
        case 8: sClass = "Rogue"; break;
        case 9: sClass = "Sorcerer"; break;
        case 10: sClass = "Wizard"; break;
        case 27: sClass = "Shadowdancer"; break;
        case 28: sClass = "Master Harper"; break;
        case 29: sClass = "Arcane Archer"; break;
        case 30: sClass = "Assassin"; break;
        case 31: sClass = "Blackguard"; break;
        case 32: sClass = "Divine Champion"; break;
        case 33: sClass = "Weapon Master"; break;
        case 34: sClass = "Pale Master"; break;
        case 35: sClass = "Shifter"; break;
        case 36: sClass = "Dwarven Defender"; break;
        case 37: sClass = "Dragon Disciple"; break;
        case 41: sClass = "Purple Dragon Knight"; break;
        case CLASS_TYPE_BARD_GROUP: return "Bard and/or Harper Scout";
        case CLASS_TYPE_DRUID_GROUP: return "Druid and/or Shifter";
        case CLASS_TYPE_FIGHTER_GROUP:
            return "Fighter, Champion of Torm, Weapon Master, Dwarven Defender, " +
                   "Puprple Dragon Knight, Red Dragon Disciple, and/or Blackguard";
        case CLASS_TYPE_MAGE_GROUP: return "Wizard, Pale Master, and/or Sorcerer";
        case CLASS_TYPE_ROGUE_GROUP: return "Rogue, Assassin, and/or Shadowdancer";
        default: sClass = ""; break;
    }
    return sClass;
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// FUNCTION DEFINITIONS - Damages
///////////////////////////////////////////////////////////////////////////////
string GetDamageTypeName(int nDamType){
     switch (nDamType) {
        case DAMAGE_TYPE_ACID:       return "Acid";
        case DAMAGE_TYPE_COLD:       return "Cold";
        case DAMAGE_TYPE_ELECTRICAL: return "Electrical";
        case DAMAGE_TYPE_FIRE:       return "Fire";
        case DAMAGE_TYPE_SONIC:      return "Sonic";
        case DAMAGE_TYPE_DIVINE:     return "Divine";
        case DAMAGE_TYPE_MAGICAL:    return "Magical";
        case DAMAGE_TYPE_NEGATIVE:   return "Negative";
        case DAMAGE_TYPE_POSITIVE:   return "Positive";
        case DAMAGE_TYPE_BLUDGEONING:   return "Bludgeoning";
        case DAMAGE_TYPE_PIERCING:   return "Piercing";
        case DAMAGE_TYPE_SLASHING:   return "Slashing";
    }
    return "";
}
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// FUNCTION DEFINITIONS - Saves
///////////////////////////////////////////////////////////////////////////////
string GetSaveName(int nSave, int bDunno){
    switch (nSave) {
        case SAVING_THROW_ALL:    return "All";
        case SAVING_THROW_FORT:   return "Fortitude";
        case SAVING_THROW_REFLEX: return "Reflex";
        case SAVING_THROW_WILL:   return "Will";
    }
    return "";
}

string GetSaveTypeName(int nSaveType, int bDunno){
    switch (nSaveType) {
        case SAVING_THROW_TYPE_ACID:        return "Acid";
        case SAVING_THROW_TYPE_ALL:         return "All";
        case SAVING_THROW_TYPE_CHAOS:       return "Chaos";
        case SAVING_THROW_TYPE_COLD:        return "Cold";
        case SAVING_THROW_TYPE_DEATH:       return "Death";
        case SAVING_THROW_TYPE_DISEASE:     return "Disease";
        case SAVING_THROW_TYPE_DIVINE:      return "Divine";
        case SAVING_THROW_TYPE_ELECTRICITY: return "Electrical";
        case SAVING_THROW_TYPE_EVIL:        return "Evil";
        case SAVING_THROW_TYPE_FEAR:        return "Fear";
        case SAVING_THROW_TYPE_FIRE:        return "Fire";
        case SAVING_THROW_TYPE_GOOD:        return "Good";
        case SAVING_THROW_TYPE_LAW:         return "Law";
        case SAVING_THROW_TYPE_MIND_SPELLS: return "Mind-Affecting";
        case SAVING_THROW_TYPE_NEGATIVE:    return "Negative";
        case SAVING_THROW_TYPE_POISON:      return "Poison";
        case SAVING_THROW_TYPE_POSITIVE:    return "Positive";
        case SAVING_THROW_TYPE_SONIC:       return "Sonic";
        case SAVING_THROW_TYPE_SPELL:       return "Spell";
        case SAVING_THROW_TYPE_TRAP:        return "Trap";
    }
    return "";
}

string GetMetaMagicName(int nMeta){
    switch(nMeta){
        case METAMAGIC_EMPOWER: return "Empowered";
        case METAMAGIC_EXTEND: return "Extended";
        case METAMAGIC_MAXIMIZE: return "Maximized";
        case METAMAGIC_QUICKEN: return "Quickened";
        case METAMAGIC_SILENT: return "Silenced";
        case METAMAGIC_STILL: return "Stilled";
    }
    return "";
}

int GetArmorPenalty(object pc)
{
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, pc);
    if (!GetIsObjectValid(oItem)) return 0;
    if (GetBaseItemType(oItem) != BASE_ITEM_ARMOR) return 0;
    SetIdentified(oItem,FALSE);
    int nPenalty = 0;
    switch (GetGoldPieceValue(oItem))
    {
        case    1: nPenalty = 0; break;
        case    5: nPenalty = 0; break;
        case   10: nPenalty = 0; break;
        case   15: nPenalty = 1; break;
        case  100: nPenalty = 2; break;
        case  150: nPenalty = 5; break;
        case  200: nPenalty = 7; break;
        case  600: nPenalty = 7; break;
        case 1500: nPenalty = 8; break;
    }
    SetIdentified(oItem,TRUE);
    return nPenalty;
}

int GetShieldPenalty(object pc)
{
    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, pc);
    if (!GetIsObjectValid(oItem)) return 0;
    int nType = GetBaseItemType(oItem);
    int nPenalty = 0;
    switch(nType)
    {
        case BASE_ITEM_SMALLSHIELD: nPenalty = 1; break;
        case BASE_ITEM_LARGESHIELD: nPenalty = 2; break;
        case BASE_ITEM_TOWERSHIELD: nPenalty = 10; break;
        default: nPenalty = 0; break;
    }
    return nPenalty;
}


int GetSkillPointsGainedOnLevelUp(object pc, int class)
{
    int nTotal = (GetRacialType(pc) == RACIAL_TYPE_HUMAN) ? 1 : 0;
	nTotal += GetAbilityBaseModifier(ABILITY_INTELLIGENCE, pc);

    switch(class){
        case CLASS_TYPE_ROGUE:
        	nTotal += 8; break;
        case CLASS_TYPE_SHADOWDANCER:
    	    nTotal += 6; break;
        case CLASS_TYPE_ARCANE_ARCHER:
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_BARBARIAN:
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_HARPER:
        case CLASS_TYPE_MONK:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_SHIFTER:
	        nTotal += 4; break;
        case CLASS_TYPE_BLACKGUARD:
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_FIGHTER:
        case CLASS_TYPE_DIVINECHAMPION:
        case CLASS_TYPE_DRAGONDISCIPLE:
        case CLASS_TYPE_DWARVENDEFENDER:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_PALEMASTER:
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_WEAPON_MASTER:
        case CLASS_TYPE_WIZARD:
	        nTotal += 2; break;
    }

    return (nTotal > 0) ? nTotal : 1;
}

int GetHitPointsGainedOnLevelUp(int class)
{
    int classDie;

    switch(class)
    {
        case CLASS_TYPE_DWARVENDEFENDER:
        case CLASS_TYPE_BARBARIAN:
        case CLASS_TYPE_DRAGONDISCIPLE:
            classDie = 12; break;
        case CLASS_TYPE_DIVINECHAMPION:
        case CLASS_TYPE_WEAPON_MASTER:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_BLACKGUARD:
        case CLASS_TYPE_FIGHTER:
            classDie = 10; break;
        case CLASS_TYPE_SHADOWDANCER:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_ARCANE_ARCHER:
        case CLASS_TYPE_MONK:
        case CLASS_TYPE_SHIFTER:
        case CLASS_TYPE_CLERIC:
            classDie = 8; break;
        case CLASS_TYPE_ROGUE:
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_HARPER:
        case CLASS_TYPE_PALEMASTER:
            classDie = 6; break;
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_WIZARD:
            classDie = 4; break;
    }
    return classDie;
}
int GetDefaultAppearance(int nRace){
    switch(nRace){
        case RACIAL_TYPE_DWARF:    return 0;
        case RACIAL_TYPE_ELF:      return 1;
        case RACIAL_TYPE_GNOME:    return 2;
        case RACIAL_TYPE_HALFELF:  return 4;
        case RACIAL_TYPE_HALFLING: return 3;
        case RACIAL_TYPE_HALFORC:  return 5;
        case RACIAL_TYPE_HUMAN:    return 6;
    }

    return 0;
}

