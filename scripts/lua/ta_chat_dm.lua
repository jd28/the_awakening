local Srv  = require 'solstice.server'
local Chat = require 'solstice.chat'
local Item = require 'solstice.item'

local CHAT_SYMBOL_DM = 'dm_'

Chat.RegisterSymbol(CHAT_SYMBOL_DM, Srv.VerifyDM)

Chat.RegisterCommand(
   CHAT_SYMBOL_DM,
   "generate",
   "Generate item..",
   function(chat_info)
      local act = chat_info.param:split(' ')
      if not act then return end
      Item.Generate(chat_info.speaker, act[1])
   end)


