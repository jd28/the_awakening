local M = {}
local Dyn = require 'ta.dynamo'
local Env = require 'ta.loot_env'
local It  = require 'ta.item'
local St  = require 'ta.store'
local Log = System.GetLogger()

local _HOLDER = Env._HOLDER

--- Load loot file.
-- @param file loot file to load.
function M.Load(file)
   local l = setmetatable({}, { __index = Env })
   local res = runfile(file, l)
end

function M.Run(resref, level, obj)
   if not _HOLDER[resref] then return end
   local res       = _HOLDER[resref]
   local lvl_table = Dyn.GetLevelTable(res, level)
   local items     = Dyn.flatten(lvl_table)

   for _, it in ipairs(items) do
      local n = Dyn.GetValue(it.count)
      local chance = Dyn.GetValue(it.chance)
      if it.type == Env.LOOT_TYPE_ITEM then
         Log:debug("Item Loot: %s Chance: %d, Count: %d", it.resref, chance, n)
         for i=1, n do
            if chance == 100 or math.random(100) <= chance then
               It.Generate(obj, it.resref)
            end
         end
      elseif it.type == Env.LOOT_TYPE_STORE then
         Log:debug("Store Loot: %s", it.resref)
         St.GenerateLoot(obj, Game.GetObjectByTag(it.resref),
                         n, chance)
      else
         error(string.format("Unknown loot type: %d", it.type))
      end

   end
end

function M.Test(resref, level)
   level = level or 0
   local res       = assert(_HOLDER[resref])
   local lvl_table = Dyn.GetLevelTable(res, level)
   local items     = Dyn.flatten(lvl_table)

   local t = {}
   table.insert(t, string.format("LootTable: resref: %s, level: %d",
                                 resref, level))

   for _, it in ipairs(items) do
      local n = Dyn.GetValue(it.count)
      local chance = Dyn.GetValue(it.chance)
      if it.type == Env.LOOT_TYPE_ITEM then
         table.insert(t, string.format("    Item: %s, Count: %d, Chance: %d",
                                       it.resref, n, chance))
      elseif it.type == Env.LOOT_TYPE_STORE then
         table.insert(t, string.format("    Store: %s, Count: %d, Chance: %d",
                                       it.resref, n, chance))
      else
         error(string.format("Unknown loot type: %d", it.type))
      end

   end

   return table.concat(t, '\n')
end

function M.List()
   local t = {}
   for k, _ in pairs(_HOLDER) do
      table.insert(t, k)
   end
   return table.concat(t, '\n')
end

return M
