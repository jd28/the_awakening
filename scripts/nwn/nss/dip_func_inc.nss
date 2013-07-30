// Dynamic Item Properties
// Portions of code by Acaos taken from Bioboards.

// TODO: Soaks and Skills

#include "item_func_inc"

// Apply weapon specific Dynamic Item Properties as specificied in
// variables set on oSelf
void ApplyLocalsToWeapon(object oSelf, object oItem, object oItem1, object oItem2);

// Apply Dynamic Item Properties as specificied in variables set on oSelf to
// any generic item(s)
void ApplyLocalsToItem(object oSelf, object oItem, object oItem1, object oItem2);

void ApplyLocalsToWeapon(object oSelf, object oItem, object oItem1, object oItem2){
    int i, nDigit0, nDigit1, nDigit2, nDigit3, nDigit4, nDigit5, nDigit6, nDigit7, nDigit8, nDigit9;

    int nAB = GetLocalInt(oSelf, "AB");
    if(nAB){
        if(nAB > 20) nAB = 20;
        if(oItem != OBJECT_INVALID) IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nAB));
        if(oItem1 != OBJECT_INVALID) IPSafeAddItemProperty(oItem1, ItemPropertyAttackBonus(nAB));
        if(oItem2 != OBJECT_INVALID) IPSafeAddItemProperty(oItem2, ItemPropertyAttackBonus(nAB));
    }

    int nEB = GetLocalInt(oSelf, "EB");
    if(nEB){
        if(nEB > 20) nEB = 20;
        if(oItem != OBJECT_INVALID) IPSafeAddItemProperty(oItem, ItemPropertyEnhancementBonus(nEB));
        if(oItem1 != OBJECT_INVALID) IPSafeAddItemProperty(oItem1, ItemPropertyEnhancementBonus(nEB));
        if(oItem2 != OBJECT_INVALID) IPSafeAddItemProperty(oItem2, ItemPropertyEnhancementBonus(nEB));
    }

    int nKeen = GetLocalInt(oSelf, "Keen");
    if(nKeen){
        if(oItem != OBJECT_INVALID) IPSafeAddItemProperty(oItem, ItemPropertyKeen());
        if(oItem1 != OBJECT_INVALID) IPSafeAddItemProperty(oItem1, ItemPropertyKeen());
        if(oItem2 != OBJECT_INVALID) IPSafeAddItemProperty(oItem2, ItemPropertyKeen());
    }

    int nHoly = GetLocalInt(oSelf, "HolyAvenger");
    if(nHoly){
        if(oItem != OBJECT_INVALID) IPSafeAddItemProperty(oItem, ItemPropertyHolyAvenger());
        if(oItem1 != OBJECT_INVALID) IPSafeAddItemProperty(oItem1, ItemPropertyHolyAvenger());
        if(oItem2 != OBJECT_INVALID) IPSafeAddItemProperty(oItem2, ItemPropertyHolyAvenger());
    }

    int nVorp = GetLocalInt(oSelf, "Vorpal");
    if(nVorp){
        if(oItem != OBJECT_INVALID) IPSafeAddItemProperty(oItem, ItemPropertyOnHitProps(IP_CONST_ONHIT_VORPAL, nVorp));
        if(oItem1 != OBJECT_INVALID) IPSafeAddItemProperty(oItem1, ItemPropertyOnHitProps(IP_CONST_ONHIT_VORPAL, nVorp));
        if(oItem2 != OBJECT_INVALID) IPSafeAddItemProperty(oItem2, ItemPropertyOnHitProps(IP_CONST_ONHIT_VORPAL, nVorp));
    }

    nVorp = GetLocalInt(oSelf, "VampRegen");
    if(nVorp){
        if(oItem != OBJECT_INVALID) IPSafeAddItemProperty(oItem, ItemPropertyVampiricRegeneration(nVorp));
        if(oItem1 != OBJECT_INVALID) IPSafeAddItemProperty(oItem1, ItemPropertyVampiricRegeneration(nVorp));
        if(oItem2 != OBJECT_INVALID) IPSafeAddItemProperty(oItem2, ItemPropertyVampiricRegeneration(nVorp));
    }

    /* Physical Damage */
    /* Bludgeon Pierce Slash */
    int nRes = GetLocalInt(oSelf, "PhysicalDamage");
    if (nRes) {
        nDigit0 = (nRes % 10);
        nDigit1 = (nRes /= 10) % 10;
        nDigit2 = (nRes /= 10) % 10;
        if (nDigit2 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, GetDamageBonusFromNumber(nDigit2)));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, GetDamageBonusFromNumber(nDigit2)));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, GetDamageBonusFromNumber(nDigit2)));
        }
        if (nDigit1 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, GetDamageBonusFromNumber(nDigit1)));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, GetDamageBonusFromNumber(nDigit1)));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, GetDamageBonusFromNumber(nDigit1)));
        }
        if (nDigit0 > 0) {
            if(oItem != OBJECT_INVALID) IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, GetDamageBonusFromNumber(nDigit0)));
            if(oItem1 != OBJECT_INVALID) IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, GetDamageBonusFromNumber(nDigit0)));
            if(oItem2 != OBJECT_INVALID) IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, GetDamageBonusFromNumber(nDigit0)));
        }
    }

    /* Energy Damage - */
    /* Acid Cold Elec Fire Sonic Magic Positive Negative Divine */
    nRes = GetLocalInt(oSelf, "EnergyDamage");
    if (nRes) {
        nDigit0 = (nRes % 10);
        nDigit1 = (nRes /= 10) % 10;
        nDigit2 = (nRes /= 10) % 10;
        nDigit3 = (nRes /= 10) % 10;
        nDigit4 = (nRes /= 10) % 10;
        nDigit5 = (nRes /= 10) % 10;
        nDigit6 = (nRes /= 10) % 10;
        nDigit7 = (nRes /= 10) % 10;
        nDigit8 = (nRes /= 10) % 10;
        if (nDigit8 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, GetDamageBonusFromNumber(nDigit8)));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, GetDamageBonusFromNumber(nDigit8)));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, GetDamageBonusFromNumber(nDigit8)));
        }
        if (nDigit7 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, GetDamageBonusFromNumber(nDigit7)));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, GetDamageBonusFromNumber(nDigit7)));
            if(oItem2!= OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, GetDamageBonusFromNumber(nDigit7)));
        }
        if (nDigit6 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, GetDamageBonusFromNumber(nDigit6)));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, GetDamageBonusFromNumber(nDigit6)));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, GetDamageBonusFromNumber(nDigit6)));

        }
        if (nDigit5 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, GetDamageBonusFromNumber(nDigit5)));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, GetDamageBonusFromNumber(nDigit5)));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, GetDamageBonusFromNumber(nDigit5)));
        }
        if (nDigit4 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, GetDamageBonusFromNumber(nDigit4)));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, GetDamageBonusFromNumber(nDigit4)));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, GetDamageBonusFromNumber(nDigit4)));
        }
        if (nDigit3 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, GetDamageBonusFromNumber(nDigit3)));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, GetDamageBonusFromNumber(nDigit3)));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, GetDamageBonusFromNumber(nDigit3)));
        }
        if (nDigit2 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, GetDamageBonusFromNumber(nDigit2)));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, GetDamageBonusFromNumber(nDigit2)));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, GetDamageBonusFromNumber(nDigit2)));
        }
        if (nDigit1 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, GetDamageBonusFromNumber(nDigit1)));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, GetDamageBonusFromNumber(nDigit1)));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, GetDamageBonusFromNumber(nDigit1)));
        }
        if (nDigit0 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, GetDamageBonusFromNumber(nDigit0)));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, GetDamageBonusFromNumber(nDigit0)));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, GetDamageBonusFromNumber(nDigit0)));
        }
    }

    /* Extra Damage XXYY, XX = Type, YY = Amount*/
    for (i = 1; i <= 3; i++) {
        nRes = GetLocalInt(oSelf, "ExtraDamage" + IntToString(i));
        if (nRes) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus((nRes / 100)-1, (nRes % 100)));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus((nRes / 100)-1, (nRes % 100)));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus((nRes / 100)-1, (nRes % 100)));
        } else
            break;
    }

    DelayCommand(1.0, ApplyLocalsToItem(oSelf, oItem, oItem1, oItem2));
}


void ApplyLocalsToItem(object oSelf, object oItem, object oItem1, object oItem2){
    int i, nDigit0, nDigit1, nDigit2, nDigit3, nDigit4, nDigit5, nDigit6, nDigit7, nDigit8, nDigit9;

    /* Saves: 9NMDfrwFRW
     *   9: Unused
     *
     *   N: Negative            (1 points per)
     *   M: Mind Spells/Fear    (1 points per)
     *   D: Death Magic         (1 points per)
     *
     *   f: Fortitude Penalty   (1 points per)
     *   r: Reflex Penalty      (1 points per)
     *   w: Will Penalty        (1 points per)
     *
     *   F: Fortitude Bonus     (1 points per)
     *   R: Reflex Bonus        (1 points per)
     *   W: Will Bonus          (1 points per)
     */
    int nSaves = GetLocalInt(oSelf, "DIP_Saves");
    if (nSaves) {
        nDigit0 = (nSaves % 10);
        nDigit1 = (nSaves /= 10) % 10;
        nDigit2 = (nSaves /= 10) % 10;
        nDigit3 = (nSaves /= 10) % 10;
        nDigit4 = (nSaves /= 10) % 10;
        nDigit5 = (nSaves /= 10) % 10;
        nDigit6 = (nSaves /= 10) % 10;
        nDigit7 = (nSaves /= 10) % 10;
        nDigit8 = (nSaves /= 10) % 10;
        nDigit9 = (nSaves /= 10) % 10;

        if (nDigit8 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_NEGATIVE, nDigit8));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_NEGATIVE, nDigit8));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_NEGATIVE, nDigit8));
        }
        if (nDigit7 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, nDigit7));
        }
        if (nDigit6 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_DEATH, nDigit6));
        }
        if (nDigit5 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, nDigit5));
        }
        if (nDigit4 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, nDigit4));
        }
        if (nDigit3 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL, nDigit3));
        }
        if (nDigit2 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, nDigit2));
        }
        if (nDigit1 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, nDigit1));
        }
        if (nDigit0 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL, nDigit0));
        }
    }

    /* Physical Resistances */
    /* Bludgeon Pierce Slash */
    int nRes = GetLocalInt(oSelf, "DIP_Resist");
    if (nRes) {
        nDigit0 = (nRes % 10);
        nDigit1 = (nRes /= 10) % 10;
        nDigit2 = (nRes /= 10) % 10;
        if (nDigit2 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING, GetDamageResistFromNumber(nDigit2)));
        }
        if (nDigit1 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, GetDamageResistFromNumber(nDigit1)));
        }
        if (nDigit0 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, GetDamageResistFromNumber(nDigit0)));
        }
    }

    /* Energy Resistances - 5/- to 45/- */
    /* Acid Cold Elec Fire Sonic Magic Positive Negative Divine */
    nRes = GetLocalInt(oSelf, "DIP_EnergyResistance");
    if (nRes) {
        nDigit0 = (nRes % 10);
        nDigit1 = (nRes /= 10) % 10;
        nDigit2 = (nRes /= 10) % 10;
        nDigit3 = (nRes /= 10) % 10;
        nDigit4 = (nRes /= 10) % 10;
        nDigit5 = (nRes /= 10) % 10;
        nDigit6 = (nRes /= 10) % 10;
        nDigit7 = (nRes /= 10) % 10;
        nDigit8 = (nRes /= 10) % 10;
        if (nDigit8 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, GetDamageResistFromNumber(nDigit8)));
        }
        if (nDigit7 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, GetDamageResistFromNumber(nDigit7)));
        }
        if (nDigit6 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, GetDamageResistFromNumber(nDigit6)));
        }
        if (nDigit5 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, GetDamageResistFromNumber(nDigit5)));
        }
        if (nDigit4 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, GetDamageResistFromNumber(nDigit4)));
        }
        if (nDigit3 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_MAGICAL, GetDamageResistFromNumber(nDigit3)));
        }
        if (nDigit2 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_POSITIVE, GetDamageResistFromNumber(nDigit2)));
        }
        if (nDigit1 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_NEGATIVE, GetDamageResistFromNumber(nDigit1)));
        }
        if (nDigit0 > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_DIVINE, GetDamageResistFromNumber(nDigit0)));
        }
    }

    /* Ability Boosting- str dex con int wis cha - increase by twice the input number - from 1-9 */
    int nAbility = GetLocalInt(oSelf, "DIP_Ability");
    if (nAbility) {
        nDigit0 = (nAbility % 10);
        nDigit1 = (nAbility /= 10) % 10;
        nDigit2 = (nAbility /= 10) % 10;
        nDigit3 = (nAbility /= 10) % 10;
        nDigit4 = (nAbility /= 10) % 10;
        nDigit5 = (nAbility /= 10) % 10;
        if (nDigit0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(ABILITY_CHARISMA, nDigit0));
        }
        if (nDigit1) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(ABILITY_WISDOM, nDigit1));
        }
        if (nDigit2) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(ABILITY_INTELLIGENCE, nDigit2));
        }
        if (nDigit3){
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(ABILITY_CONSTITUTION, nDigit3));
        }
        if (nDigit4) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(ABILITY_DEXTERITY, nDigit4));
        }
        if (nDigit5) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(ABILITY_STRENGTH, nDigit4));
        }
    }

    /* Skill increase - 5 + (5 * input number) */
    /* Taunt/Bluff/Persuade/Intimidate/Perform MS Hide Listen Spot Tumble Parry Conc Disc */
	// <skill>:<increase>
	string skill_list = GetLocalString(oSelf, "DIP_SKILLS");
	if(skill_list != ""){
		int skill, amount, loc;
		struct SubString ss = GetFirstSubString(skill_list);
		struct SubString ss_skill;

		while(ss.first != ""){
			if((loc = FindSubString(ss.first, ":")) == -1)
				continue;
			
			ss_skill = GetFirstSubString(ss.first, ":");

			//SendMessageToPC(GetItemPossessor(oSelf), ss_skill.first + "  " + ss_skill.rest + "\n");

			skill = StringToInt(ss_skill.first);
			amount = StringToInt(ss_skill.rest);

			//SendMessageToPC(GetItemPossessor(oSelf), IntToString(skill) + "  " + IntToString(amount) + "\n");

			if(amount > 0 && amount <= 50)
				IPSafeAddItemProperty(oItem, ItemPropertySkillBonus(skill, amount));
		
			ss = GetFirstSubString(ss.rest);
		}
	}

    /* SR */
    int nSR = GetLocalInt(oSelf, "DIP_SR");
    if (nSR) {
        if(oItem != OBJECT_INVALID)
            IPSafeAddItemProperty(oItem, ItemPropertyBonusSpellResistance(GetSpellResistenceFromNumber(nSR)));
    }

    /* Regen */
    int nRegen = GetLocalInt(oSelf, "DIP_Regen");
    if (nRegen) {
        if(nRegen > 20) nRegen = 20;

        if(oItem != OBJECT_INVALID)
            IPSafeAddItemProperty(oItem, ItemPropertyRegeneration(nRegen));
    }

    /* Soak - specified as Soak+Plus (defaults to 20+1; specify 0+0 for no soak) */
    string sSoak = GetLocalString(oSelf, "DIP_Soak");
    if (sSoak != "") {
        struct SubString ss, spss;
        ss.rest = sSoak;
        while (ss.rest != "") {
            ss = GetFirstSubString(ss.rest, " ");
            if (ss.first != "0+0" && ss.first != "0") {
                spss = GetFirstSubString(ss.first, "+");
                int nSoak = StringToInt(spss.first);
                int nPlus = GetDamagePowerFromNumber(StringToInt(spss.rest));
                //eEff = SupernaturalEffect(EffectDamageReduction(nSoak, nPlus));
                //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
        }
    }
    /* AC */
    int nAC = GetLocalInt(oSelf, "DIP_AC");
    if (nAC) {
        if(nAC > 20) nAC = 20;

        if(oItem != OBJECT_INVALID)
            IPSafeAddItemProperty(oItem, ItemPropertyACBonus(nAC));
    }

    /* AC */
    int nMiscImmune = GetLocalInt(oSelf, "DIP_MISC_IMMUNE") - 1;
    if (nMiscImmune) {
        if(oItem != OBJECT_INVALID)
            IPSafeAddItemProperty(oItem, ItemPropertyImmunityMisc(nMiscImmune));
    }
    /* No Arcane Failure
    int nNoArcane = GetLocalInt(oSelf, "NoArcaneFailure");
    if (nNoArcane) {
        if(oItem != OBJECT_INVALID || GetTag(oItem) != "pl_drow_queen_ar"){
            int nArcane = -1;
            switch(GetBaseItemType(oItem)){
                case BASE_ITEM_ARMOR:
                    switch(GetBaseArmorACBonus(oItem)){
                        case 1: nArcane = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT; break;
                        case 2: nArcane = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT; break;
                        case 3:
                        case 4: nArcane = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT; break;
                        case 5: nArcane = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT; break;
                        case 6:
                        case 7: nArcane = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_40_PERCENT; break;
                        case 8: nArcane = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_45_PERCENT; break;

                    }
                break;
                case BASE_ITEM_TOWERSHIELD:
                    nArcane = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT;
                break;
                case BASE_ITEM_SMALLSHIELD:
                    nArcane = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT;
                break;
                case BASE_ITEM_LARGESHIELD:
                    nArcane = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT;
                break;
            }
            if(nArcane >= 0){
                IPSafeAddItemProperty(oItem, ItemPropertyArcaneSpellFailure(nArcane));
                IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByClass(CLASS_TYPE_BARD));
            }
        }
    }*/
}
