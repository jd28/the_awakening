local function clear_cache()
  ffi.fill(obj.ci.dr.immunity, 4 * DAMAGE_INDEX_NUM)
  ffi.fill(obj.ci.defense.immunity_misc, 4 * IMMUNITY_TYPE_NUM)
  obj.ci.hp_eff = 0
  if OPT.TA then
    obj:SetLocalInt("gsp_mod_dc", 0)
    obj.ta_move_speed = 0
  end
end

Game.OnClearCreatureCache:register(nil, clear_cache)