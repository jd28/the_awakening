local Dyn = require 'ta.dynamo'

local E = {}

E.Random = Dyn.Random
E.Chance = Dyn.Chance

E.loot = {}

function E.Generate(resref, count)
   if type(count) == 'number' then
      count = Dyn.range_t(count, count)
   end
   return { resref = resref,
	    count  = count }
end

return E