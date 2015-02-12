local Log = System.GetLogger()

local function GetIventoryCount(store)
   if not store:GetFirstItemInInventory():GetIsValid() then
      return 0
   end
   local i = 1
   while store:GetNextItemInInventory():GetIsValid() do
      i = i + 1
   end
   return i
end

local function GetItemByIndex(store, idx)
   local it = store:GetFirstItemInInventory()
   if not it:GetIsValid() then return it end

   if idx == 1 then return it end
   for i = 1, idx do
      it = store:GetNextItemInInventory()
      if not it:GetIsValid() then return it end
   end

   return it
end

local function GenerateLoot(object, store, attempts, chance)
   local size = GetIventoryCount(store)

   Log:debug("Store: %s, Object: %s, Attempts: %d, Chance: %s, Inventory Size: %d",
             store:GetTag(), object:GetName(), attempts, chance, size)

   for i = 1, attempts do
      if math.random(100) <= chance then
         local it = GetItemByIndex(store, math.random(size))
         if it:GetIsValid() then
            it:Copy(object, true)
            it:SetIdentified(false)
         end
      end
   end
end

local M = {}
M.GenerateLoot = GenerateLoot

return M
