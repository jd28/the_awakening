local ffi = require 'ffi'
local C = ffi.C
local Item = require 'ta.item'
local items_dir = "lua/items/"
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

for f in lfs.dir(items_dir) do
   if string.find(f:lower(), ".lua", -4)  then
      local file = lfs.currentdir() .. "/lua/items/" .. f
      C.Local_NWNXLog(0, "Loading Item: " .. file .. "\n")
      Item.Load(file)
   end
end
