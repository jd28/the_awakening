local Dyn = require 'ta.dynamo'

local E = {}

E.POLICY_NONE     = 0
E.POLICY_EACH     = 1
E.POLICY_RANDOM   = 2

E._HOLDER = {}

E.Rotate = Dyn.Rotate
E.Every = Dyn.Every
E.If = Dyn.If
E.Random = E.Random
E.Or = Dyn.Or
E.Percent = Dyn.Percent

--- Load item file.
local function load(res)
   assert(res.tag)

   res.delay  = res.delay or 0.1
   res.policy = res.policy or encenv.POLICY_NONE

   E._HOLDER[res.tag] = res
end

local Spawn = {}

function Spawn:At(point, rand)
   if rand then
      assert(point < rand)
      point = Dyn.Range(point, rand)
   end
   self.point = point
   return self
end

function Spawn:N(count, rand)
   if rand then
      assert(count < rand)
      count = Dyn.Range(count, rand)
   end

   self.count = count
   return self
end

function Spawn:Chance(chance)
   Dyn.Chance(chance, self)
   return self
end

---
function E.Spawn(resref, count)
   local res = { spawn = true,
                 resref = resref,
                 chance = 100 }
   setmetatable(res, { __index = Spawn })
   return res
end

---
function E.Encounter(tbl)
   load(tbl)
end

return E
