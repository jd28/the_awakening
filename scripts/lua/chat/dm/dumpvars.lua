local command = 'dumpvars'
local desc = ''

local fmt = string.format
local tinsert = table.insert
local tconcat = table.concat

function action(chat_info)
   local act = chat_info.param:split(' ')
   if not act then return end
   local pc = chat_info.speaker

   local t = {}
   for k, v in pairs(pc:GetAllVars(act[1], act[2])) do
      tinsert(t, fmt("%s : %s", k, tostring(v)))
   end

   pc:SendMessage(tconcat(t, '\n'))
end

local chat = require 'ta.chat'
chat.RegisterCommand(CHAT_SYMBOL_DM, command, action, desc)
