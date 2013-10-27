local ffi = require 'ffi'

ffi.cdef [[
typedef struct {
   int32_t start;
   int32_t stop;
} Range;

typedef struct {
   const char* resref;
   Range count;
   int32_t chance;
   int32_t point;
} SSP_Spawn;
]]

local ssp_spawn_t = ffi.typeof("SSP_Spawn")
local range_t = ffi.typeof("Range")

local E = {}

E.POLICY_NONE     = 0
E.POLICY_EACH     = 1
E.POLICY_RANDOM   = 2
E.POLICY_SPECIFIC = 3

E.enc = {}

--- Creates random item property value
-- @see math.random
function E.Random(start, stop)
   return range_t(start, stop)
end

---
function E.Chance(perc, spawn)
   spawn.chance = perc
   return spawn
end

---
function E.Spawn(resref, count, point)
   if type(count) == 'number' then
      count = range_t(count, count)
   end
   return { resref = resref,
	    count  = count,
	    chance = 100,
	    point  = point or -1 }
end

return E
