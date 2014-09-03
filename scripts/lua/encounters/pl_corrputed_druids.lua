Encounter {
   tag      = 'pl_enc_cordru_grp',
   delay    = 0.1,
   Default = {
      Spawn("pl_cordruid_001"),
      Spawn("pl_corshift_001") :N(1, 2),
      Spawn("pl_corrang_001"),
   },
}

Encounter {
   tag      = 'pl_enc_cordru_rng',
   delay    = 0.1,

   policy   = POLICY_RANDOM,

   Default = {
      Spawn("pl_corrang_001") :N(2, 3),
   },
}

Encounter {
   tag      = 'pl_enc_cordru_dru',
   delay    = 0.1,

   policy   = POLICY_RANDOM,

   Default = {
      Spawn("pl_cordruid_001") :N(1, 2),
   },
}

Encounter {
   tag      = 'pl_enc_cordru_shi',
   delay    = 0.1,

   policy   = POLICY_RANDOM,

   Default = {
      Spawn("pl_corshift_001") :N(1, 3),
   },
}
