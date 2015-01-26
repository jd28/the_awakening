local command = 'dumpconst'
local desc = ''

local C = require('ffi').C
local fmt = string.format
local tinsert = table.insert
local tconcat = table.concat

function action(chat_info)
   local act = chat_info.param:split(' ')
   if not act then return end
   local pc = chat_info.speaker

   local t = {}
   for k, v in pairs(_CONSTS) do
      if type(v) == "string" then
         tinsert(t, fmt('%s = "%s"', k, v))
      else
         tinsert(t, fmt('%s = %s', k, tostring(v)))
      end
   end

   C.Local_NWNXLog(0, tconcat(t, '\n'))
end

local chat = require 'ta.chat'
chat.RegisterCommand(CHAT_SYMBOL_DM, command, action, desc)
