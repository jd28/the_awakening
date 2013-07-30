//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::File Name: sha_on_modload :::::::::::::::::::::::::::::::::::
//::::::::::::::::::::: OnModuleLoad script ::::::::::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//:: Updated By: Moon
//:: Contact: dm_moonshadow@hotmail.com
//
// Description: This is an example of script of how to use Shayan's Subraces on
//              your Module.
//
// The OnModuleLoad script is where you define your subraces. (Look below)
//
// Double click on any of the methods below to get know how to use them.
//
//
// :: Version 2.0: Pre-made subraces are now seperated into categories (Monsterous, and Normal)
//                 and put into scripts: sha_subraces1, and sha_subraces2.

#include "sha_subr_methds"

void main(){

   //Functions available for use are: (Note, this is not the full list)
   //
   // ::The Most Important Method (Used to define your subrace). MUST BE CALLED BEFORE ALL OTHERS.::
   //----- CreateSubrace(int Race, string SubraceName, string HideResRef, string UniqueItemResref, int IsLightSensitive = FALSE, int DamageTakenWhileInLight = 0, int IsUndergroundSensitive = FALSE, int DamageTakenWhileInUnderground = 0, int ECL = 0, int IsUndead = FALSE, int PrestigiousSubrace = FALSE)
   //
   // ::Used to Add another Race that can be part of the Subrace.::
   // ::Reuse as many times as needed.::
   //----- AddAdditionalBaseRaceToSubrace(string subraceName, int AdditionalBaseRace)
   //
   // ::Used to add an Alignment Restriction to a Subrace.
   //----- CreateSubraceAlignmentRestriction(string subraceName, int CanBeAlignment_Good = TRUE , int CanBeAlignment_Neutral1 = TRUE, int CanBeAlignment_Evil = TRUE, int CanBeAlignment_Lawful = TRUE, int CanBeAlignment_Neutral2 = TRUE, int CanBeAlignment_Chaotic = TRUE)
   //
   // ::Used to add a Class restriction on the Subrace.
   //----- CreateSubraceClassRestriction(string subraceName, int CanBe_Barbarian = TRUE, int CanBe_Bard = TRUE, int CanBe_Cleric = TRUE, int CanBe_Druid = TRUE, int CanBe_Fighter = TRUE, int CanBe_Monk = TRUE, int CanBe_Paladin = TRUE, int CanBe_Ranger = TRUE, int CanBe_Rogue = TRUE, int CanBe_Sorcerer = TRUE, int CanBe_Wizard = TRUE)
   //
   // ::Used to change a Player Subrace's Appearance::
   // ::Use only ONCE per subrace per level::
   //----- CreateSubraceAppearance(string subraceName, int AppearanceChangeTime, int MaleAppearance, int FemaleAppearance)
   //
   // ::Used to give PC's a change in Ability scores, or Attack Bonus or Armour Class. During the day or Night.
   // ::Used in conjunction with CreateCustomStats() <Look Below>.
   //----- CreateTemporaryStatModifier(string subraceName, struct SubraceStats Stats, int TimeToApply, int InInteriorArea = TRUE, int InExteriorArea = TRUE, int InNaturalArea = TRUE, int InArtifacialArea = TRUE, int InUndergroundArea = TRUE, int InAbovegroundArea = TRUE)
   //
   // ::Used to define the Ability increase or decrease, AC increase/decrease, AB increase/Decrease.
   //----- SubraceStats CreateCustomStats(int StatModifierType, float StrengthModifier, float DexterityModifier, float ConstitutionModifier, float IntelligenceModifier, float WisdomModifier, float CharismaModifier, float ACModifier, float ABModifier)
   //
   // ::Used to disable/allow only the use of melee, ranged or other kind of weapons during certain times of day or permanently.
   // ::Reuse as many times as needed to a max of 4.::
   //----- SubraceRestrictUseOfItems(string subrace, int ItemType, int TimeOfDay = TIME_BOTH, int Allow = ITEM_TYPE_REQ_DO_NOT_ALLOW)
   //
   // ::Add a favored Class to Subrace
   // ::Use only ONCE per subrace::
   //----- AddSubraceFavoredClass(string subraceName, int MaleFavoredClass, int FamaleFavoredClass)
   //
   // ::Add an effect to the Subrace, that takes effect during the night (lasts until morning), day(lasts until dusk) or permanently.
   // ::Use as many times as desired::
   //----- AddSubraceEffect(string subraceName, int EffectID, int Value1, int Value2, int nDurationType, float fDuration, int TimeOfDay)
   //
   // ::Add another skin for the subrace to be equipped at a particular level.
   // :: Use as Many times as desired.
   //----- AddAdditionalSkinsToSubrace(string subraceName, string SkinResRef, int EquipLevel, int iTime = TIME_BOTH)
   //
   // ::Use to create varying Spell resistance for the subrace.
   //----- CreateSubraceSpellResistance(string subraceName, int SpellResistanceBase, int SpellResistanceMax)
   //
   // ::Add 'claws' to the playable subrace.
   // :: Use as many times as desired.
   //----- AddClawsToSubrace(string subraceName, string RightClawResRef, string LeftClawResRef , int EquipLevel)
   //
   // :: Setup the player belonging to the subrace to 'switch' to another subrace
   //----- SetupSubraceSwitch(string subraceName, string switchSubraceName, int Level, int MustMeetRequirements = TRUE)
   //
   // :: Give additional 'unique' items
   //----- AddSubraceItem(string subraceName, string ItemResRef, int Level = 1)
   //
   // :: Set-up a Prestige class restriction for a subrace.
   //----- CreateSubracePrestigiousClassRestriction(string subraceName, int MinimumLevels = 1, int CanBe_ArcaneArcher = TRUE, int CanBe_Assasin = TRUE, int CanBe_Blackguard = TRUE, int CanBe_ChampionOfTorm = TRUE, int CanBe_RedDragonDisciple = TRUE, int CanBe_DwarvenDefender = TRUE, int CanBe_HarperScout = TRUE, int CanBe_PaleMaster = TRUE, int CanBe_ShadowDancer = TRUE, int CanBe_Shifter = TRUE, int CanBe_WeaponMaster = TRUE);
   //
   //
   // The following scripts load up the example subraces created by me (Shayan).
   // You can use these or add to them or delete them all.
   // You can find the Creature Hide relating to these subraces in Items -> Custom -> Creature Items -> Skin/Hide
   // You can also find the Unique Items relating to these subraces in Items -> Plot Items

    //Call it exactly one time and only during OnModuleLoad!
    SSE_ModuleLoadEvent();

    //Load Shayan's Leto Humaniod Subraces only if we are using Leto
    LoadSubraceFromScript("pl_sub_default");
    LoadSubraceFromScript("pl_sub_dwarf");
    LoadSubraceFromScript("pl_sub_elf");
    LoadSubraceFromScript("pl_sub_halfelf");
    LoadSubraceFromScript("pl_sub_halfling");
    LoadSubraceFromScript("pl_sub_halforc");
    LoadSubraceFromScript("pl_sub_human");
    LoadSubraceFromScript("pl_sub_gnome");
    LoadSubraceFromScript("pl_sub_classes");
    /*
    //Load Shayan's Leto Monsterous Subraces only if we are using Leto
    LoadSubraceFromScript("sha_leto_sraces2", SSE_SUBRACE_LOADER_CONDITION_LOAD_IF_USING_LETO);
    //Load Shayan's Leto New Defualt + Demihuman Subraces only if we are using Leto

//3.0.6.5
    LoadSubraceFromScript("sha_leto_sraces3", SSE_SUBRACE_LOADER_CONDITION_LOAD_IF_USING_LETO);
    //Load Shayan's Leto Demi Base Monsterous Subraces only if we are using Leto
    LoadSubraceFromScript("sha_leto_sraces4", SSE_SUBRACE_LOADER_CONDITION_LOAD_IF_USING_LETO);
    //Load Shayan's Leto Human Base Monsterous Subraces only if we are using Leto
    LoadSubraceFromScript("sha_leto_sraces5", SSE_SUBRACE_LOADER_CONDITION_LOAD_IF_USING_LETO);
    */
    //:: Display messages about Leto Modifications
    //:: Note: some Leto Modifications messages are flagged vital and would be showed anyway
    //:: Recommended
        //SSE_Message_AddDisplayType(MESSAGE_TYPE_CHARACTER_LETO_MODIFICATION);

    //Display messages when a player's sub-race is being changed.
    //:: Recommended
        //SSE_Message_AddDisplayType(MESSAGE_TYPE_SUBRACE_CHANGE);

    //Display messages about SSE's status (Display when it is disabled/enabled)
    //:: Recommended
        //SSE_Message_AddDisplayType(MESSAGE_TYPE_SSE_ENGINE_STATUS);

    //Display Error messages - Not a lot of those as I recall.
    //:: Recommended
        //SSE_Message_AddDisplayType(MESSAGE_TYPE_ERROR);

    //Display messages about requirements
    //e.g. "You could not become this sub-race because you did not meet this and that requirement"
    //:: Recommended
        //SSE_Message_AddDisplayType(MESSAGE_TYPE_REQUIREMENT);

    //Display messages about aliases
        //SSE_Message_AddDisplayType(MESSAGE_TYPE_SUBRACE_ALIAS);

    //Display messages about sub-race items
        //SSE_Message_AddDisplayType(MESSAGE_TYPE_CHARACTER_ITEM);

    //Display messages about non-leto stat modifications
        //SSE_Message_AddDisplayType(MESSAGE_TYPE_CHARACTER_NON_LETO_MODIFICATION);

    //Display messages about character appearance modifications
        //SSE_Message_AddDisplayType(MESSAGE_TYPE_CHARACTER_APPEARANCE_MODIFICATION);

}

