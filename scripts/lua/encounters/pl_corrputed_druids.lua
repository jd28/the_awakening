Encounter {
  tag = 'pl_enc_cordru_grp',
  delay = 0.1,

  Players = {
    [1] = {
      Spawn("pl_cordruid_001"),
      Spawn("pl_corshift_001") :N(1, 2),
      Spawn("pl_corrang_001"),
    },
  },
}

Encounter {
  tag = 'pl_enc_cordru_rng',
  delay = 0.1,

  policy  = POLICY_RANDOM,

  Players = {
    [1] = {
      Spawn("pl_corrang_001") :N(2, 3),
    },
  },
}

Encounter {
  tag = 'pl_enc_cordru_dru',
  delay = 0.1,

  policy  = POLICY_RANDOM,

  Players = {
    [1] = {
      Spawn("pl_cordruid_001") :N(1, 2),
    },
  },
}

Encounter {
  tag = 'pl_enc_cordru_shi',
  delay = 0.1,

  policy  = POLICY_RANDOM,

  Players = {
    [1] = {
      Spawn("pl_corshift_001") :N(1, 3),
    },
  },
}

Encounter {
  tag = 'pl_enc_cordru_blk',
  delay = 0.1,
  Players = {
    [1] = {
      Spawn("pl_cordru_boss"),
      Spawn("pl_cordru_boss2") :N(1, 2),
    },
  },
}


Encounter {
  tag = 'pl_enc_cordru_gol',
  delay = 0.1,

  policy  = POLICY_RANDOM,

  Players = {
    [1] = {
      Spawn("pl_cordru_con001") :N(1, 3),
    },
  },
}

Encounter {
  tag = 'pl_enc_cordru_thorn',
  delay = 0.1,

  policy  = POLICY_RANDOM,

  Players = {
    [1] = {
      Spawn("pl_cordru_con") :N(2, 3),
    },
  },
}

Encounter {
  tag = 'pl_enc_cordru_boss',
  delay = 0.1,

  Players = {
    [1] = {
      Spawn("pl_corfor_boss3"),
    },
  },
}
