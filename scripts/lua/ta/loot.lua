local M = {}
local Dyn = require 'ta.dynamo'
local Env = require 'ta.loot_env'
local It  = require 'solstice.item'

local Log = require('ta.logger').Log

local _HOLDER = {}

--- Load item file.
-- @param file Item file to load.
function M.Load(file)
   Env.loot = setmetatable({}, { __index = Env })

   local res = runfile(file, Env.loot)
   assert(res.resref)

   _HOLDER[res.resref] = res

   encenv.enc = nil
end

function M.Run(resref, level, obj)
   res = assert(_HOLDER[resref])
   items  = Dyn.GetLevelTable(res, level)
   for _, it in ipairs(items) do
      local n = Dyn.GetValue(it.count)
      Log:debug("LootTable: Generating: %s, Count:%d ", it.resref, n)
      for i=1, n do
	 It.Generate(obj, it.resref)
      end
   end
end