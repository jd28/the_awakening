local NWNXDb = require 'solstice.nwnx.database'
local fmt = string.format
local print = print
local tonumber = tonumber

command = "wallet"

function action(info)
   local pc  = info.speaker
   local act = info.param:split(' ')
   if not act then return end

   if act[1] == "balance" then
      pc:SendServerMessage(fmt("Your current balance is %d", NWNXDb.GetInt(pc, "UPB_GOLD", true)))
   elseif act[1] == "deposit" then
      local amt = tonumber(act[2])
      if not amt then
         pc:SendServerMessage("Invalid Amount!")
         return
      end

      if amt > pc:GetGold() then
         pc:SendServerMessage(fmt("You only have %d!", pc:GetGold()))
         return
      end


      local bal = NWNXDb.GetInt(pc, "UPB_GOLD", true) + amt
      pc:TakeGold(amt, false)
      NWNXDb.SetInt(pc, "UPB_GOLD", bal, 0, true)
      pc:SendServerMessage(fmt("Your current balance is %d", bal))
   elseif act[1] == "withdraw" then
      local amt = tonumber(act[2])
      if not amt then
         pc:SendMessage("Invalid Amount!")
         return
      end
      local bal = NWNXDb.GetInt(pc, "UPB_GOLD", true)
      if bal < amt then
         pc:SendServerMessage(fmt("You only have %d in your wallet!", bal))
         return
      end
      bal = bal - amt
      NWNXDb.SetInt(pc, "UPB_GOLD", bal, 0, true)
      pc:SendServerMessage(fmt("Your current balance is %d", bal))
      pc:GiveGold(amt, false)
   end
end
