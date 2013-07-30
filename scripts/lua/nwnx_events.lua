local NXEv = require 'solstice.nwnx.events'

NXEv.RegisterEventHandler(
   NXEv.EVENT_TYPE_DESTROY_OBJECT,
   function (ev)
      local obj = ev.object
      _SOL_REMOVE_CACHED_OBJECT(obj.id)
      return false
   end)
   
