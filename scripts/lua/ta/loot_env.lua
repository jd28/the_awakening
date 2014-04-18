local Dyn = require 'ta.dynamo'

local E = {}

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

local Item = {}

function Item:N(count, rand)
   if rand then
      assert(count < rand)
      count = Dyn.Range(count, rand)
   end

   self.count = count
   return self
end

function Item:Chance(chance)
   Dyn.Chance(chance, self)
   return self
end

function E.Item(resref)
   local res = { resref = resref,
                 chance = 100 }
   setmetatable(res, { __index = Item })
   Dyn.set_base(res)
   return res
end

function E.Placeable(resref, waypoint)
   local res = { resref = resref,
                 chance = 100,
                 waypoint = waypoint,
                 count = 1 }
   Dyn.set_base(res)
   return res
end

---
function E.Loot(tbl)
   load(tbl)
end

return E
