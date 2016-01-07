Encounter {
  tag = 'pl_enc_yotori',
  delay = 0.1,

  -- Simple spawn set is just a array of spawns.

  [1] = {
    Spawn("pl_yotori"),
  },
}

Encounter {
  tag = 'pl_enc_gwasp',
  delay = 0.1,


  [1] = {
    Spawn("pl_gwasp_001"):N(2, 3),
  },
}

Encounter {
  tag = 'pl_enc_dkin_grp',
  delay = 0.1,


  [1] = {
    Spawn("pl_yotordrg_001"),
    Spawn("pl_yotordrg_002"),
    Spawn("pl_yotordrg_003"),
  },
}


Encounter {
  tag = 'pl_enc_dkin_brass',
  delay = 0.1,


  [1] = {
    Spawn("pl_yotordrg_002"):N(2),
  },
}

Encounter {
  tag = 'pl_enc_dkin_green',
  delay = 0.1,

  -- Simple spawn set is just a array of spawns.

  [1] = {
    Spawn("pl_yotordrg_004"):N(2),
  },
}
