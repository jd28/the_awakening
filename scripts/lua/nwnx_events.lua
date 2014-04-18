local NXEv = require 'solstice.nwnx.events'
local C = require('ffi').C

NXEv.RegisterEventHandler(
   NXEv.EVENT_TYPE_DESTROY_OBJECT,
   function (ev)
      local obj = ev.object
      _SOL_REMOVE_CACHED_OBJECT(obj.id)
      C.Local_DeleteCreature(obj.id)
      return false
   end)
