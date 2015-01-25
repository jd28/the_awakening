local IP = require 'solstice.itemprop'

function IP.StackingDamageReduction(enhancement, soak)
   assert(enhancement >= 1 and enhancment <= 20, "Soak enhancement level must be between 1 and 20!")
   enhancement = enhancement - 1
   if OPT.CEP then
      assert(soak % 5 == 0, "The soak parameter must be a multiple of 5!")
      assert(soak >= 5 and soak <= 100)
      -- Convert the value to the constant
      soak = soak / 5
   end

   local eff = IP.CreateItempropEffect()
   eff:SetValues(TA_ITEM_PROPERTY_STACKING_DMG_REDUCTION, enhancement, 6, soak)
   return eff
end

function IP.StackingDamageResistance(damage_type, amount)
   if OPT.CEP then
      assert(amount % 5 == 0, "The resist parameter must be a multiple of 5!")
      assert(amount >= 5 and amount <= 100)
      -- Convert the value to the constant
      amount = amount / 5
   end
   local eff = IP.CreateItempropEffect()
   eff:SetValues(TA_ITEM_PROPERTY_STACKING_DMG_RESISTANCE, damage_type, 7, amount)
   return eff
end

function IP.OnHitCastSpellChance(spell, level, chance)
   local eff = CreateItempropEffect()
   eff:SetValues(TA_ITEM_PROPERTY_ONHITCASTSPELL_CHANCE, spell, 26, level, 13, chance)
   return eff
end

function IP.SpellDC(school, amount)
   local eff = IP.CreateItempropEffect()

   if amount < 0 then
      eff:SetValues(TA_ITEM_PROPERTY_SPELL_DC_PENALTY, school, 21, -amount)
   else
      eff:SetValues(TA_ITEM_PROPERTY_SPELL_DC_BONUS, school, 25, amount)
   end

   return eff
end


function IP.ImmunityModifier(imm, amount)
   local eff = IP.CreateItempropEffect()

   if amount < 0 then
      eff:SetValues(TA_ITEM_PROPERTY_IMMUNITY_MISC_PENALTY, imm, 34, -amount)
   else
      eff:SetValues(TA_ITEM_PROPERTY_IMMUNITY_MISC_BONUS, imm, 34, -amount)
   end

   return eff
end

function IP.ExperienceGain(amount)
   local eff = IP.CreateItempropEffect()

   if amount < 0 then
      eff:SetValues(TA_ITEM_PROPERTY_XP_PENALTY, nil, 34, -amount)
   else
      eff:SetValues(TA_ITEM_PROPERTY_XP_BONUS, nil, 34, amount)
   end

   return eff
end

function IP.SpellDamageBonus(school, amount)
   local eff = IP.CreateItempropEffect()

   if amount < 0 then
      eff:SetValues(TA_ITEM_PROPERTY_SPELL_DAMAGE_BONUS, school, 34, amount)
   else
      eff:SetValues(TA_ITEM_PROPERTY_SPELL_DAMAGE_PENALTY, school, 34, amount)
   end

   return eff
end

function IP.MovementSpeed(rate)
   local eff = IP.CreateItempropEffect()

   if amount < 0 then
      eff:SetValues(TA_ITEM_PROPERTY_MOVEMENT_PENALTY, nil, 34, -amount)
   else
      eff:SetValues(TA_ITEM_PROPERTY_MOVEMENT_BONUS, nil, 34, amount)
   end

   return eff
end

function IP.GoldGain(amount)
   local eff = IP.CreateItempropEffect()

   if amount < 0 then
      eff:SetValues(TA_ITEM_PROPERTY_GOLD_PENALTY, nil, 34, -amount)
   else
      eff:SetValues(TA_ITEM_PROPERTY_GOLD_BONUS, nil, 34, amount)
   end

   return eff
end

function IP.CritChance(amount)
   local eff = IP.CreateItempropEffect()

   if amount < 0 then
      eff:SetValues(TA_ITEM_PROPERTY_CRIT_THREAT_PENALTY, nil, 34, -amount)
   else
      eff:SetValues(TA_ITEM_PROPERTY_CRIT_THREAT_BONUS, nil, 34, amount)
   end

   return eff
end

function IP.CritDamage(amount)
   local eff = IP.CreateItempropEffect()

   if amount < 0 then
      eff:SetValues(TA_ITEM_PROPERTY_CRIT_DMG_PENALTY, nil, 34, -amount)
   else
      eff:SetValues(TA_ITEM_PROPERTY_CRIT_DMG_BONUS, nil, 34, amount)
   end

   return eff
end

function IP.DamagePercent(amount)
   local eff = IP.CreateItempropEffect()

   if amount < 0 then
      eff:SetValues(TA_ITEM_PROPERTY_DMG_PERCENT_PENALTY, nil, 34, -amount)
   else
      eff:SetValues(TA_ITEM_PROPERTY_DMG_PERCENT_BONUS, nil, 34, amount)
   end

   return eff
end

function IP.UseLimitClassLevel(class, level)
   local eff = IP.CreateItempropEffect()
   eff:SetValues(TA_ITEM_PROPERTY_USE_LIMITATION_CLASS_LEVEL, class, 35, level)
   return eff
end

function IP.UseLimitAbilityLevel(ability, level)
   local eff = IP.CreateItempropEffect()
   eff:SetValues(TA_ITEM_PROPERTY_USE_LIMITATION_ABILITY, ability, 36, level)
   return eff
end
