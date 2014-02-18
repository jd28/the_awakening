-- Policies:
--   POLICY_RANDOM - Unless a spawn point is set, randomly select from
--                   all spawn points.
--   POLICY_EACH   - Spawn at every spawn point.
--   POLICE_NONE   - The default if not set, selects furthest spawn point
--                   from entering object.

-- Functions:
--   Spawn(resref)       - Creature to spawn
--   If(else, ...)       - Spawns the else spawn set, unless a
--                         function/spawn set pair returns true.
--   Rotate(...)         - Cycles through spawn sets.
--   Every(default, ...) - Spawns default spawn set, unless the Nth activation
--                         is in a number/spawn set pair.
--   Random(...)         - Select a random spawn set.

-- Spawn chained functions: (They can occur in any order, but only after
-- a call to Spawn.)
--   At - Sets spawn point location.
--   N  - Sets the number of creatures to be spawned.
--   Chance - The chance that a spawn will occur (default: 100%)

-- Functions Calls:
--   Single parameter, eg. At(0) = spawns at spawn point 0
--   Two paramenters, eg. At(1, 3) = spawn point is randomly selected [1,3]
--     inclusive.
--   Table parameters, eg. At{1, 3, ...} = randomly selects spawn point from
--     the specified list.

-- Levels: Default, Level1, Level2, Level3
--   These are currently hold overs from area instancing and would depend
--   on the level of the instanced area.  CONSIDER: replacing with area
--   on enter scaling.

-- CONSIDER:
--   - Chained function: GT(n) - spawn if number of players in area is
--                               greater than n
--   - Too much repetition in spawn sets, probably.  Maybe a Clone(spawnset)
--     function?

Encounter {
   -- Encounter tag.
   tag      = 'pl_drow_1',

   -- Select a spawn point at random, save for those with spawn points
   -- specified below.
   policy   = POLICY_RANDOM,

   -- Delay between spawning creatures.  Default: 0.1 if not set.
   delay    = 0.1

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
