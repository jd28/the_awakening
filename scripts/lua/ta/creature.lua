local ffi = require 'ffi'
local Dyn = require 'ta.dynamo'
local Eff = require 'solstice.effect'

local tinsert = table.insert

local env_mt = { __index = Dyn.Capture }
local _CREATURES = {}
local M = {}

function env_mt.Creature(tbl)
   _CREATURES[assert(tbl.resref)] = tbl
   return tbl
end

function env_mt.Copy(from, to)
   _CREATURES[to] = assert(_CREATURES[from])
end

--- Load file.
-- @param file File to load.
function M.Load(file)
   local t = setmetatable({ Creature = env_mt.Creature,
                            Copy = env_mt.Copy
                          }, env_mt)

   local res = runfile(file, t)

end

local function apply_effects(obj, effs)
   for i = 1, #effs do
      effs[i]:SetCreator(obj)
      obj:ApplyEffect(DURATION_TYPE_INNATE, effs[i])
   end
end

--- Generate creature
-- @param object Object to apply effects to.
-- @param[opt=false] max If true, the maximum value of an
-- effecy parameter.
function M.Generate(object, max)
   local resref = object:GetResRef()
   local creature = _CREATURES[resref]
   if not creature then return end
   creature = Dyn.GetPlayerTable(creature, object:GetArea():GetLocalInt('area_occupied'))
   if not creature then return end

   -- This probably could be done in a better fashion...

   local effs = {}
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
            local r = func(unpack(t))
            if type(r) == 'table' then
               for j=1, #r do tinsert(effs, r[j]) end
            else
               tinsert(effs, r)
            end
         end
      end
   end
   apply_effects(object, effs)
end

function M.Test(resref, max)
   local creature = _CREATURES[resref]
   creature = Dyn.GetPlayerTable(creature, 1)
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
