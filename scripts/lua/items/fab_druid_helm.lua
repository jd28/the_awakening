resref = "fab_druid_helm"

-- Properties
properties = {
   AC(6),
   Ability(ABILITY_STRENGTH, Random(3, 5)),
   Ability(ABILITY_WISDOM, 4),
   Ability(ABILITY_CHARISMA, 4),
   DamageImmunity(IP_CONST_DAMAGE_DIVINE, 62),
   DamageImmunity(IP_CONST_DAMAGE_MAGICAL, 60),
   DamageImmunity(IP_CONST_DAMAGE_NEGATIVE, 60),
   DamageImmunity(IP_CONST_DAMAGE_POSITIVE, 60),
   BonusLevelSpell(CLASS_TYPE_DRUID, 6, 2),
   BonusLevelSpell(CLASS_TYPE_DRUID, 7, 2),
   BonusLevelSpell(CLASS_TYPE_DRUID, 8, 2),
   BonusLevelSpell(CLASS_TYPE_DRUID, 9),
   Skill(SKILL_CRAFT_ARMOR, 4),
   Skill(SKILL_CRAFT_WEAPON, 4),
   Skill(SKILL_CONCENTRATION, 6),
   Skill(SKILL_ANIMAL_EMPATHY, 6),
   Skill(SKILL_SPELLCRAFT, 6),
   Regeneration(6),
   TrueSeeing(),
   Immunity(IP_CONST_IMMUNITYMISC_MINDSPELLS),
   SavingThrowVersus(IP_CONST_SAVEVS_UNIVERSAL, 3),
}
