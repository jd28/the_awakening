#include "pc_funcs_inc"
#include "pl_pcstyle_inc"

void main(){

    object oPC = OBJECT_SELF;
    int class = GetClassByLevel(oPC, GetHitDice(oPC));
    int level = GetLevelByClass(class, oPC);
    int nFeat;

    if(class == CLASS_TYPE_RANGER){
       //AddKnownFeat (oPC, FEAT_HIDE_IN_PLAIN_SIGHT, GetHitDice(oPC));
    }
    else
    if(class == CLASS_TYPE_FIGHTER){
       //&& GetLevelByClass(CLASS_TYPE_FIGHTER, oPC) == 35){
       //AddKnownFeat (oPC, FEAT_EPIC_DODGE, GetHitDice(oPC));
        if(level >= 45 && !GetFightingStyle(oPC)
                && GetItemPossessedBy(oPC, "pl_style_fighter") == OBJECT_INVALID
                && GetSubRace(oPC) != "Paragon"){
            CreateItemOnObject("pl_style_fighter", oPC);
            SendMessageToPC(oPC, "You are able to select Fighting Style. MORE");
        }
    }
    else
    if(class == CLASS_TYPE_DRAGON_DISCIPLE){
        if(level == 15){
            object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
            IPSafeAddItemProperty(oSkin, ItemPropertyTrueSeeing());
        }
        else if(level == 20 || level == 35){
            ModifyAbilityScore(oPC, ABILITY_STRENGTH, 2);
            ModifyAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
            ModifyAbilityScore(oPC, ABILITY_CHARISMA, 2);
        }
        else if(level >= 45 && !GetDragonDiscipleStyle(oPC) &&
                GetItemPossessedBy(oPC, "pl_style_dragon") == OBJECT_INVALID){
            CreateItemOnObject("pl_style_dragon", oPC);
            SendMessageToPC(oPC, "You are able to select your Dragon Disciple color. MORE");
        }
    }
    else
    if (class == CLASS_TYPE_DRUID){
        int nFeat;
        if(level == 40){
            nFeat = GetNextUnknownFeat(FEAT_EPIC_ENERGY_RESISTANCE_COLD_1, oPC);
            if(nFeat >= 0)
                AddKnownFeat (oPC, nFeat, GetHitDice(oPC));
        }
        else if(level == 42){
            nFeat = GetNextUnknownFeat(FEAT_EPIC_ENERGY_RESISTANCE_FIRE_1, oPC);
            if(nFeat >= 0)
                AddKnownFeat (oPC, nFeat, GetHitDice(oPC));
        }
        else if(level == 44){
            nFeat = GetNextUnknownFeat(FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_1, oPC);
            if(nFeat >= 0)
                AddKnownFeat (oPC, nFeat, GetHitDice(oPC));
        }
        else if(level == 46){
            nFeat = GetNextUnknownFeat(FEAT_EPIC_ENERGY_RESISTANCE_ACID_1, oPC);
            if(nFeat >= 0)
                AddKnownFeat (oPC, nFeat, GetHitDice(oPC));
        }
        else if(level == 48){
            nFeat = GetNextUnknownFeat(FEAT_EPIC_ENERGY_RESISTANCE_SONIC_1, oPC);
            if(nFeat >= 0)
                AddKnownFeat (oPC, nFeat, GetHitDice(oPC));
        }
    }
    else
    if (class == CLASS_TYPE_BLACKGUARD){
        if(level == 25 || level == 45){
            nFeat = GetNextUnknownFeat(FEAT_EPIC_GREAT_SMITING_1, oPC);
            if(nFeat >= 0)
                AddKnownFeat (oPC, nFeat, GetHitDice(oPC));
        }
    }
    else
    if (class == CLASS_TYPE_DIVINECHAMPION){
        int nFeat;
        if(level == 15 || level == 25 || level == 45){
            nFeat = GetNextUnknownFeat(FEAT_EPIC_GREAT_SMITING_1, oPC);
            if(nFeat >= 0)
                AddKnownFeat (oPC, nFeat, GetHitDice(oPC));
        }
    }
    else
    if (class == CLASS_TYPE_PALADIN){
        int nFeat;
        if(level == 40 || level == 50 || level == 55){
            nFeat = GetNextUnknownFeat(FEAT_EPIC_GREAT_SMITING_1, oPC);
            if(nFeat >= 0)
                AddKnownFeat (oPC, nFeat, GetHitDice(oPC));
        }
    }
    else
    if (class == CLASS_TYPE_ASSASSIN){
        if(level >= 25 && !GetFightingStyle(oPC)                        &&
           GetKnowsFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oPC)         &&
           GetKnowsFeat(FEAT_EPIC_REFLEXES, oPC)                        &&
           GetKnowsFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)            &&
           GetItemPossessedBy(oPC, "pl_style_ninja") == OBJECT_INVALID)
        {
            CreateItemOnObject("pl_style_ninja", oPC);
            SendMessageToPC(oPC, "You are able to study the Way of the Ninja. MORE");
        }
    }
    else
    if (class == CLASS_TYPE_PALEMASTER){
        if( level == 20){
            nFeat = GetNextUnknownFeat(FEAT_EPIC_ENERGY_RESISTANCE_COLD_1, oPC);
            if(nFeat >= 0)
                AddKnownFeat (oPC, nFeat, GetHitDice(oPC));
        }
        else if (level == 35 || level == 45){
            nFeat = GetNextUnknownFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_1, oPC);
            if(nFeat >= 0)
                AddKnownFeat (oPC, nFeat, GetHitDice(oPC));
        }
        if(level >= 40 && !GetUndeadStyle(oPC) &&
           GetItemPossessedBy(oPC, "pl_style_undead") == OBJECT_INVALID){
            CreateItemOnObject("pl_style_undead", oPC);
            SendMessageToPC(oPC, "Undead Transformation");
        }
    }
    else
    if (class == CLASS_TYPE_MONK){
        if(level >= 45 && !GetFightingStyle(oPC)
                && GetItemPossessedBy(oPC, "pl_style_monk") == OBJECT_INVALID
                && GetSubRace(oPC) != "Paragon"){
            CreateItemOnObject("pl_style_monk", oPC);
            SendMessageToPC(oPC, "You are able to select Monk Fighting Style. MORE");
        }
    }
    else
    if (class == CLASS_TYPE_HARPER){
        if(level == 2){
            ModifySkillRankByLevel (oPC, level, SKILL_LISTEN, 4);
            ModifySkillRankByLevel (oPC, level, SKILL_SPOT,   4);
            ModifySkillRankByLevel (oPC, level, SKILL_SEARCH, 4);
        }
        else if(level == 26
                && GetItemPossessedBy(oPC, "pl_harper_1") == OBJECT_INVALID){
            CreateItemOnObject("pl_harper_1", oPC);
            SuccessMessage(oPC, "You have received a Harper Secret!");
        }
        else if(level == 29
                && GetItemPossessedBy(oPC, "pl_harper_2") == OBJECT_INVALID){
            CreateItemOnObject("pl_harper_2", oPC);
            SuccessMessage(oPC, "You have received a Harper Secret!");
        }
    }

	// -------------------------------------------------------------------------
	// Announce to the server when a player has reached the following levels
	// -------------------------------------------------------------------------
	if(GetHitDice(oPC) % 5 == 0 && !GetIsTestCharacter(oPC))
		SendAllMessage(C_GOLD+GetName(oPC) + " has reached level " + IntToString(GetHitDice(oPC)) + ".  Congratulations!"+C_END);

    // -------------------------------------------------------------------------
    // Apply a visual effect of knock each time a PC levels up :)
    // -------------------------------------------------------------------------
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_KNOCK), oPC);

    ExportSingleCharacter(oPC);
}
