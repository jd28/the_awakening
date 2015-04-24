local function innate_immunity(cre)
   local dd = cre:GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER)
   local res = 0
   if dd >= 30 then
      res = 2 + (2 * math.floor((dd - 30) / 5))
      res = math.clamp(res, 0, 10)
   end
   return res
end

Rules.SetBaseDamageImmunityOverride(
   innate_immunity,
   DAMAGE_INDEX_BLUDGEONING,
   DAMAGE_INDEX_PIERCING,
   DAMAGE_INDEX_SLASHING)
