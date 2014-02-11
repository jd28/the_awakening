local M = {}
local ffi = require 'ffi'
local Obj = require 'solstice.object'
local encenv = require 'ta.encounter_env'
local Dyn = require 'ta.dynamo'

local _HOLDER = {}

--- Load item file.
-- @param file Item file to load.
function M.Load(file)
   encenv.enc = setmetatable({}, { __index = encenv })

   local res = runfile(file, encenv.enc)
   assert(res.resref)

   res.delay  = res.delay or 0.3
   res.policy = res.policy or encenv.POLICY_NONE

   _HOLDER[res.resref] = res

   encenv.enc = nil
   return res.resref
end



local function spawn_monster(resref, loc, enc)
   assert(enc:GetIsValid())
   local mon = Obj.Create(Obj.CREATURE, resref, loc, false, "Spawned")
   assert(mon:GetIsValid())
   mon.obj.cre_encounter_obj = enc.id
   mon:SetLocalObject("ssp_encounter", enc)
end


--- Get furthest spawn point.
-- @param enc Encounter in question.
-- @param obj Object to determine distance from.
-- @param[opt] stop_at The first spawn point greater than or equal to the
-- distance `stop_at` is returned.
function GetFurthestSpawnPoint(enc, obj, stop_at)
   local idx, loc, dist, tdist

   for i=0, enc:GetSpawnPointCount() - 1 do
      local sp = enc:GetSpawnPointByIndex(i)
      tdist = sp:GetDistanceBetween(obj:GetLocation())
      if not dist or tdist > dist then
         dist, loc, idx = tdist, sp, i
         if stop_at and dist >= stop_at then break end
      end
   end

   return loc, idx
end

function M.Spawn(encounter, level, cre)
   local holder        = assert(_HOLDER[encounter:GetTag()])
   local spawns        = Dyn.GetLevelTable(holder, level)
   local policy        = holder.policy or spawns.policy
   local base_delay    = spawns.delay or holder.delay
   local fallover      = spawns.fallover or holder.fallover
   local num_spawns    = encounter:GetSpawnPointCount()
   local distance_hint = spawns.distance_hint or holder.distance_hint
   local mon_spawned   = 0

   for k = 0, num_spawns - 1 do
      local loc, spawn_point

      if policy == encenv.POLICY_EACH then
         loc, spawn_point = encounter:GetSpawnPointByIndex(k), k
      elseif policy == encenv.POLICY_RANDOM then
         spawn_point = math.random(num_spawns) - 1
         loc = encounter:GetSpawnPointByIndex(spawn_point)
      elseif policy == encenv.POLICY_NONE then
         loc, spawn_point = GetFurthestSpawnPoint(encounter, cre, distance_hint)
      end


      local delay = base_delay
      for _, sp in ipairs(spawns) do
         if policy == encenv.POLICY_SPECIFIC then
            spawn_point = sp.point
            loc = encounter:GetSpawnPointByIndex(spawn_point)
         end
         if sp.chance >= math.random(100) then
            for i=1, Dyn.GetValue(sp.count) do
               encounter:DelayCommand(delay, spawn_monster(sp.resref, loc, encounter))
               delay = delay + holder.delay
               mon_spawned = mon_spawned + 1
               encounter.obj.enc_number_spawned = encounter.obj.enc_number_spawned + 1
               if fallover and mon_spawned > fallover then
                  local l = encounter:GetSpawnPointByIndex(spawn_point + 1)
                  loc = l or loc
                  mon_spawned = 0
               end
            end
         end
      end
      -- If we're not spawning at each point break
      if policy ~= encenv.POLICY_EACH then break end
   end

   encounter:SetLocalInt("ssp_spawned", true)
end

function M.Test(resref)
   local enc = _HOLDER[resref]
   assert(enc)

   local function out_spawn(out, v)
      local chance  = math.random(100)
      if v.chance then
         print (chance)
      end

      if not v.chance or chance <= v.chance then
         table.insert(out, string.format("  Creature %s, Count: %d",
                                         ffi.string(v.resref),
                                         Dyn.GetValue(v.count)))
      end
   end

   out = {}
   table.insert(out, string.format("Resref: %s", enc.resref))
   table.insert(out, string.format("Delay: %f", enc.delay))
   table.insert(out, string.format("Policy: %d", enc.policy))
   table.insert(out, string.format("Fallover: %d", enc.fallover or -1))
   table.insert(out, "Spawns - Default:")
   for _, v in ipairs(enc.Default) do
      out_spawn(out, v)
   end

   if enc.Level1 then
      table.insert(out, "Spawns - Level 1:")
      for _, v in ipairs(enc.Level1) do
         out_spawn(out, v)
      end
   end

   if enc.Level2 then
      table.insert(out, "Spawns - Level 2:")
      for _, v in ipairs(enc.Level2) do
         out_spawn(out, v)
      end
   end

   if enc.Level3 then
      table.insert(out, "Spawns - Level 3:")
      for _, v in ipairs(enc.Level3) do
         out_spawn(out, v)
      end
   end

   return table.concat(out, '\n')

end

return M