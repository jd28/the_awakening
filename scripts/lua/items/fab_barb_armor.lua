resref = "fab_barb_armor"

-- Properties
properties = {
   ArmorClass(8),
   Ability(ABILITY_STRENGTH, 4),
   Ability(ABILITY_CONSTITUTION, 6),

   DamageImmunity(DAMAGE_INDEX_DIVINE, 60),
   DamageImmunity(DAMAGE_INDEX_MAGICAL, 60),
   DamageImmunity(DAMAGE_INDEX_NEGATIVE, 60),
   DamageImmunity(DAMAGE_INDEX_POSITIVE, 60),
   DamageImmunity(DAMAGE_INDEX_BLUDGEONING, 60),
   DamageImmunity(DAMAGE_INDEX_PIERCING, 60),
   DamageImmunity(DAMAGE_INDEX_SLASHING, 60),

   DamageResistance(DAMAGE_INDEX_POSITIVE, IP_CONST_RESIST_10),
   DamageResistance(DAMAGE_INDEX_NEGATIVE, IP_CONST_RESIST_10),
   DamageResistance(DAMAGE_INDEX_DIVINE, IP_CONST_RESIST_10),

   Immunity(IMMUNITY_TYPE_DEATH),
   SavingThrowVersus(SAVING_THROW_VS_ALL, 3),

   Regeneration(6),

   Skill(SKILL_TAUNT, 8),
   Skill(SKILL_PARRY, 8),
   Skill(SKILL_INTIMIDATE, 8),

   Light(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE),
}
