resref = "fab_druid_helm"

-- Properties
properties = {
   AC(6),
   Ability(ABILITY_WISDOM, 4),
   Ability(ABILITY_STRENGTH, Range(3, 5)),
   Ability(ABILITY_CHARISMA, 4),
   DamageImmunity(DAMAGE_TYPE_DIVINE, 62),
   DamageImmunity(DAMAGE_TYPE_MAGICAL, 60),
   DamageImmunity(DAMAGE_TYPE_NEGATIVE, 60),
   DamageImmunity(DAMAGE_TYPE_POSITIVE, 60),
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
   Immunity(IMMUNITY_TYPE_MIND_SPELLS),
   SavingThrowVersus(SAVING_THROW_VS_ALL, 3),
}
