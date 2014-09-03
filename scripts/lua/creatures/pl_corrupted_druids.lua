local baseimm = 25

Creature {
   resref = 'pl_cordruid_001',

   Default = {
      effects = {
         Concealment(40),

         DamageResistance(DAMAGE_INDEX_SLASHING, 5),
         DamageResistance(DAMAGE_INDEX_BLUDGEONING, 5),
         DamageResistance(DAMAGE_INDEX_PIERCING, 5),

         DamageImmunity(DAMAGE_INDEX_SLASHING, baseimm),
         DamageImmunity(DAMAGE_INDEX_BLUDGEONING, baseimm),
         DamageImmunity(DAMAGE_INDEX_PIERCING, baseimm),
         DamageImmunity(DAMAGE_INDEX_ACID, baseimm),
         DamageImmunity(DAMAGE_INDEX_COLD, baseimm),
         DamageImmunity(DAMAGE_INDEX_FIRE, baseimm),
         DamageImmunity(DAMAGE_INDEX_ELECTRICAL, baseimm),
         DamageImmunity(DAMAGE_INDEX_SONIC, baseimm),
         DamageImmunity(DAMAGE_INDEX_POSITIVE, baseimm),
         DamageImmunity(DAMAGE_INDEX_MAGICAL, baseimm),
         DamageImmunity(DAMAGE_INDEX_DIVINE, baseimm),
         DamageImmunity(DAMAGE_INDEX_NEGATIVE, 50),

         DamageIncrease(DAMAGE_BONUS_6d10, DAMAGE_INDEX_NEGATIVE),
         DamageIncrease(DAMAGE_BONUS_6d12, DAMAGE_INDEX_ELECTRICAL),
         DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_BLUDGEONING),

         TrueSeeing(),
         Haste(),
         Immunity(IMMUNITY_TYPE_KNOCKDOWN, 50),
      }
   }
}

Creature {
   resref = 'pl_corshift_001',

   Default = {
      effects = {
         Concealment(40),

         DamageResistance(DAMAGE_INDEX_SLASHING, 5),
         DamageResistance(DAMAGE_INDEX_BLUDGEONING, 5),
         DamageResistance(DAMAGE_INDEX_PIERCING, 5),

         DamageImmunity(DAMAGE_INDEX_SLASHING, baseimm),
         DamageImmunity(DAMAGE_INDEX_BLUDGEONING, baseimm),
         DamageImmunity(DAMAGE_INDEX_PIERCING, baseimm),
         DamageImmunity(DAMAGE_INDEX_ACID, baseimm),
         DamageImmunity(DAMAGE_INDEX_COLD, baseimm),
         DamageImmunity(DAMAGE_INDEX_FIRE, baseimm),
         DamageImmunity(DAMAGE_INDEX_ELECTRICAL, baseimm),
         DamageImmunity(DAMAGE_INDEX_SONIC, baseimm),
         DamageImmunity(DAMAGE_INDEX_POSITIVE, baseimm),
         DamageImmunity(DAMAGE_INDEX_MAGICAL, baseimm),
         DamageImmunity(DAMAGE_INDEX_DIVINE, baseimm),
         DamageImmunity(DAMAGE_INDEX_NEGATIVE, 50),

         -- Has damage on weapons.

         TrueSeeing(),
         Haste(),
         Immunity(IMMUNITY_TYPE_KNOCKDOWN, 75),
      }
   }
}
