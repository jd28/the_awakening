local chat = require 'ta.chat'
local fmt = string.format

local command = "wallet"
local desc = ''

local function IsTestCharacter(pc)
   return string.find(pc:GetName(), '%[TEST%]')
end

local function action(info)
   local pc  = info.speaker
   local act = info.param:split(' ')
   if not act then return end

   if IsTestCharacter(pc) then
      pc:ErrorMessage 'You are unable to use this command on test characters!'
      return
   end

   if act[1] == "balance" then
      pc:SendServerMessage(fmt("Your current balance is %d", pc:GetPlayerInt("pc:gold", true)))
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

      local bal = pc:GetPlayerInt("pc:gold", true) + amt
      pc:TakeGold(amt, false)
      pc:SetPlayerInt("pc:gold", bal, true)
      pc:SendServerMessage(fmt("Your current balance is %d", bal))
   elseif act[1] == "withdraw" then
      local amt = tonumber(act[2])
      if not amt then
         pc:SendMessage("Invalid Amount!")
         return
      end
      local bal = pc:GetPlayerInt("pc:gold", true) + amt
      if bal < amt then
         pc:SendServerMessage(fmt("You only have %d in your wallet!", bal))
         return
      end
      bal = bal - amt
      pc:SetPlayerInt("pc:gold", bal, true)
      pc:SendServerMessage(fmt("Your current balance is %d", bal))
      pc:GiveGold(amt, false)
   end
end

chat.RegisterCommand(CHAT_SYMBOL_GENERAL, command, action, desc)
