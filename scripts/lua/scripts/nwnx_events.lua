local NXEv = require 'solstice.nwnx.events'
local C = require('ffi').C

NXEv.RegisterEventHandler(
   NXEv.EVENT_TYPE_DESTROY_OBJECT,
   function (ev)
      if Game.GetModule():GetLocalBool("SERVER_SHUTTING_DOWN") then
         return false
      end
      Game.RemoveObject(ev.object)
      return false
   end)
