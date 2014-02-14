local Dyn = require 'ta.dynamo'

local E = {}

E.POLICY_NONE     = 0
E.POLICY_EACH     = 1
E.POLICY_RANDOM   = 2
E.POLICY_SPECIFIC = 3

E.enc = {}

E.Random = Dyn.Random
E.Chance = Dyn.Chance

---
function E.Spawn(resref, count, point)
   if type(count) == 'number' then
      count = E.Random(count, count)
   end
   return { resref = resref,
            count  = count,
            chance = 100,
            point  = point }
end

return E
