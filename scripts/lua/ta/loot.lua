local M = {}
local Dyn = require 'ta.dynamo'
local Env = require 'ta.loot_env'
local It  = require 'solstice.item'
local Log = require('ta.logger').Log

local _HOLDER = Env._HOLDER

function M.Run(resref, level, obj)
   local res       = assert(_HOLDER[resref])
   local lvl_table = Dyn.GetLevelTable(res, level)
   local items     = Dyn.flatten(lvl_table)

   for _, it in ipairs(items) do
      local n = Dyn.GetValue(it.count)
      Log:debug("LootTable: Generating: %s, Count:%d ", it.resref, n)
      for i=1, n do
         It.Generate(obj, it.resref)
      end
   end
end

function M.Test(resref, level)
   local res       = assert(_HOLDER[resref])
   local lvl_table = Dyn.GetLevelTable(res, level)
   local items     = Dyn.flatten(lvl_table)

   local t = {}
   table.insert(t, string.format("LootTable: resref: %s, level: %d",
                                 resref, level)

   for _, it in ipairs(items) do
      local n = Dyn.GetValue(it.count)
      table.insert(string.format("    Item: %s, Count:%d ",
                                 it.resref, n))
   end

   return table.concat(t, '\n')
end
