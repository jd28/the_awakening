resref = "fab_barb_armor"

-- Properties
properties = {
   AC(8),
   Ability(CRE.ABILITY_STRENGTH, 4),
   Ability(CRE.ABILITY_CONSTITUTION, 6),

   DamageImmunity(DAMAGE.DIVINE, 60),
   DamageImmunity(DAMAGE.MAGICAL, 60),
   DamageImmunity(DAMAGE.NEGATIVE, 60),
   DamageImmunity(DAMAGE.POSITIVE, 60),
   DamageImmunity(DAMAGE.BLUDGEONING, 60),
   DamageImmunity(DAMAGE.PIERCING, 60),
   DamageImmunity(DAMAGE.SLASHING, 60),

   DamageResistance(DAMAGE.POSITIVE, RESIST_10),
   DamageResistance(DAMAGE.NEGATIVE, RESIST_10),
   DamageResistance(DAMAGE.DIVINE, RESIST_10),

   Immunity(IMMUNITYMISC_DEATH_MAGIC),
   SavingThrowVersus(SAVEVS_UNIVERSAL, 3),

   Regeneration(6),

   Skill(SKILL.TAUNT, 8),
   Skill(SKILL.PARRY, 8),
   Skill(SKILL.INTIMIDATE, 8),

   Light(LIGHTBRIGHTNESS_NORMAL, LIGHTCOLOR_WHITE),
}
