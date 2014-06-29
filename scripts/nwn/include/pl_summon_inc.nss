#include "nwnx_inc"
#include "mon_func_inc"

// Level up a creature to a specific level.
// See x2_inc_summscale for more information
int SSMLevelUpCreature(object oCreature, int nLevelUpTo, int nClass = CLASS_TYPE_INVALID, int bReadySpells =TRUE);

// Scale up a summoned shadowlord into epic leves
// See x2_inc_summscale for more information
int SSMScaleEpicShadowLord(object oSelf, int nLevel);

// Scale up a summoned fiendish servant into epic leves
// See x2_inc_summscale for more information
int SSMScaleEpicFiendishServant(object oServant);

//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-25
//:://////////////////////////////////////////////

int SSMLevelUpCreature(object oCreature, int nLevelUpTo, int nClass = CLASS_TYPE_INVALID, int bReadySpells = TRUE)
{
  int nCurrLevel = GetHitDice(oCreature);
  //PrintString(GetName(oCreature) + " is level " + IntToString(nCurrLevel) + " and wants to become level " + IntToString(nLevelUpTo));
  if (nCurrLevel >= nLevelUpTo)
  {
    return TRUE;    // creature already has that level
  }

  int nLevel = LevelUpHenchman(oCreature,nClass,bReadySpells);
  // level me up until I the same level as my master (or something fails)
  while (nLevel < (nLevelUpTo) && nLevel != 0)
  {
     // level up to thenext level
       //PrintString(GetName(oCreature) + " is now level "+ IntToString(nLevel));
     nLevel = LevelUpHenchman(OBJECT_SELF,nClass,bReadySpells);
  }

  // PrintString(GetName(oCreature) + " LevelUp returned "+ IntToString(nLevel));

  // verify success
  if (nLevel < nLevelUpTo)
  {
    return FALSE;
  }


  return TRUE;
}

//::///////////////////////////////////////////////
//:: SSMScaleEpicShadowLord
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Level up an epic shadowlord summoned by
    a shadowdancer's summon shadow ability
    into epic levels

    (1 level below the master's classlevel)
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-25
//:://////////////////////////////////////////////
int SSMScaleEpicShadowLord(object oSelf, int nLevel){
    effect eEff;
    // Haste
    eEff = SupernaturalEffect(EffectHaste());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);



    switch(nLevel / 6){
        case 0:
            // Nothing
        break;
        case 1:
            ApplyACBonus(oSelf, 1, 1, 1);
            ApplyPhysicalImmunities(oSelf, 5, 5, 5);
        break;
        case 2:
            ApplyPhysicalResistance(oSelf, 5, 5, 5);
            ApplyACBonus(oSelf, 1, 1, 1);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyElementalResistance(oSelf, 5, 5, 5, 5, 5);
            ApplyPhysicalImmunities(oSelf, 5, 5, 5);
            ApplySight(oSelf, TRUE);
        break;
        case 3:
            ApplyPhysicalResistance(oSelf, 5, 5, 5);
            ApplyACBonus(oSelf, 2, 2, 2);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 5, 5, 5, 5, 5);
            ApplyElementalImmunities(oSelf, 10, 10, 10, 10, 10);
            ApplyExoticImmunities(oSelf, 10, 10, 10, 10);
            ApplyPhysicalImmunities(oSelf, 10, 10, 10);
        break;
        case 4:
            ApplyPhysicalResistance(oSelf, 10, 10, 10);
            ApplyACBonus(oSelf, 3, 3, 3);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 10, 10, 10, 10, 10);
            ApplyElementalImmunities(oSelf, 20, 20, 20, 20, 20);
            ApplyExoticImmunities(oSelf, 20, 20, 20, 20);
            ApplyPhysicalImmunities(oSelf, 20, 20, 20);
            ApplySight(oSelf, TRUE);
        break;
        case 5:
            ApplyAbilities(oSelf, 12, 12, 12, 12, 12, 12);
            ApplyPhysicalResistance(oSelf, 10, 10, 10);
            ApplyACBonus(oSelf, 4, 4, 4);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalImmunities(oSelf, 25, 25, 25, 25, 25);
            ApplyExoticImmunities(oSelf, 25, 25, 25, 25);
            ApplyPhysicalImmunities(oSelf, 25, 25, 25);
            ApplySight(oSelf, TRUE);
        break;
        case 6:
            ApplyAbilities(oSelf, 12, 12, 12, 12, 12, 12);
            ApplyPhysicalResistance(oSelf, 15, 15, 15);
            ApplyACBonus(oSelf, 5, 5, 5);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 15, 15, 15, 15, 15);
            ApplyElementalImmunities(oSelf, 30, 30, 30, 30, 30);
            ApplyExoticImmunities(oSelf, 30, 30, 30, 30);
            ApplyPhysicalImmunities(oSelf, 30, 30, 30);
            ApplySight(oSelf, TRUE);
        break;
    }
    return TRUE;
}

//::///////////////////////////////////////////////
//:: SSMScaleEpicFiendishServant
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Level up an epic fiendishsservantummoned by
    a blackguard into epic levels

    (4 level below the master's classlevel)
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-25
//:://////////////////////////////////////////////
int ScaleEpicFiendishServant(object oServant){

    object oMaster = GetMaster(oServant);

    // no master? no levelup!
    if (!GetIsObjectValid(oMaster)){
        return FALSE;
    }

    int nLevelTo = GetHitDice(oMaster);
    int nRet = SSMLevelUpCreature(oServant, nLevelTo, CLASS_TYPE_FIGHTER);

    int i;
    for(i = 0; i < 6; i++){
        SetAbilityScore(oServant, i, GetAbilityScore(oMaster, i, TRUE));
    }

    int nLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oMaster) + 10;
    SSMScaleEpicShadowLord(oServant, nLevel);

    return nRet;
}
int ScaleEpicDragonKnight(object oSelf, int nAbility){

    object oMaster = GetMaster(oSelf);
    int nLevel = GetHitDice(oMaster);

    // no master? no levelup!
    if (!GetIsObjectValid(oMaster)){
        Log("Invalid Master");
        return FALSE;
    }

    int nLevelTo = GetHitDice(oMaster);
    int nRet = SSMLevelUpCreature(oSelf, nLevelTo, CLASS_TYPE_DRAGON);
    if(!nRet)
        Log("Level up Failed");
    if(GetAbilityScore(oMaster, nAbility, TRUE) > GetAbilityScore(oSelf, ABILITY_STRENGTH, TRUE))
        SetAbilityScore(oSelf, ABILITY_STRENGTH, GetAbilityScore(oMaster, nAbility, TRUE));

    effect eEff;
    // Haste
    eEff = SupernaturalEffect(EffectHaste());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);

    ApplyAbilities(oSelf, 12, 12, 12, 12, 12, 12);

    switch(nLevel / 6){
        case 0:
            // Nothing
        break;
        case 1:
            ApplyACBonus(oSelf, 1, 1, 1);
            ApplyPhysicalImmunities(oSelf, 5, 5, 5);
        break;
        case 2:
            ApplyPhysicalResistance(oSelf, 5, 5, 5);
            ApplyACBonus(oSelf, 2, 2, 2);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyElementalResistance(oSelf, 5, 5, 5, 5, 5);
            ApplyPhysicalImmunities(oSelf, 5, 5, 5);
            ApplySight(oSelf, TRUE);
        break;
        case 3:
            ApplyPhysicalResistance(oSelf, 10, 10, 10);
            ApplyACBonus(oSelf, 3, 3, 3);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 5, 5, 5, 5, 5);
            ApplyElementalImmunities(oSelf, 10, 10, 10, 10, 10);
            ApplyExoticImmunities(oSelf, 10, 10, 10, 10);
            ApplyPhysicalImmunities(oSelf, 10, 10, 10);
        break;
        case 4:
            ApplyPhysicalResistance(oSelf, 10, 10, 10);
            ApplyACBonus(oSelf, 4, 4, 4);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 10, 10, 10, 10, 10);
            ApplyElementalImmunities(oSelf, 20, 20, 20, 20, 20);
            ApplyExoticImmunities(oSelf, 20, 20, 20, 20);
            ApplyPhysicalImmunities(oSelf, 20, 20, 20);
            ApplySight(oSelf, TRUE);
        break;
        case 5:
            ApplyPhysicalResistance(oSelf, 15, 15, 15);
            ApplyACBonus(oSelf, 5, 5, 5);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 15, 15, 15, 15, 15);
            ApplyElementalImmunities(oSelf, 25, 25, 25, 25, 25);
            ApplyExoticImmunities(oSelf, 25, 25, 25, 25);
            ApplyPhysicalImmunities(oSelf, 25, 25, 25);
            ApplySight(oSelf, TRUE);
        break;
        case 6:
            ApplyPhysicalResistance(oSelf, 15, 15, 15);
            ApplyACBonus(oSelf, 6, 6, 6);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 15, 15, 15, 15, 15);
            ApplyElementalImmunities(oSelf, 30, 30, 30, 30, 30);
            ApplyExoticImmunities(oSelf, 30, 30, 30, 30);
            ApplyPhysicalImmunities(oSelf, 30, 30, 30);
            ApplySight(oSelf, TRUE);
        break;
    }


    return nRet;
}

int ScaleEpicMummy(object oSelf, int nAbility){

    object oMaster = GetMaster(oSelf);
    int nLevel = GetHitDice(oMaster);
    // no master? no levelup!
    if (!GetIsObjectValid(oMaster)){
        Log("Invalid Mummy Dust Master");
        return FALSE;
    }

    int nLevelTo = GetHitDice(oMaster);
    int nRet = SSMLevelUpCreature(oSelf, nLevelTo, CLASS_TYPE_UNDEAD);

    if(!nRet)
        Log("Level up Failed");

    if(GetAbilityScore(oMaster, nAbility, TRUE) > GetAbilityScore(oSelf, ABILITY_DEXTERITY, TRUE))
        SetAbilityScore(oSelf, ABILITY_DEXTERITY, GetAbilityScore(oMaster, nAbility, TRUE));


    effect eEff;
    // Haste
    eEff = SupernaturalEffect(EffectHaste());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);

    ApplyAbilities(oSelf, 12, 12, 12, 12, 12, 12);

    switch(nLevel / 6){
        case 0:
            // Nothing
        break;
        case 1:
            ApplyACBonus(oSelf, 1, 1, 1);
            ApplyPhysicalImmunities(oSelf, 5, 5, 5);
        break;
        case 2:
            ApplyPhysicalResistance(oSelf, 5, 5, 5);
            ApplyACBonus(oSelf, 2, 2, 2);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyElementalResistance(oSelf, 5, 5, 5, 5, 5);
            ApplyPhysicalImmunities(oSelf, 5, 5, 5);
            ApplySight(oSelf, TRUE);
        break;
        case 3:
            ApplyPhysicalResistance(oSelf, 10, 10, 10);
            ApplyACBonus(oSelf, 3, 3, 3);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 5, 5, 5, 5, 5);
            ApplyElementalImmunities(oSelf, 10, 10, 10, 10, 10);
            ApplyExoticImmunities(oSelf, 10, 10, 10, 10);
            ApplyPhysicalImmunities(oSelf, 10, 10, 10);
        break;
        case 4:
            ApplyPhysicalResistance(oSelf, 10, 10, 10);
            ApplyACBonus(oSelf, 4, 4, 4);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 10, 10, 10, 10, 10);
            ApplyElementalImmunities(oSelf, 20, 20, 20, 20, 20);
            ApplyExoticImmunities(oSelf, 20, 20, 20, 20);
            ApplyPhysicalImmunities(oSelf, 20, 20, 20);
            ApplySight(oSelf, TRUE);
        break;
        case 5:
            ApplyPhysicalResistance(oSelf, 15, 15, 15);
            ApplyACBonus(oSelf, 5, 5, 5);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 15, 15, 15, 15, 15);
            ApplyElementalImmunities(oSelf, 25, 25, 25, 25, 25);
            ApplyExoticImmunities(oSelf, 25, 25, 25, 25);
            ApplyPhysicalImmunities(oSelf, 25, 25, 25);
            ApplySight(oSelf, TRUE);
        break;
        case 6:
            ApplyPhysicalResistance(oSelf, 15, 15, 15);
            ApplyACBonus(oSelf, 6, 6, 6);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 15, 15, 15, 15, 15);
            ApplyElementalImmunities(oSelf, 30, 30, 30, 30, 30);
            ApplyExoticImmunities(oSelf, 30, 30, 30, 30);
            ApplyPhysicalImmunities(oSelf, 30, 30, 30);
            ApplySight(oSelf, TRUE);
        break;
    }


    return nRet;
}
