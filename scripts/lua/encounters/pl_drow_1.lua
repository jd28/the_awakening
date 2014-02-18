Encounter {
   -- Encounter tag.
   tag      = 'pl_drow_1',

   -- Select a spawn point at random, save for those with spawn points
   -- specified below.
   policy   = POLICY_RANDOM,

   -- Simple spawn set is just a array of spawns.
   Default = {
      -- Spawn 1-3 drow matrons, spawn system picks the point, by the
      -- specified policy.  If no policy, spawn to furthest unseen
      Spawn("pl_drow_h1_matro"): N(1, 3),

      -- 80% chance of spawning 2 drow weapon masters at spawn point #0
      Spawn("pl_drow_h4_wm"): At(0): N(2): Chance(80),
   },

   -- Rotate through N number of spawn sets.
   Level1 = Rotate(
     { Spawn("pl_drow_h1_matro"): N(1, 3),
       Spawn("pl_drow_h4_wm"): At(0): N(2): Chance(80) },

     { Spawn("pl_drow_h1_matro"): N(1, 2),
       Spawn("pl_drow_h4_wm"): At(0): N(4): Chance(80) }),


   Level2 = Every(
      -- Default spawn set, spawn 1 OR 3 matrons at policy spawn point
      -- 80% chance to spawn 2 wm at spawn point 0 OR 2
      { Spawn("pl_drow_h1_matro"): N{1, 3},
        Spawn("pl_drow_h4_wm"): At{0, 2}: N(2): Chance(80) },

      -- Every fourth trigger, do differently
      4, { Spawn("pl_drow_h1_matro"): N(1),
           Spawn("pl_drow_h4_wm"): At(0): N(2): Chance(80) }),

   Level3 = If(
      -- Default spawn set (the else clause, basically, spawn 1 OR 3
      -- matrons at policy spawn point 80% chance to spawn
      { Spawn("pl_drow_h1_matro"): N{1, 3},
        Spawn("pl_drow_h4_wm"): At{0, 2}: N(2): Chance(80) },

      -- Order dependent, first true wins
      -- calls some_function_that_returns_true_or_false(oEncounter)
      "some_function_that_returns_true_or_false",
      { Spawn("pl_drow_h1_matro"): N(1),
        Spawn("pl_drow_h4_wm"): At(0): N(2): Chance(80) },

      -- calls another_function_that_returns_true_or_false(oEncounter)
      "another_function_that_returns_true_or_false",
      { Spawn("pl_drow_h1_matro"): N(1),
        Spawn("pl_drow_h4_wm"): At(0): N(2): Chance(80) }),
}
