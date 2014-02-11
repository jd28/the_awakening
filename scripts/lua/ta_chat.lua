local Srv = require 'solstice.server'
local Chat = require 'solstice.chat'

local CHAT_SYMBOL_DM = 'dm_'
local CHAT_SYMBOL_ADMIN = 'admin_'

Chat.RegisterSymbol(CHAT_SYMBOL_ADMIN, "chat/admin", Srv.VerifyAdmin)
Chat.RegisterSymbol(CHAT_SYMBOL_DM, "chat/dm", Srv.VerifyDM)