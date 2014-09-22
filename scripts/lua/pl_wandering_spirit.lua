function can_use_spirit(pc, price)
   if pc:GetHitDice() < 60 then
      return false
   end

   local taken = pc:TakeItem('pl_spirit_token', price, true)
   if taken < price then
      return false
   end
   return true
end

function pl_wander_chk_et(obj)
   local pc = Game.GetPCSpeaker()
   return not pc:GetHasFeat(FEAT_EPIC_TOUGHNESS_10)
end

function pl_wander_et(obj)
   local pc = Game.GetPCSpeaker()
   local price = 2

   local epictough = pc:GetHighestFeatInRange(FEAT_EPIC_TOUGHNESS_1, FEAT_EPIC_TOUGHNESS_10)
   if epictough == FEAT_EPIC_TOUGHNESS_10 then
      obj:SpeakString("... I've done all I can ...")
      return
   end

   if not can_use_spirit(pc, price) then
      obj:SpeakString("... No, no this isn't right ...")
      return
   end

   if epictough == -1 then
      epictough = FEAT_EPIC_TOUGHNESS_1
   else
      epictough = epictough + 1
   end

   pc:AddKnownFeat(epictough, 0)
   pc:SetPlayerInt("pc_no_relevel", 1)
   pc:SuccessMessage("You have received: Epic Toughness")
end

function pl_wander_crit(obj)
   local pc = Game.GetPCSpeaker()
   local price = 10

   if not can_use_spirit(pc, price) then
      obj:SpeakString("... No, no this isn't right ...")
      return
   end

   pc:SuccessMessage("You can now use the !critical chat command!")
   pc:SetPlayerInt("pc_set_crit", 1)
end
