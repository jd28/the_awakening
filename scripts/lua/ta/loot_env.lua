local Dyn = require 'ta.dynamo'

local E = {}

E._HOLDER = {}

E.Rotate = Dyn.Rotate
E.Every = Dyn.Every
E.If = Dyn.If
E.Random = E.Random
E.Or = Dyn.Or
E.Percent = Dyn.Percent

E.LOOT_TYPE_ITEM = 0
E.LOOT_TYPE_STORE = 1

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
                 chance = 100,
                 count = 1 }
   setmetatable(res, { __index = Item })
   Dyn.set_base(res)
   res.type = E.LOOT_TYPE_ITEM
   return res
end

local Store = {}

function Store:N(count, rand)
   if rand then
      assert(count < rand)
      count = Dyn.Range(count, rand)
   end

   self.count = count
   return self
end

function Store:Chance(chance)
   Dyn.Chance(chance, self)
   return self
end

function E.Store(resref)
   local res = { resref = resref,
                 chance = 100,
                 count = 1 }
   setmetatable(res, { __index = Store })
   Dyn.set_base(res)
   res.type = E.LOOT_TYPE_STORE
   return res
end

---
function E.Loot(tbl)
   E._HOLDER[assert(tbl.resref)] = tbl
   return tbl
end

function E.Copy(resref, tbl)
   E._HOLDER[assert(resref)] = tbl
end

return E
