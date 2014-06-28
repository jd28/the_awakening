resref = "fab_druid_helm"

-- Properties
properties = {
   ArmorClass(6),
   AbilityScore(ABILITY_WISDOM, 4),
   AbilityScore(ABILITY_STRENGTH, Range(3, 5)),
   AbilityScore(ABILITY_CHARISMA, 4),
   DamageImmunity(DAMAGE_INDEX_DIVINE, 12),
   DamageImmunity(DAMAGE_INDEX_MAGICAL, 10),
   DamageImmunity(DAMAGE_INDEX_NEGATIVE, 10),
   DamageImmunity(DAMAGE_INDEX_POSITIVE, 10),
   BonusLevelSpell(CLASS_TYPE_DRUID, 6),
   BonusLevelSpell(CLASS_TYPE_DRUID, 7),
   BonusLevelSpell(CLASS_TYPE_DRUID, 8),
   BonusLevelSpell(CLASS_TYPE_DRUID, 9),
   SkillModifier(SKILL_CRAFT_ARMOR, 4),
   SkillModifier(SKILL_CRAFT_WEAPON, 4),
   SkillModifier(SKILL_CONCENTRATION, 6),
   SkillModifier(SKILL_ANIMAL_EMPATHY, 6),
   SkillModifier(SKILL_SPELLCRAFT, 6),
   Regeneration(6),
   TrueSeeing(),
   ImmunityMisc(IMMUNITY_TYPE_MIND_SPELLS),
   SavingThrowVersus(SAVING_THROW_VS_ALL, 3),
}
