local M = {}
local ffi = require 'ffi'
local encenv = require 'ta.encounter_env'
local Dyn = require 'ta.dynamo'

local _HOLDER = encenv._HOLDER

--- Load item file.
-- @param file Item file to load.
function M.Load(file)
   encenv.enc = setmetatable({}, { __index = encenv })
   local res = runfile(file, encenv.enc)
   encenv.enc = nil
end

local function spawn_monster(resref, loc, enc)
   assert(enc:GetIsValid())
   local mon = Game.CreateObject(OBJECT_TYPE_CREATURE, resref, loc, false)
   assert(mon:GetIsValid())
   mon.obj.cre_encounter_obj = enc.id
   mon:SetLocalObject("ssp_encounter", enc)
end


--- Get furthest spawn point.
-- @param enc Encounter in question.
-- @param obj Object to determine distance from.
-- @param[opt] stop_at The first spawn point greater than or equal to the
-- distance `stop_at` is returned.
local function GetFurthestSpawnPoint(enc, obj, stop_at)
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
   local level_table   = Dyn.GetPlayerTable(holder, encounter:GetArea():GetLocalInt('area_occupied'))
   local spawns        = Dyn.extract(level_table, encounter)
   local policy        = holder.policy or spawns.policy
   local base_delay    = spawns.delay or holder.delay
   local fallover      = spawns.fallover or holder.fallover
   local num_spawns    = encounter:GetSpawnPointCount()
   local distance_hint = spawns.distance_hint or holder.distance_hint
   local mon_spawned   = 0
   local mod = Game.GetModule()

   local loc, spawn_point
   if policy == encenv.POLICY_RANDOM then
      spawn_point = math.random(num_spawns) - 1
      loc = encounter:GetSpawnPointByIndex(spawn_point)
   elseif policy == encenv.POLICY_NONE then
      loc, spawn_point = GetFurthestSpawnPoint(encounter, cre, distance_hint)
   end

   spawns = Dyn.flatten(spawns, encounter)

   for k = 0, num_spawns - 1 do
      if policy == encenv.POLICY_EACH then
         loc, spawn_point = encounter:GetSpawnPointByIndex(k), k
      end

      local delay = base_delay

      for _, sp in ipairs(spawns) do
         local final_point = spawn_point
         local final_loc   = loc

         if sp.point then
            spp = Dyn.GetValue(sp.point)
            local l = encounter:GetSpawnPointByIndex(spp)
            if l then
               final_point = spp
               final_loc = l
            end
         end

         for i=1, Dyn.GetValue(sp.count) do
            mod:DelayCommand(delay, function() spawn_monster(sp.resref, final_loc, encounter) end)
            delay = delay + holder.delay
            mon_spawned = mon_spawned + 1
            encounter.obj.enc_number_spawned = encounter.obj.enc_number_spawned + 1
            if fallover and mon_spawned > fallover then
               local l = encounter:GetSpawnPointByIndex(final_point + 1)
               final_loc = l or final_loc
               mon_spawned = 0
            end
         end
      end
      -- If we're not spawning at each point break
      if policy ~= encenv.POLICY_EACH then break end
   end
end

function M.Test(tag)
   local enc = _HOLDER[tag]
   if not enc then
      return string.format("ERROR: Invalid encounter tag: %s", tag)
   end

   local function out_spawn(out, v)
      if not v.chance or math.random(100) <= v.chance then
         table.insert(out, string.format("  Creature %s, Count: %d",
                                         v.resref,
                                         Dyn.GetValue(v.count)))
      end
   end

   out = {}
   table.insert(out, string.format("Tag: %s", enc.tag))
   table.insert(out, string.format("Delay: %f", enc.delay))
   table.insert(out, string.format("Policy: %d", enc.policy))
   table.insert(out, string.format("Fallover: %d", enc.fallover or -1))

   -- TODO[josh]: fix this...
--[[

   local spawns = Dyn.extract(enc.Default, OBJECT_INVALID)
   spawns = Dyn.flatten(spawns, obj)
   table.insert(out, "Spawns - Default:")
   for _, v in ipairs(spawns) do
      out_spawn(out, v)
   end

   if enc.Level1 then
      spawns = Dyn.extract(enc.Level1, OBJECT_INVALID)
      spawns = Dyn.flatten(spawns, OBJECT_INVALID)
      table.insert(out, "Spawns - Level 1:")
      for _, v in ipairs(spawns) do
         out_spawn(out, v)
      end
   end

   if enc.Level2 then
      spawns = Dyn.extract(enc.Level2, OBJECT_INVALID)
      spawns = Dyn.flatten(spawns, OBJECT_INVALID)

      table.insert(out, "Spawns - Level 2:")
      for _, v in ipairs(spawns) do
         out_spawn(out, v)
      end
   end

   if enc.Level3 then
      table.insert(out, "Spawns - Level 3:")
      spawns = Dyn.extract(enc.Level3, OBJECT_INVALID)
      spawns = buid_spawn_list(spawns, OBJECT_INVALID)

      for _, v in ipairs(spawns) do
         out_spawn(out, v)
      end
   end
]]
   return table.concat(out, '\n')

end

function M.List()
   local t = {}
   for k, _ in pairs(_HOLDER) do
      table.insert(t, k)
   end
   return table.concat(t, '\n')
end

return M
