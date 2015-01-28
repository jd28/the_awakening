local Item = require 'ta.item'

function st_test_area(store)
   local t = {'fab_barb_armor', 'fab_druid_helm'}

   for _, v in ipairs(t) do
      if not store:HasItem(v) then
         local it = Item.Generate(store, v)
         assert(it:GetIsValid())
         it:SetInfiniteFlag(true)
      end
   end
end
