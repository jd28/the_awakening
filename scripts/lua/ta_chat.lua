local Srv = require 'ta.server'
local Chat = require 'ta.chat'

local CHAT_SYMBOL_DM = 'dm_'
local CHAT_SYMBOL_ADMIN = 'admin_'
local CHAT_SYMBOL_GENERAL = '!'

Chat.RegisterSymbol(CHAT_SYMBOL_ADMIN, "chat/admin", Srv.VerifyAdmin)
Chat.RegisterSymbol(CHAT_SYMBOL_DM, "chat/dm", Srv.VerifyDM)
Chat.RegisterSymbol(CHAT_SYMBOL_GENERAL, "chat/general")
