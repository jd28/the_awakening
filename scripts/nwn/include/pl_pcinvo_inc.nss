#include "item_func_inc"
#include "pc_funcs_inc"
#include "gsp_spinfo_inc"
#include "pc_persist"

struct EquippedWeapons {
    object oOnHand, oOffHand;
};

void AddACBonusToArmor(object oArmor, float fDuration, int nAmount);
void AddDmgBonusToEquippedWeapons(struct EquippedWeapons ew, float fDuration, int nDmgBonus, int nDamType, int nDmgVsRace = -1);
void AddDmgBonusToWeapon(object oWeapon, float fDuration, int nDmgBonus, int nDamType, int nDmgVsRace = -1);
void AddEnhancementToEquippedWeapons(struct EquippedWeapons ew, int nAmount, float fDuration);
void AddEnhancementToWeapon(object oWeapon, int nAmount, float fDuration);
void AddMiscPropertyToEquippedWeapons(struct EquippedWeapons ew, itemproperty ipProp, float fDuration);
void AddMiscPropertyToWeapon(object oWeapon, itemproperty ipProp, float fDuration);
void AddOnHitDamageToEquippedWeapons(struct SpellInfo si, struct EquippedWeapons ew, int nDamType, int nAmount, float fDuration);
void AddOnHitDamageToWeapon (struct SpellInfo si, object oWeapon, int nDamType, int nAmount, float fDuration);
void AddOnHitSpellToEquippedWeapons(struct EquippedWeapons ew, int nOnHitSpell, int nCasterLevel, float fDuration);
void AddOnHitSpellToWeapon(object oWeapon, int nOnHitSpell, int nCasterLevel, float fDuration);
void ApplyQuiverVariables(object oWeap, string sTag, int nCode);
void AddVisualToEquippedWeapons(struct EquippedWeapons ew, int nVisual, float fDuration);
void AddVisualToWeapon(object oWeapon, int nVisual, float fDuration);
int CheckILR(object oPC, object oItem);
void DisplayOnHitSpells(object oPC, object oWeapon);
struct EquippedWeapons GetTargetedOrEquippedWeapon(object oTarget, int bDual = FALSE, int bBow = FALSE);

int GetIsWeaponTwoHanded(object oPC, object oItem);

void RemoveOnHitSpell(object oWeapon, int nSpell);

void AddACBonusToArmor(object oArmor, float fDuration, int nAmount){
    IPSafeAddItemProperty(oArmor, ItemPropertyACBonus(nAmount), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,TRUE);
}

void AddDmgBonusToEquippedWeapons(struct EquippedWeapons ew, float fDuration, int nDmgBonus, int nDamType, int nDmgVsRace = -1){
    if(GetIsObjectValid(ew.oOnHand))
        AddDmgBonusToWeapon(ew.oOnHand, fDuration, nDmgBonus, nDamType, nDmgVsRace);

    if(GetIsObjectValid(ew.oOffHand))
        AddDmgBonusToWeapon(ew.oOffHand, fDuration, nDmgBonus, nDamType, nDmgVsRace);
}

void AddDmgBonusToWeapon(object oWeapon, float fDuration, int nDmgBonus, int nDamType, int nDmgVsRace = -1){
    if(nDmgVsRace < 0)
        IPSafeAddItemProperty(oWeapon,ItemPropertyDamageBonus(nDamType, nDmgBonus), fDuration,
                              X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,TRUE);
    else
        IPSafeAddItemProperty(oWeapon, ItemPropertyDamageBonusVsRace(nDmgVsRace, nDamType, nDmgBonus), fDuration,
                                                                     X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
}

void AddEnhancementToEquippedWeapons(struct EquippedWeapons ew, int nAmount, float fDuration){
    if(GetIsObjectValid(ew.oOnHand))
        AddEnhancementToWeapon(ew.oOnHand, nAmount, fDuration);

    if(GetIsObjectValid(ew.oOffHand))
        AddEnhancementToWeapon(ew.oOffHand, nAmount, fDuration);
}

void AddEnhancementToWeapon(object oWeapon, int nAmount, float fDuration){
    if(GetIsRangedWeapon2(oWeapon)){
        IPSafeAddItemProperty(oWeapon, ItemPropertyAttackBonus(nAmount), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
        IPSafeAddItemProperty(oWeapon, ItemPropertyMaxRangeStrengthMod(nAmount), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
    }
    else{ // Melee
       IPSafeAddItemProperty(oWeapon, ItemPropertyEnhancementBonus(nAmount), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
    }
}

void AddMiscPropertyToEquippedWeapons(struct EquippedWeapons ew, itemproperty ipProp, float fDuration){
    if(GetIsObjectValid(ew.oOnHand))
        AddMiscPropertyToWeapon(ew.oOnHand, ipProp, fDuration);
    if(GetIsObjectValid(ew.oOffHand))
        AddMiscPropertyToWeapon(ew.oOffHand, ipProp, fDuration);
}

void AddMiscPropertyToWeapon(object oWeapon, itemproperty ipProp, float fDuration){
    IPSafeAddItemProperty(oWeapon, ipProp, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
}

void AddOnHitDamageToEquippedWeapons (struct SpellInfo si, struct EquippedWeapons ew, int nDamType, int nAmount, float fDuration){
    if(GetIsObjectValid(ew.oOnHand))
        AddOnHitDamageToWeapon(si, ew.oOnHand, nDamType, nAmount, fDuration);

    if(GetIsObjectValid(ew.oOffHand))
        AddOnHitDamageToWeapon(si, ew.oOffHand, nDamType, nAmount, fDuration);
}

void AddOnHitDamageToWeapon (struct SpellInfo si, object oWeapon, int nDamType, int nAmount, float fDuration){
    string sIntList     = IntToString(nDamType) + ",0,0," + IntToString(nAmount);
    int nEnd            = GetLocalInt(GetModule(), "uptime") + FloatToInt(fDuration);

    SetLocalString(oWeapon, "OnHitDamages_" + IntToString(si.id), sIntList);
    SetLocalInt(oWeapon, "OnHits", GetLocalInt(oWeapon, "OnHits") + 1);
    SetLocalInt(oWeapon, "OnHitEnd_" + IntToString(si.id), nEnd);
    SetLocalInt(oWeapon, "OnHitRests_" + IntToString(si.id), GetLocalInt(si.caster, "Rests"));
    SetLocalObject(oWeapon, "OnHitCreator_" + IntToString(si.id), si.caster);

    AddOnHitSpellToWeapon(oWeapon, IP_CONST_ONHIT_CASTSPELL_INTELLIGENT_WEAPON_ONHIT, 1, 18000.0 );
    Logger(si.caster, VAR_DEBUG_SPELLS, LOGLEVEL_DEBUG, "Add Intelligent Weapon On Hit Damage: " +
           "Damage Type: %s, Damage: %s, Duration: %d", IntToString(nDamType), IntToString(nAmount),
            FloatToString(fDuration));

}

void AddOnHitSpellToWeapon(object oWeapon, int nOnHitSpell, int nCasterLevel, float fDuration){
    // If the spell is cast again, any previous itemproperties matching are removed.
    IPSafeAddItemProperty(oWeapon, ItemPropertyOnHitCastSpell(nOnHitSpell,nCasterLevel), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
}

void ApplyQuiverVariables(object oWeap, string sTag, int nCode){
    string sResref;
    int nStackSize = 50;

    if(sTag == "aleu_ranger"){
        switch(nCode % 100){
            case 0: sResref = "pl_aleu_arrow"; break; // Arrows
            case 1: sResref = "pl_aleu_bolt"; break; // Bolts
            case 2: sResref = "pl_aleu_bullets"; break; // Bullets
            case 3: sResref = "pl_aleu_dart"; break; // Darts
            case 4: sResref = "pl_aleu_shuriken"; break; // Shurikens
            case 5: sResref = "pl_aleu_axthr"; break; // Throwing Axes
        }
    }
    else if(sTag == "pl_3city_archer"){
        SetName(oWeap, "Drugo's " + GetName(oWeap));
        nStackSize = 100;
        switch(nCode % 100){
            case 0: sResref = "pl_drugo_arrow"; break; // Arrows
            case 1: sResref = "pl_drugo_bolt"; break; // Bolts
            case 2: sResref = "pl_drugo_bullet"; break; // Bullets
            case 3: sResref = "pl_drugo_darts"; break; // Darts
            case 4: sResref = "pl_drugo_shurike"; break; // Shurikens
            case 5: sResref = "pl_drugo_axethr"; break; // Throwing Axes
        }
    }
    else if(sTag == "pl_4city_archer"){
        SetName(oWeap, "Alow's " + GetName(oWeap));
        nStackSize = 200;
        switch(nCode % 100){
            case 0: sResref = "pl_4city_arrow"; break; // Arrows
            case 1: sResref = "pl_4city_bolt"; break; // Bolts
            case 2: sResref = "pl_4city_bullet"; break; // Bullets
            case 3: sResref = "pl_4city_darts"; break; // Darts
            case 4: sResref = "pl_4city_shurike"; break; // Shurikens
            case 5: sResref = "pl_4city_axethr"; break; // Throwing Axes
        }
    }
    SetLocalInt(oWeap, "StackSize", nStackSize);
    SetLocalString(oWeap, "Resref", sResref);
}

void AddVisualToEquippedWeapons(struct EquippedWeapons ew, int nVisual, float fDuration){
    if(GetIsObjectValid(ew.oOnHand))
        AddVisualToWeapon(ew.oOnHand, nVisual, fDuration);

    if(GetIsObjectValid(ew.oOffHand))
        AddVisualToWeapon(ew.oOffHand, nVisual, fDuration);
}

void AddOnHitSpellToEquippedWeapons(struct EquippedWeapons ew, int nOnHitSpell, int nCasterLevel, float fDuration) {

    if(GetIsObjectValid(ew.oOnHand))
	AddOnHitSpellToWeapon(ew.oOnHand, nOnHitSpell, nCasterLevel, fDuration);

    if(GetIsObjectValid(ew.oOffHand))
	AddOnHitSpellToWeapon(ew.oOffHand, nOnHitSpell, nCasterLevel, fDuration);
}

void AddVisualToWeapon(object oWeapon, int nVisual, float fDuration){
    IPSafeAddItemProperty(oWeapon, ItemPropertyVisualEffect(nVisual), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE,TRUE);
}

int CheckILR(object oPC, object oItem){

    if(GetLocalInt(oItem, "ilr_off")) return FALSE;

    //format: int "ilr" 12
    int nItemILR = GetLocalInt(oItem, VAR_ILR);
    string sItemSubrace = GetLocalString(oItem, VAR_ILR_SUBRACE);
    string sItemDeity = GetLocalString(oItem, VAR_ILR_DEITY);
    string sItemClassLevel = GetLocalString(oItem, VAR_ILR_CLASS);
    string sItemCasterPercent = GetLocalString(oItem, "ilr_percent");
    string sItemAbilityLevel = GetLocalString(oItem, "ilr_ability");
    string sTagged = GetLocalString(oItem, "ilr_tagged");
    string sMsg;

    int nEnhance = GetItemEnhancementBonus(oItem);
    int nLevel = GetLevelIncludingLL(oPC), nClass;
    string sText;
    int bUnequip = FALSE;

    if(nItemILR == 0){
        if(nEnhance == 4)
            nItemILR = 18;
        else if(nEnhance == 5)
            nItemILR = 28;
        else if(nEnhance > 5)
            nItemILR = 38;
    }

    if(nItemILR > nLevel){
        sText = "You must be "+IntToString(nItemILR)+" level to equip this item!";
        FloatingTextStringOnCreature(C_RED+sText+C_END, oPC, FALSE);
        bUnequip = TRUE;
    }

    if(sItemSubrace != "" && (GetStringLowerCase(sItemSubrace) != GetStringLowerCase(GetSubRace(oPC)))){
        sText = "You do not belong to the required subrace ("+ sItemSubrace +") to use this item.";
        FloatingTextStringOnCreature(C_RED+sText+C_END, oPC, FALSE);
        bUnequip = TRUE;
    }

    int tag = GetPersistantInt(oPC, "killtag:"+sTagged);
    if(sTagged != "" && !tag){
        sMsg = Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "Tagged Restricion: %s", sTagged);

        sText = "You have not done what is necessary to use this item.  Please see its description.";
        ErrorMessage(oPC, sText);
        bUnequip = TRUE;

    }
    if (sItemClassLevel != "")          //for level of class restriction
    {
        nLevel = 1;
        nEnhance = FindSubString(sItemClassLevel, ":");
        if(nEnhance != -1){
            nClass = StringToInt(GetStringLeft(sItemClassLevel, nEnhance));
            nLevel = StringToInt(GetStringRight(sItemClassLevel, GetStringLength(sItemClassLevel) - nEnhance - 1));
        }
        else{
            nClass = StringToInt(sItemClassLevel);
        }
        nClass = GetILRClass(nClass);
        if(PLGetLevelByClass(nClass, oPC) < nLevel){
            sText = "You must have at least " + IntToString(nLevel) + " level(s) of " + GetClassName(nClass) +
            "to use this item.";
            FloatingTextStringOnCreature(C_RED+sText+C_END, oPC, FALSE);
            bUnequip = TRUE;
        }
        sMsg = Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "Class Level Restricion: %s, Class: %s, Level: %s",
            sItemAbilityLevel, IntToString(nClass), IntToString(nLevel));
    }
    else{
        itemproperty ip = GetFirstItemProperty(oItem);
        while(GetIsItemPropertyValid(ip)){
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_USE_LIMITATION_CLASS){
                Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "Use Limitation: SubType: %s, Param1: %s, Param1Value: %s",
                    IntToString(GetItemPropertySubType(ip)), IntToString(GetItemPropertyParam1(ip)),
                    IntToString(GetItemPropertyParam1Value(ip)));
            }
            ip = GetNextItemProperty(oItem);
        }
    }
    /*
    int    ABILITY_STRENGTH         = 0; // should be the same as in nwseffectlist.cpp
    int    ABILITY_DEXTERITY        = 1;
    int    ABILITY_CONSTITUTION     = 2;
    int    ABILITY_INTELLIGENCE     = 3;
    int    ABILITY_WISDOM           = 4;
    int    ABILITY_CHARISMA         = 5;
    */

    if (sItemAbilityLevel != ""){         //for level of class restriction
        nLevel = 1;
        nEnhance = FindSubString(sItemAbilityLevel, ":");
        if(nEnhance != -1){
            nClass = StringToInt(GetStringLeft(sItemAbilityLevel, nEnhance));
            nLevel = StringToInt(GetStringRight(sItemAbilityLevel, GetStringLength(sItemAbilityLevel) - nEnhance - 1));
        }
        else{
            return FALSE;
        }
        nClass = nClass - 1;

        sMsg = Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "Ability Level Restricion: %s, Ability: %s, Level: %s",
            sItemAbilityLevel, IntToString(nClass), IntToString(nLevel));

        if(GetAbilityScore(oPC, nClass, TRUE) < nLevel){
            sText = "You must have at least " + IntToString(nLevel) + " point(s) of " + GetAbilityName(nClass) +
            " to use this item.";
            FloatingTextStringOnCreature(C_RED+sText+C_END, oPC, FALSE);
            bUnequip = TRUE;
        }
    }
    else if(sItemCasterPercent != ""){

    }

    return bUnequip;
}
void DisplayOnHitSpells(object oPC, object oWeapon){
    string sMsg;
    struct IntList il;
    int nEnd;
    object oCreator;

    int nSpell = SPELL_BLADE_THIRST;
    if((nEnd = GetLocalInt(oWeapon, "OnHitEnd_" + IntToString(nSpell))) > 0){
        oCreator = GetLocalObject(oWeapon, "OnHitCreator_" + IntToString(nSpell));
        // If duration is over, creator is invalid, or creator has rested: remove effects
        if(GetLocalInt(GetModule(), "uptime") >= nEnd
           || !GetIsObjectValid(oCreator)
           || GetLocalInt(oWeapon, "OnHitRests_" + IntToString(nSpell)) < GetLocalInt(oCreator, "Rests"))
        {
            RemoveOnHitSpell(oWeapon, nSpell);
        }
        else {
            il = GetIntList(GetLocalString(oWeapon, "OnHitDamages_" + IntToString(nSpell)), ",");
            sMsg += "  " +C_WHITE+ "Blade Thirst: "+C_LT_PURPLE;
            if(il.i1 > 0 && il.i2 > 0)
                sMsg += IntToString(il.i1) + "d" + IntToString(il.i2)+" + ";
            sMsg += IntToString(il.i3) + " of " + GetDamageTypeName(il.i0);
            sMsg += " vs Favored Enemies\n";
        }
    }

    nSpell = SPELL_DARKFIRE;
    if((nEnd = GetLocalInt(oWeapon, "OnHitEnd_" + IntToString(nSpell))) > 0){
        oCreator = GetLocalObject(oWeapon, "OnHitCreator_" + IntToString(nSpell));
        // If duration is over, creator is invalid, or creator has rested: remove effects
        if(GetLocalInt(GetModule(), "uptime") >= nEnd
           || !GetIsObjectValid(oCreator)
           || GetLocalInt(oWeapon, "OnHitRests_" + IntToString(nSpell)) < GetLocalInt(oCreator, "Rests"))
        {
            RemoveOnHitSpell(oWeapon, nSpell);
        }
        else {
            il = GetIntList(GetLocalString(oWeapon, "OnHitDamages_" + IntToString(nSpell)), ",");
            sMsg += "  " + C_WHITE+"Darkfire: "+C_LT_PURPLE;
            if(il.i1 > 0 && il.i2 > 0)
                sMsg += IntToString(il.i1) + "d" + IntToString(il.i2)+" + ";
            sMsg += IntToString(il.i3) + " of " + GetDamageTypeName(il.i0) + "\n";
        }
    }

    nSpell = SPELL_FLAME_WEAPON;
    if((nEnd = GetLocalInt(oWeapon, "OnHitEnd_" + IntToString(nSpell))) > 0){
        oCreator = GetLocalObject(oWeapon, "OnHitCreator_" + IntToString(nSpell));
        // If duration is over, creator is invalid, or creator has rested: remove effects
        if(GetLocalInt(GetModule(), "uptime") >= nEnd
           || !GetIsObjectValid(oCreator)
           || GetLocalInt(oWeapon, "OnHitRests_" + IntToString(nSpell)) < GetLocalInt(oCreator, "Rests"))
        {
            RemoveOnHitSpell(oWeapon, nSpell);
        }
        else {
            il = GetIntList(GetLocalString(oWeapon, "OnHitDamages_" + IntToString(nSpell)), ",");
            sMsg += "  " + C_WHITE+"FlameWeapon: "+C_LT_PURPLE;
            if(il.i1 > 0 && il.i2 > 0)
                sMsg += IntToString(il.i1) + "d" + IntToString(il.i2)+" + ";
            sMsg += IntToString(il.i3) + " of " + GetDamageTypeName(il.i0) + "\n";
        }
    }

    if(sMsg != ""){
        sMsg = C_LT_PURPLE+"On Hit Spells:\n" + sMsg;
        SendMessageToPC(oPC, sMsg+C_END);
    }
}

struct EquippedWeapons GetTargetedOrEquippedWeapon(object oTarget, int bDual = FALSE, int bBow = FALSE){

    struct EquippedWeapons ew;

    if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)  {
        if (GetIsMeleeWeapon(oTarget) || (bBow && GetIsRangedWeapon2(oTarget))){
            ew.oOnHand = oTarget;
            return ew;
        }
    }

    object oRH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    object oLH = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);


    if (GetIsMeleeWeapon(oRH) || (bBow && GetIsRangedWeapon2(oRH)))
        ew.oOnHand = oRH;

    if (bDual && GetIsMeleeWeapon(oLH))
        ew.oOffHand = oLH;

    // If the main hand is a valid weapon then we're done.
    if(GetIsObjectValid(ew.oOnHand))
        return ew;

    object oArm = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
    if (GetIsObjectValid(oArm) && GetBaseItemType(oArm) == BASE_ITEM_GLOVES)
        ew.oOnHand = oArm;

    object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
    if (GetIsObjectValid(oWeapon1))
        ew.oOnHand = oWeapon1;

    oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
    if (GetIsObjectValid(oWeapon1))
        ew.oOffHand = oWeapon1;

    return ew;
}

int GetIsWeaponTwoHanded(object oPC, object oItem){
    int nCreSize = GetCreatureSize(oPC);
    int nSize = StringToInt(Get2DAString("baseitems", "WeaponSize", GetBaseItemType(oItem)));

    if(nSize > nCreSize)
        return TRUE;

    return FALSE;
}
void RemoveOnHitSpell(object oWeapon, int nSpell){
    int nOnHit = GetLocalInt(oWeapon, "OnHits") - 1;
    if(nOnHit <= 0){
        nOnHit = 0;
        IPRemoveMatchingItemProperties(oWeapon, ITEM_PROPERTY_ONHITCASTSPELL, DURATION_TYPE_TEMPORARY,
                                       IP_CONST_ONHIT_CASTSPELL_INTELLIGENT_WEAPON_ONHIT);
    }
    SetLocalInt(oWeapon, "OnHits", nOnHit);
    DeleteLocalString(oWeapon, "OnHitDamages_" + IntToString(nSpell));
    DeleteLocalInt(oWeapon, "OnHitEnd_" + IntToString(nSpell));
    DeleteLocalInt(oWeapon, "OnHitLevel_" + IntToString(nSpell));
    DeleteLocalInt(oWeapon, "OnHitRests_" + IntToString(nSpell));
    DeleteLocalObject(oWeapon, "OnHitCreator_" + IntToString(nSpell));
}

