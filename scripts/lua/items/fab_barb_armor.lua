resref = "fab_barb_armor"

-- Properties
properties = {
   ArmorClass(10),
   AbilityScore(ABILITY_STRENGTH, 4),
   AbilityScore(ABILITY_CONSTITUTION, 6),

   DamageImmunity(DAMAGE_INDEX_DIVINE, 10),
   DamageImmunity(DAMAGE_INDEX_MAGICAL, 10),
   DamageImmunity(DAMAGE_INDEX_NEGATIVE, 10),
   DamageImmunity(DAMAGE_INDEX_POSITIVE, 10),
   DamageImmunity(DAMAGE_INDEX_BLUDGEONING, 10),
   DamageImmunity(DAMAGE_INDEX_PIERCING, 10),
   DamageImmunity(DAMAGE_INDEX_SLASHING, 10),

   DamageResistance(DAMAGE_INDEX_POSITIVE, 10),
   DamageResistance(DAMAGE_INDEX_NEGATIVE, 10),
   DamageResistance(DAMAGE_INDEX_DIVINE, 10),

   ImmunityMisc(IMMUNITY_TYPE_DEATH),
   SavingThrowVersus(SAVING_THROW_VS_ALL, 3),

   Regeneration(6),

   SkillModifier(SKILL_TAUNT, 8),
   SkillModifier(SKILL_PARRY, 8),
   SkillModifier(SKILL_INTIMIDATE, 12),
   SkillModifier(SKILL_CRAFT_WEAPON, 12),
}
