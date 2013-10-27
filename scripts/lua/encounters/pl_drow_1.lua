resref   = 'pl_drow_1'
fallover = 3
delay    = 0.3
policy   = POLICY_RANDOM

Default = {
   Spawn("pl_drow_h1_matro", Random(1,3)),
   Chance(80, Spawn("pl_drow_h4_wm", 2)),
}

Level1 = {}
Level2 = {}
Level3 = {}
