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


Creature {
   resref = 'pl_cordru_con001',

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

         DamageIncrease(DAMAGE_BONUS_6d10, DAMAGE_INDEX_MAGICAL),
         DamageIncrease(DAMAGE_BONUS_6d12, DAMAGE_INDEX_ELECTRICAL),
         DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_BLUDGEONING),

         TrueSeeing(),
         Haste(),
         Immunity(IMMUNITY_TYPE_KNOCKDOWN, 90),
         Immunity(IMMUNITY_TYPE_CRITICAL_HIT, 90),
         VisualEffect(VFX_DUR_PROT_BARKSKIN)
      }
   }
}

Creature {
   resref = 'pl_cordru_con',

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

         DamageIncrease(DAMAGE_BONUS_6d10, DAMAGE_INDEX_POSITIVE),
         DamageIncrease(DAMAGE_BONUS_6d12, DAMAGE_INDEX_SONIC),
         DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_BLUDGEONING),

         TrueSeeing(),
         Haste(),
         Immunity(IMMUNITY_TYPE_KNOCKDOWN, 70),
         Immunity(IMMUNITY_TYPE_CRITICAL_HIT, 75),
      }
   }
}

Creature {
   resref = 'pl_cordru_boss',

   Default = {
      effects = {
         Concealment(40),
         DamageResistance(DAMAGE_INDEX_SLASHING, 5),
         DamageResistance(DAMAGE_INDEX_BLUDGEONING, 5),
         DamageResistance(DAMAGE_INDEX_PIERCING, 5),
         DamageImmunity(DAMAGE_INDEX_ACID, baseimm),
         DamageImmunity(DAMAGE_INDEX_COLD, baseimm),
         DamageImmunity(DAMAGE_INDEX_FIRE, baseimm),
         DamageImmunity(DAMAGE_INDEX_ELECTRICAL, baseimm),
         DamageImmunity(DAMAGE_INDEX_SONIC, baseimm),
         DamageImmunity(DAMAGE_INDEX_POSITIVE, baseimm),
         DamageImmunity(DAMAGE_INDEX_MAGICAL, baseimm),
         DamageImmunity(DAMAGE_INDEX_DIVINE, baseimm),
         DamageImmunity(DAMAGE_INDEX_NEGATIVE, 70),
         DamageIncrease(DAMAGE_BONUS_4d10, DAMAGE_INDEX_DIVINE),
         DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_COLD),
         DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_BLUDGEONING),

         TrueSeeing(),
         Haste(),
         Immunity(IMMUNITY_TYPE_KNOCKDOWN, 80),
         Immunity(IMMUNITY_TYPE_CRITICAL_HIT, 80),
      }
   }
}

Creature {
   resref = 'pl_cordru_boss2',

   Default = {
      effects = {
         Concealment(30),
         DamageResistance(DAMAGE_INDEX_SLASHING, 5),
         DamageResistance(DAMAGE_INDEX_BLUDGEONING, 5),
         DamageResistance(DAMAGE_INDEX_PIERCING, 5),
         DamageImmunity(DAMAGE_INDEX_ACID, baseimm),
         DamageImmunity(DAMAGE_INDEX_COLD, baseimm),
         DamageImmunity(DAMAGE_INDEX_FIRE, baseimm),
         DamageImmunity(DAMAGE_INDEX_ELECTRICAL, baseimm),
         DamageImmunity(DAMAGE_INDEX_SONIC, baseimm),
         DamageImmunity(DAMAGE_INDEX_POSITIVE, baseimm),
         DamageImmunity(DAMAGE_INDEX_MAGICAL, baseimm),
         DamageImmunity(DAMAGE_INDEX_DIVINE, baseimm),
         DamageImmunity(DAMAGE_INDEX_NEGATIVE, 50),

         DamageIncrease(DAMAGE_BONUS_4d10, DAMAGE_INDEX_MAGICAL),
         DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_ACID),
         DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_BLUDGEONING),

         Immunity(IMMUNITY_TYPE_KNOCKDOWN, 80),
         Immunity(IMMUNITY_TYPE_CRITICAL_HIT, 80),
         TrueSeeing(),
         Haste(),
      }
   }
}

Creature {
   resref = 'pl_corfor_boss3', -- Boss

   Default = {
      effects = {
         DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_MAGICAL),
         DamageIncrease(DAMAGE_BONUS_10d20, DAMAGE_INDEX_DIVINE),
         DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_SLASHING),

         DamageResistance(DAMAGE_INDEX_SLASHING, 15),
         DamageResistance(DAMAGE_INDEX_BLUDGEONING, 15),
         DamageResistance(DAMAGE_INDEX_PIERCING, 15),

         DamageImmunity(DAMAGE_INDEX_PIERCING, 60),
         DamageImmunity(DAMAGE_INDEX_SLASHING, 60),
         DamageImmunity(DAMAGE_INDEX_BLUDGEONING, 60),
         DamageImmunity(DAMAGE_INDEX_ACID, 60),
         DamageImmunity(DAMAGE_INDEX_COLD, 60),
         DamageImmunity(DAMAGE_INDEX_FIRE, 60),
         DamageImmunity(DAMAGE_INDEX_ELECTRICAL, 60),
         DamageImmunity(DAMAGE_INDEX_SONIC, 60),
         DamageImmunity(DAMAGE_INDEX_POSITIVE, 60),
         DamageImmunity(DAMAGE_INDEX_MAGICAL, 60),
         DamageImmunity(DAMAGE_INDEX_DIVINE, 60),
         DamageImmunity(DAMAGE_INDEX_NEGATIVE, 60),
         DamageReduction(8, 40),
         DamageReduction(10, 30),
         DamageReduction(15, 15),

         Immunity(IMMUNITY_TYPE_KNOCKDOWN, 100),
         Immunity(IMMUNITY_TYPE_MIND_SPELLS, 100),
         Immunity(IMMUNITY_TYPE_CRITICAL_HIT, 80),

         ModifyAttacks(3),
         VisualEffect(VFX_DUR_PROT_BARKSKIN)
      }
   }
}
