Loot { -- Mercenary
  resref = "ms_ivre_merc",

  Players = {
    [1] = {
      Store("lt_ivre_merc") :N(1) :Chance(40),
    },
  }
}

Loot { -- Bane
  resref = "ms_ivre_bane",

  Players = {
    [1] = {
      Item("pl_ivrebane_ring"),
      Item("pl_ivrebane_dag"),
    },
  }
}

Loot { -- Borris
  resref = "ci_borrisivr",

  Players = {
    [1] = {
      Item("pl_ivrebor_rap"),
      Item("pl_ivreborr_ring"),
    },
  }
}

Loot { -- Del
  resref = "ci_delivre",

  Players = {
    [1] = {
      Item("pl_ivredel_swgrt"),
      Item("pl_ivredel_ring"),
    },
  }
}

Loot { -- Eslan
  resref = "ci_eslanivr",

  Players = {
    [1] = {
      Item("pl_ivreesla_robe"),
      Item("pl_ivreesle_ring"),
    },
  }
}

Loot { -- Yastan
  resref = "ms_ivre_yastan",

  Players = {
    [1] = {
      Item("pl_ivreyast_shlg"),
      Item("pl_ivreyast_mace"),
    },
  }
}

Loot { -- pere
  resref = "ci_undeadboss",

  Players = {
    [1] = {
      Item("pl_ivre_swdbl"),
      Item("pl_ivre_boots"),
    },
  }
}
