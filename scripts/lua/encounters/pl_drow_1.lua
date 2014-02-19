-- Policies:
--   POLICY_RANDOM - Unless a spawn point is set, randomly select from
--                   all spawn points.
--   POLICY_EACH   - Spawn at every spawn point.
--   POLICE_NONE   - The default if not set, selects furthest spawn point
--                   from entering object.

-- Functions:
--   Spawn(resref)
--     - Creature to spawn
--
--   If{string, spawn(set), ...}
--     - Function name, spawn(set) pairs.
--
--   Rotate{spawn(set)s, ...}
--      - Cycles through an array of spawn(set)s.
--
--   Every{number, spawn(set), ...}
--      - Spawns a spawn(set) every N activations.
--
--   Random{...}
--     - Select a spawn(set) at random.
--
--   Percent{number, spawn(set), ...}
--      - Array of percent, spawn(set) pairs.
--        The percents when summed must equal 100.


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
   delay    = 0.1,

   -- Simple spawn set is just a array of spawns.
   Default = {
      -- Spawn 1-3 drow matrons, spawn system picks the point, by the
      -- specified policy.  If no policy, spawn to furthest unseen
      Spawn("pl_drow_h1_matro"): N(1, 3),

      -- 80% chance of spawning 2 drow weapon masters at spawn point #0
      Spawn("pl_drow_h4_wm"): At(0): N(2): Chance(80),
   },

   -- Rotate through N number of spawn sets.
   Level1 = {
      Spawn("pl_drow_h1_matro"): N(1, 3),

      Rotate { Spawn("pl_drow_h1_matro"): N(1, 3),
               Spawn("pl_drow_h4_wm"): At(0): N(2): Chance(80) },

      Percent {
         10, Spawn("pl_drow_h1_matro"): N(1),
         60, Spawn("pl_drow_h1_matro"): N(2),
         30, Spawn("pl_drow_h1_matro"): N(3)
      },

      Every {
         4, Spawn("pl_drow_h1_matro"): N(24)
      }
   }
}
