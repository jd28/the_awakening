local Dyn = require 'ta.dynamo'

local E = {}

E.POLICY_NONE     = 0
E.POLICY_EACH     = 1
E.POLICY_RANDOM   = 2
E.POLICY_SPECIFIC = 3

E.enc = {}

E.Random = Dyn.Random
E.Chance = Dyn.Chance

E._HOLDER = {}

--- Load item file.
local function load(res)
   assert(res.tag)

   res.delay  = res.delay or 0.3
   res.policy = res.policy or encenv.POLICY_NONE

   E._HOLDER[res.tag] = res
end

---
function E.Spawn(resref, count, point)
   return { resref = resref,
            count  = count,
            chance = 100,
            point  = point }
end

---
function E.Encounter(tbl)
   load(tbl)
end

return E
