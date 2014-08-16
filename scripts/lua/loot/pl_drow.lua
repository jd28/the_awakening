local drow_caster = Loot {
   resref = "pl_drow_h1_004",

   Default = {
      Store("lt_scrolls") :N(3) :Chance(80),
   }
}

Copy("pl_drow_005", drow_caster)
Copy("pl_drow_h1_005", drow_caster)
Copy("pl_drow_004", drow_caster)
