local ffi = require 'ffi'
local Dyn = require 'ta.dynamo'
local Eff = require 'solstice.effect'

local env_mt = { __index = Dyn.Capture }

local _CREATURES = {}
local M = {}
local pretty = require 'pl.pretty'

--- Load file.
-- @param file File to load.
function M.Load(file)
   local t = setmetatable({}, env_mt)

   local res = runfile(file, t)
   --pretty.dump(res)
   _CREATURES[assert(res.resref)] = res
end

--- Generate creature
-- @param object Object to apply effects to.
-- @param[opt=false] max If true, the maximum value of an
-- effecy parameter.
function M.Generate(object, max)
   local resref = object:GetResRef()
   local creature = _CREATURES[resref]
   if not creature then
      error("No such resref: " .. resref)
   end

   -- This probably could be done in a better fashion...

   for _, p in ipairs(creature.effects) do
      local f = p.f
      if not f then
         error "No effect function!"
      end

      local t = {}
      for _, v in ipairs(p) do
         local val = Dyn.GetValue(v, max)
         table.insert(t, val)
      end

      local count = p.n or 1
      for i = 1,count do
         if not p.chance or math.random(1, 100) <= p.chance then
            local func = Eff[f]
            if not func then
               error(string.format("No such funtion: %s\n%s", f, debug.traceback()))
            end
            object:ApplyEffect(DURATION_TYPE_INNATE, func(unpack(t)))
         end
      end
   end
end

function M.Test(resref, max)
   local creature = _CREATURES[resref]
   local ips  = Dyn.flatten(creature.effects, OBJECT_INVALID)
   local res = { "Creature: "..resref }

   for _, p in ipairs(ips) do
      local t = {}
      for _, v in ipairs(p) do
         local val = Dyn.GetValue(v, max)
         table.insert(t, val)
      end

      table.insert(res, p.f .. "(" .. table.concat(t, ', ') .. ")")
   end

   return table.concat(res, '\n')
end

return M
