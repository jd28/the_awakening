resref = "fab_barb_armor"

-- Properties
properties = {
   AC(8),
   Ability(ABILITY_STRENGTH, 4),
   Ability(ABILITY_CONSTITUTION, 6),

   DamageImmunity(IP_CONST_DAMAGE_DIVINE, 60),
   DamageImmunity(IP_CONST_DAMAGE_MAGICAL, 60),
   DamageImmunity(IP_CONST_DAMAGE_NEGATIVE, 60),
   DamageImmunity(IP_CONST_DAMAGE_POSITIVE, 60),
   DamageImmunity(IP_CONST_DAMAGE_BLUDGEONING, 60),
   DamageImmunity(IP_CONST_DAMAGE_PIERCING, 60),
   DamageImmunity(IP_CONST_DAMAGE_SLASHING, 60),

   DamageResistance(IP_CONST_DAMAGE_POSITIVE, RESIST_10),
   DamageResistance(IP_CONST_DAMAGE_NEGATIVE, RESIST_10),
   DamageResistance(IP_CONST_DAMAGE_DIVINE, RESIST_10),

   Immunity(IP_CONST_IMMUNITYMISC_DEATH_MAGIC),
   SavingThrowVersus(IP_CONST_SAVEVS_UNIVERSAL, 3),

   Regeneration(6),

   Skill(SKILL_TAUNT, 8),
   Skill(SKILL_PARRY, 8),
   Skill(SKILL_INTIMIDATE, 8),

   Light(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE),
}
