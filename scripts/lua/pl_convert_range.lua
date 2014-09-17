function pl_convert_range(obj)
   local pc = Game.GetPCSpeaker()
   local price = 5000000
   if not pc:GetIsValid() then
      obj:SpeakString("There's been an error, contact a DM")
      return
   end

   local rh = pc:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   if not rh:GetIsValid() then
      obj:SpeakString("You don't have a bow equipped!")
      return
   end

   local gold = pc:GetGold()
   if gold < price then
      obj:SpeakString(string.format("You do not have %d gold!", price))
      return
   end

   if rh:GetBaseType() == BASE_ITEM_LONGBOW then
      rh.obj.it_baseitem = BASE_ITEM_SHORTBOW
      pc:TakeGold(price, true)
   elseif rh:GetBaseType() == BASE_ITEM_SHORTBOW then
      rh.obj.it_baseitem = BASE_ITEM_LONGBOW
      pc:TakeGold(price, true)
   else
      obj:SpeakString("You do not have a bow equipped!")
   end
end
