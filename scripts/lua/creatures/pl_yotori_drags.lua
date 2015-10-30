local baseimm = 25

Creature {
  resref = 'pl_gwasp_001',

  effects = {
    DamageResistance(DAMAGE_INDEX_SLASHING, 5),
    DamageResistance(DAMAGE_INDEX_BLUDGEONING, 5),
    DamageResistance(DAMAGE_INDEX_PIERCING, 5),

    DamageImmunity(DAMAGE_INDEX_SLASHING, 15),
    DamageImmunity(DAMAGE_INDEX_BLUDGEONING, 15),
    DamageImmunity(DAMAGE_INDEX_PIERCING, 15),
    DamageImmunity(DAMAGE_INDEX_ACID, 15),
    DamageImmunity(DAMAGE_INDEX_COLD, 15),
    DamageImmunity(DAMAGE_INDEX_FIRE, 15),
    DamageImmunity(DAMAGE_INDEX_ELECTRICAL, 15),
    DamageImmunity(DAMAGE_INDEX_SONIC, 15),
    DamageImmunity(DAMAGE_INDEX_POSITIVE, 15),
    DamageImmunity(DAMAGE_INDEX_MAGICAL, 15),
    DamageImmunity(DAMAGE_INDEX_DIVINE, 15),
    DamageImmunity(DAMAGE_INDEX_NEGATIVE, 50),

    DamageIncrease(DAMAGE_BONUS_6d10, DAMAGE_INDEX_NEGATIVE),
    DamageIncrease(DAMAGE_BONUS_6d12, DAMAGE_INDEX_ELECTRICAL),
    DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_BLUDGEONING),
    DamageIncrease(DAMAGE_BONUS_2d12, DAMAGE_INDEX_MAGICAL),

    TrueSeeing(),
    Haste(),
    Immunity(IMMUNITY_TYPE_KNOCKDOWN, 90),
   }
}

Creature {
  resref = 'pl_yotordrg_001', -- blue

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
    DamageImmunity(DAMAGE_INDEX_ELECTRICAL, 100),
    DamageImmunity(DAMAGE_INDEX_SONIC, baseimm),
    DamageImmunity(DAMAGE_INDEX_POSITIVE, baseimm),
    DamageImmunity(DAMAGE_INDEX_MAGICAL, baseimm),
    DamageImmunity(DAMAGE_INDEX_DIVINE, baseimm),
    DamageImmunity(DAMAGE_INDEX_NEGATIVE, 70),

    DamageIncrease(DAMAGE_BONUS_6d10, DAMAGE_INDEX_MAGICAL),
    DamageIncrease(DAMAGE_BONUS_6d12, DAMAGE_INDEX_ELECTRICAL),
    DamageIncrease(DAMAGE_BONUS_1d12, DAMAGE_INDEX_BLUDGEONING),
    DamageIncrease(DAMAGE_BONUS_2d12, DAMAGE_INDEX_POSITIVE),

    TrueSeeing(),
    Haste(),
    Immunity(IMMUNITY_TYPE_KNOCKDOWN, 90),
  }
}

Creature {
  resref = 'pl_yotordrg_002', -- brass

  effects = {
    Concealment(40),
    DamageResistance(DAMAGE_INDEX_SLASHING, 5),
    DamageResistance(DAMAGE_INDEX_BLUDGEONING, 5),
    DamageResistance(DAMAGE_INDEX_PIERCING, 5),
    DamageImmunity(DAMAGE_INDEX_ACID, baseimm),
    DamageImmunity(DAMAGE_INDEX_COLD, baseimm),
    DamageImmunity(DAMAGE_INDEX_FIRE, baseimm),
    DamageImmunity(DAMAGE_INDEX_ELECTRICAL, baseimm),
    DamageImmunity(DAMAGE_INDEX_SONIC, 100),
    DamageImmunity(DAMAGE_INDEX_POSITIVE, baseimm),
    DamageImmunity(DAMAGE_INDEX_MAGICAL, baseimm),
    DamageImmunity(DAMAGE_INDEX_DIVINE, baseimm),
    DamageImmunity(DAMAGE_INDEX_NEGATIVE, 70),
    DamageIncrease(DAMAGE_BONUS_6d10, DAMAGE_INDEX_MAGICAL),
    DamageIncrease(DAMAGE_BONUS_6d12, DAMAGE_INDEX_SONIC),
    DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_BLUDGEONING),
    DamageIncrease(DAMAGE_BONUS_2d12, DAMAGE_INDEX_POSITIVE),
    TrueSeeing(),
    Haste(),
    Immunity(IMMUNITY_TYPE_KNOCKDOWN, 80),
  }
}

Creature {
  resref = 'pl_yotordrg_003', -- black

  effects = {
    Concealment(40),
    DamageResistance(DAMAGE_INDEX_SLASHING, 5),
    DamageResistance(DAMAGE_INDEX_BLUDGEONING, 5),
    DamageResistance(DAMAGE_INDEX_PIERCING, 5),
    DamageImmunity(DAMAGE_INDEX_ACID, baseimm),
    DamageImmunity(DAMAGE_INDEX_COLD, 100),
    DamageImmunity(DAMAGE_INDEX_FIRE, baseimm),
    DamageImmunity(DAMAGE_INDEX_ELECTRICAL, baseimm),
    DamageImmunity(DAMAGE_INDEX_SONIC, baseimm),
    DamageImmunity(DAMAGE_INDEX_POSITIVE, baseimm),
    DamageImmunity(DAMAGE_INDEX_MAGICAL, baseimm),
    DamageImmunity(DAMAGE_INDEX_DIVINE, baseimm),
    DamageImmunity(DAMAGE_INDEX_NEGATIVE, 70),
    DamageIncrease(DAMAGE_BONUS_6d10, DAMAGE_INDEX_DIVINE),
    DamageIncrease(DAMAGE_BONUS_6d12, DAMAGE_INDEX_COLD),
    DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_BLUDGEONING),
    DamageIncrease(DAMAGE_BONUS_2d12, DAMAGE_INDEX_POSITIVE),

    TrueSeeing(),
    Haste(),
  }
}

Creature {
  resref = 'pl_yotordrg_004', -- green

  effects = {
    Concealment(30),
    DamageResistance(DAMAGE_INDEX_SLASHING, 5),
    DamageResistance(DAMAGE_INDEX_BLUDGEONING, 5),
    DamageResistance(DAMAGE_INDEX_PIERCING, 5),
    DamageImmunity(DAMAGE_INDEX_ACID, 100),
    DamageImmunity(DAMAGE_INDEX_COLD, baseimm),
    DamageImmunity(DAMAGE_INDEX_FIRE, baseimm),
    DamageImmunity(DAMAGE_INDEX_ELECTRICAL, baseimm),
    DamageImmunity(DAMAGE_INDEX_SONIC, baseimm),
    DamageImmunity(DAMAGE_INDEX_POSITIVE, baseimm),
    DamageImmunity(DAMAGE_INDEX_MAGICAL, baseimm),
    DamageImmunity(DAMAGE_INDEX_DIVINE, baseimm),
    DamageImmunity(DAMAGE_INDEX_NEGATIVE, 50),

    DamageIncrease(DAMAGE_BONUS_6d10, DAMAGE_INDEX_MAGICAL),
    DamageIncrease(DAMAGE_BONUS_6d12, DAMAGE_INDEX_ACID),
    DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_BLUDGEONING),
    DamageIncrease(DAMAGE_BONUS_2d12, DAMAGE_INDEX_POSITIVE),

    Immunity(IMMUNITY_TYPE_KNOCKDOWN, 90),
    TrueSeeing(),
    Haste(),
  }
}

Creature {
  resref = 'pl_yotori', -- Boss

  effects = {
    DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_MAGICAL),
    DamageIncrease(DAMAGE_BONUS_10d20, DAMAGE_INDEX_POSITIVE),
    DamageIncrease(DAMAGE_BONUS_4d12, DAMAGE_INDEX_SLASHING),

    DamageResistance(DAMAGE_INDEX_SLASHING, 15),
    DamageResistance(DAMAGE_INDEX_BLUDGEONING, 15),
    DamageResistance(DAMAGE_INDEX_PIERCING, 15),

    DamageImmunity(DAMAGE_INDEX_PIERCING, 50),
    DamageImmunity(DAMAGE_INDEX_SLASHING, 50),
    DamageImmunity(DAMAGE_INDEX_BLUDGEONING, 50),
    DamageImmunity(DAMAGE_INDEX_ACID, 50),
    DamageImmunity(DAMAGE_INDEX_COLD, 50),
    DamageImmunity(DAMAGE_INDEX_FIRE, 50),
    DamageImmunity(DAMAGE_INDEX_ELECTRICAL, 50),
    DamageImmunity(DAMAGE_INDEX_SONIC, 50),
    DamageImmunity(DAMAGE_INDEX_POSITIVE, 50),
    DamageImmunity(DAMAGE_INDEX_MAGICAL, 50),
    DamageImmunity(DAMAGE_INDEX_DIVINE, 50),
    DamageImmunity(DAMAGE_INDEX_NEGATIVE, 50),
    DamageReduction(8, 40),
    DamageReduction(10, 30),
    DamageReduction(15, 15),

    Immunity(IMMUNITY_TYPE_KNOCKDOWN, 100),
    Immunity(IMMUNITY_TYPE_MIND_SPELLS, 100),

    ModifyAttacks(3),
    Regenerate(100, 3),
  }
}
