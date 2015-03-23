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

function pl_balor_knuckle(obj)
   local pc = Game.GetPCSpeaker()
   local taken = pc:TakeItem('nw_it_msmlmisc13', 10, true)
   if taken < 10 then
      obj:SpeakString("You do not have 10 skeleton knuckles!")
   else
      pc:SetPlayerInt('pc_balor_paid', 1)
      obj:SpeakString("Yes, yes... I will help you.")
   end
end

function pl_balor_check(obj)
   local pc = Game.GetPCSpeaker()
   return pc:GetPlayerInt('pc_balor_paid') ~= 0
end

function pl_balor_buy(obj)
   local price = 2000000
   local pc = Game.GetPCSpeaker()
   local xp = pc:GetXP()
   if xp - price < 6000000 then
      obj:SpeakString("No, mortal.  I will not sell to one with such little experience as you.")
      return
   end

   pc:SetXP(xp - price, true)
   pc:GiveItem('pl_spirit_token', 1)
   obj:SpeakString("Use its power wisely, mortal")
end

function pl_balor_trade(obj)
   local pc = Game.GetPCSpeaker()
   local count = pc:CountItem('pl_spirit_shard', true)
   if count < 20 then
      obj:SpeakString("Mortal, You do not have enough Spirit Shards!")
      return
   end

   local give = math.floor(count / 20)
   pc:TakeItem('pl_spirit_shard', give * 20, true)
   pc:GiveItem('pl_spirit_token', give)
   obj:SpeakString("Use its power wisely, mortal")
end

function pl_balor_check2(obj)
   local pc = Game.GetPCSpeaker()
   return pc:GetPlayerInt('pc_balor_paid') == 0
end
