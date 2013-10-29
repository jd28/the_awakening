local Item = require 'solstice.item'
local fmt = string.format

function ta_item_gen(obj)
   if not obj:GetIsValid() then return end

   local i = 1
   local var    = "GENERATE_ITEM_1"
   local resref = obj:GetLocalString(var)
   local chance = obj:GetLocalInt(var)

   while resref ~= "" and chance > 0 do
      if math.random(1, 100) <= chance then
         Item.Generate(obj, resref)
      end

      i      = i + 1
      var    = fmt("GENERATE_ITEM_%d", i)
      resref = obj:GetLocalString(var)
      chance = obj:GetLocalInt(var)
   end
end