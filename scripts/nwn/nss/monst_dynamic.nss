///////////////////////////////////////////////////////////////////////////
/////////CUSTOM SPAWN IN FUNCTIONS ////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//Designed By Genisys / (Guile) ~ CREATED ON: 8/08/08
///////////////////////////////////////////////////////////////////////////
/*

 This rather ingenious System evens out Combat for Monster Vs Player
 This script works only on the Monsters in which you use this script!
 This script goes in the OnSpawn Event for EACH Monster you want TOUGH!

 Basically it Raises the Monster's AC to match the PC's AB (+14)(Adjustable)
 It also increases the Monster's AB to match the PC's AC (-14) (Adjustable)
 (NOTE: You must subtract because 30 AB vs 30 AC requires 0 to hit!)

 WARNING:
 Only change things Below in sections where it has:
 ### *** OPTIONAL SETTINGS *** ###
 (Follow the Instructions and you won't have any problems)

 NOTE:
 It's not recommended you use this on EVERY Monster, rather use it
 On Monsters you WANT to be difficult that otherwise wouldn't be.

 NOTE:
 I playtested this system by using writing information in the log file
 and have found the system to be very well designed and error free.
 Test it yourself, just make sure you delete the PrintString("-----");
 Functions below after you are done testing!!!
 (To Read the Log File - Look in the Log Folder Found In The NWN Folder))

*/
////////////////////////////////////////////////////////////////////////////

#include "x2_inc_switches"
#include "x0_i0_anims"

////////////////////////////////////////////////////////////////////////////////
// Constants
////////////////////////////////////////////////////////////////////////////////

// Feature options.
const int USE_DYNAMIC_AB_AC = TRUE;
const int USE_DYNAMIC_CONCEALMENT = FALSE;
const int USE_DYNAMIC_SR = FALSE;
const int USE_DYNAMIC_DAMAGE = FALSE;
const int USE_DYNAMIC_IMMUNITIES = FALSE;

// AB/AC settings
const int HIGHEST_MODULE_AB_EB = 5; // << The best weapon Attack/Enehancement Bonus
//The #'s Below are a control on how hard or easy you want to make combat
//The Acceptable range of #'s you can use below are from 10 to 18
//The # to the left ~ # = (X %) are the #'s you will change the #'s below to
//The # % below = Defines the chances to actually hit the opponent
//10 = 50 % (Very Easy) / 11 = 45 % / 12 = 40 % / 13 = 35 % / 14 = 30 %
//15 = 25 % / 16 = 20 % / 17 = 15 % / 18 = 10 % (Very Hard)  */
const int MONSTER_HIT_CHANCE = 14;
const int PC_HIT_CHANCE = 14;

// Concealment settings.
const int MONSTER_CONCEALMENT = 40;

// Spell Resistence settings
const int MONSTER_BASE_SR = 15;

// Damage settings.
const int DAMAGE_NUM_DICE = 1; // << Number of d12s to roll for extra /unblockable/ damage.

// Immunity settings
const int IMMUNITY_PHYSICAL = 20; // << Physical = (Slashing / Piercing / Bludgeoning) damage
const int IMMUNITY_ELEMENTAL = 20; // << Elemental = (Acid / Cold /Electrical / Fire / & Sonic ) damage
const int IMMUNITY_HOU = 20; // << HOU = (magical / negative / positive / divine) damages

//////////////////////////////////////////////////////////////////////////
// Prototypes
//////////////////////////////////////////////////////////////////////////

void ApplyDynamicABAC(object oMonster, object oPC);
void ApplyDynamicConcealment(object oMonster);
void ApplyDynamicSR(object oMonster, object oPC);
void ApplyDynamicDamage(object oMonster);
void ApplyDynamicImmunity(object oMonster);

//////////////////////////////////////////////////////////////////////////
// Functions
//////////////////////////////////////////////////////////////////////////
void main(){
    object oMonster = OBJECT_SELF;
    object oPC = GetNearestEnemy(oMonster);

    if(USE_DYNAMIC_AB_AC){
        ApplyDynamicABAC(oMonster, oPC);
    }

    if(USE_DYNAMIC_CONCEALMENT){
        ApplyDynamicConcealment(oMonster);
    }

    if(USE_DYNAMIC_SR){
        ApplyDynamicSR(oMonster, oPC);
    }

    if(USE_DYNAMIC_DAMAGE){
        ApplyDynamicDamage(oMonster);
    }

    if(USE_DYNAMIC_IMMUNITIES){
        ApplyDynamicImmunity(oMonster);
    }

    // Any other custom spawn in effects could go here.

} // void main()

void ApplyDynamicABAC(object oMonster, object oPC){
    int nAB;
    int nAB2;
    int nAdjPCAB;
    int nAdjMonAB;
    int nNAC; //AC To be Added to the Monster (Defined Below)
    int nNAB; //AB To be Added to the Monster (Defined Below)

    // Current PC & Monster stats.
    int nAC = GetAC(oPC);
    int nBAB = GetBaseAttackBonus(oPC);
    int nMAC = GetAC(oMonster);
    int nMBAB = GetBaseAttackBonus(oMonster);

    //Ability Modifier Bonuses for Strength & Dexterity (Used Below)
    int nPCStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
    int nPCDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    int nMStr = GetAbilityModifier(ABILITY_STRENGTH, oMonster);
    int nMDex = GetAbilityModifier(ABILITY_DEXTERITY, oMonster);

    //Adjust the Base AB depending upon level
    int nPCHD = GetHitDice(oPC); //Level of PC
    int nPCAHD = nPCHD / 13; //Adj. For Feats + 1 / 13 levels (+3 Max!)
    int nPCAB = nBAB + nPCAHD; //Base AB + Level Bonus
    int nMAB = nMBAB;  //Base AB ONLY For Monsters

    ////////////////////////////////////////////////////////////////////////////
    //Adjust the Attack Bonuses of PC Based upon Ability Modifier Bonuses
    ////////////////////////////////////////////////////////////////////////////

    //If the Strength Bonus is higher than Dexterity & at least 3!
    if(nPCStr > nPCDex && nPCStr > 2){
        nAB = nPCStr + nPCAB;
        nAdjPCAB = nAB + HIGHEST_MODULE_AB_EB;
    }
    //If the Dexterity Bonus is higher than Strength & at least 3!
    else if(nPCDex > nPCStr && nPCDex > 2){
        nAB = nPCDex + nPCAB;
        nAdjPCAB = nAB + HIGHEST_MODULE_AB_EB;//+ Best Module Weapon Attack Bonus
    }
    //Otherwise just add + 2 For ability Modifiers (Since both are low)
    else {
        nAB = nPCAB + HIGHEST_MODULE_AB_EB;
        nAdjPCAB = nAB + 2; //+2 for Ability modifier
    }

    ////////////////////////////////////////////////////////////////////////////
    //Adjust the Attack Bonuses of Monster Based upon Ability Modifier Bonuses
    ////////////////////////////////////////////////////////////////////////////

    //If the Strength Bonus is higher than Dexterity & at least 3!
    if(nMStr > nMDex && nMStr > 2){
        nAdjMonAB = nMStr + nMAB;
    }
    //If the Dexterity Bonus is higher than Strength & at least 3!
    else if(nMDex>nMStr && nMDex>2){
        nAdjMonAB = nMDex + nMAB;//ABAB + Dex Bonus
    }
    //Otherwise just use Base Attack Bonus
    else{
        nAdjMonAB = nMAB; //ABAB ONLY!
    }

    ////////////////////////////////////////////////////////////////////////////
    // Determine how much AB and AC the monster should have.
    ////////////////////////////////////////////////////////////////////////////
    int nOAC = nAdjPCAB - nMAC; // << PC's AB - Monster AC (How much AC to give!)
    int nOAB = nAC - nAdjMonAB; // << PC AC - Monster's AB (How much AB to give!)
    nNAC = nOAC + PC_HIT_CHANCE; // << Set Monster AC for PCs chance of hitting on a full attack
    nNAB = nOAB - MONSTER_HIT_CHANCE; // << Set Monster AB for its chance of hitting on a full attack


    ////////////////////////////////////////////////////////////////////////////
    // Apply the effects.
    ////////////////////////////////////////////////////////////////////////////
    effect eAC = EffectACIncrease(nNAC, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
    eAC = SupernaturalEffect(eAC); //NOT Dispellable!
    effect eAB = EffectAttackIncrease(nNAB, ATTACK_BONUS_MISC);
    eAB = SupernaturalEffect(eAB); //NOT Dispellable!

    //Do this only if the changes will IMPROVE the Monster
    //If the Monster's AC Adjustment will be higher than 0 continue
    if(nNAC>=1){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oMonster);
    }

    //If the Monster AB Adjustment will be higher than 0 continue
    if(nNAB>=1){
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAB, oMonster);
    }

    // Log the stats if we're debuging.
    if(GetLocalInt(GetModule(), "DEBUG")){
        PrintString(IntToString(nAC) + " = PC's AC");
        PrintString(IntToString(nBAB) + " = PC's Base Attack Bonus");
        PrintString(IntToString(nAdjPCAB) + " = PC's Adj. Attack Bonus");
        PrintString(IntToString(nMAC) + " = Monster's AC");
        PrintString(IntToString(nMBAB) + " = Monster's Base Attack Bonus");
        PrintString(IntToString(nAdjMonAB) + " = Monster's Adjusted Attack Bonus");
        PrintString(IntToString(nNAC) + " = AC Adjusted On Monster ");
        PrintString(IntToString(nNAB) + " = AB Adjusted On Monster");
    }

} // void ApplyDynamicABAC(object oMonster, object oPC)

void ApplyDynamicConcealment(object oMonster){

    effect eMC= EffectConcealment(MONSTER_CONCEALMENT, MISS_CHANCE_TYPE_NORMAL);
    eMC = ExtraordinaryEffect(eMC); //(CANNOT BE DISPELED!)
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMC, oMonster);

} //void ApplyDynamicConcealment(object oMonster)

void ApplyDynamicSR(object oMonster, object oPC){

    int nSRL = GetHitDice(oPC) / 2; // << Monster gets 1 extra SR for every 2 PC leves
    int nResist = nSRL + MONSTER_BASE_SR; //PC Level divided by 2 + nSR
    effect eSR= EffectSpellResistanceIncrease(nResist);

    eSR = ExtraordinaryEffect(eSR); //(CANNOT BE DISPELED!)
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSR, oMonster);

}// void ApplyDynamicSR(object oMonster)

void ApplyDynamicDamage(object oMonster){

    int nDAM = d12(DAMAGE_NUM_DICE);
    effect eDAM = EffectDamageIncrease(nDAM, DAMAGE_TYPE_POSITIVE);
    eDAM = SupernaturalEffect(eDAM); //Cannot Be Dispelled!
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDAM, oMonster);

} //void ApplyDynamicDamage(object oMonster)

void ApplyDynamicImmunity(object oMonster){
/*
WARNING: YOU MUST Take into consideration Damage Reduction and Resistance
ALREADY On monsters in your module!!
If monsters have 20 Resistance or higher do not set above 40%!!
If they have 0 resistance then you may set it to 75% MAXIMUM!
Acceptable #s used below are any # between 5 - 75
*/

    //Physical Damage
    effect eResist1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, IMMUNITY_PHYSICAL);
    eResist1 = SupernaturalEffect(eResist1); //Cannot be dispelled!
    effect eResist2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, IMMUNITY_PHYSICAL);
    eResist2 = SupernaturalEffect(eResist2); //Cannot be dispelled!
    effect eResist3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, IMMUNITY_PHYSICAL);
    eResist3 = SupernaturalEffect(eResist3); //Cannot be dispelled!

    //Elemental Damage
    effect eResist4 = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, IMMUNITY_ELEMENTAL);
    eResist4 = SupernaturalEffect(eResist4); //Cannot be dispelled!
    effect eResist5 = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, IMMUNITY_ELEMENTAL);
    eResist5 = SupernaturalEffect(eResist5); //Cannot be dispelled!
    effect eResist6 = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, IMMUNITY_ELEMENTAL);
    eResist6 = SupernaturalEffect(eResist6); //Cannot be dispelled!
    effect eResist7 = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, IMMUNITY_ELEMENTAL);
    eResist7 = SupernaturalEffect(eResist7); //Cannot be dispelled!
    effect eResist8 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, IMMUNITY_ELEMENTAL);
    eResist8 = SupernaturalEffect(eResist8); //Cannot be dispelled!

    //HOU Damage
    effect eImmune1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, IMMUNITY_HOU);
    eImmune1 = SupernaturalEffect(eImmune1); //Cannot be dispelled!
    effect eImmune2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, IMMUNITY_HOU);
    eImmune2 = SupernaturalEffect(eImmune2); //Cannot be dispelled!
    effect eImmune3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, IMMUNITY_HOU);
    eImmune3 = SupernaturalEffect(eImmune3); //Cannot be dispelled!
    effect eImmune4 = EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, IMMUNITY_HOU);
    eImmune4 = SupernaturalEffect(eImmune4); //Cannot be dispelled!

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist1, oMonster);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist2, oMonster);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist3, oMonster);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist4, oMonster);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist5, oMonster);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist6, oMonster);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist7, oMonster);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResist8, oMonster);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmune1, oMonster);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmune2, oMonster);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmune3, oMonster);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmune4, oMonster);

}// void ApplyDynamicImmunity(object oMonster)
