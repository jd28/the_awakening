local DynConvo = require 'ta.dynconvo'
local NWNXEv = require 'solstice.nwnx.events'

function dnyc_dlg_prompt()
   local obj = Game.GetPCSpeaker()
   local conv = DynConvo.GetActiveConversation(obj)
   if conv.finished or conv.aborted or conv.ended then
      return false
   end
   return conv:SetCurrentPrompt()
end

function dnyc_dlg_check()
   local obj = Game.GetPCSpeaker()
   local conv = DynConvo.GetActiveConversation(obj)
   if conv.finished or conv.aborted or conv.ended then
      return false
   end
   return conv:SetCurrentNodeText()
end

function dync_dlg_do()
   local obj  = Game.GetPCSpeaker()
   local conv = DynConvo.GetActiveConversation(obj)
   local node = NWNXEv.GetSelectedNodeID()
   conv:Select(node)
end

function dync_dlg_abort()
   local obj = Game.GetPCSpeaker()
   local conv = DynConvo.GetActiveConversation(obj)
   conv:Abort(obj)
end

function dync_dlg_end()
   local obj = Game.GetPCSpeaker()
   local conv = DynConvo.GetActiveConversation(obj)
   conv:Finish(obj)
end
