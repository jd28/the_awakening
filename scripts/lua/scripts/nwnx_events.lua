local NWNXEvents = require 'solstice.nwnx.events'
local C = require('ffi').C

local function destroy_object(ev)
  if Game.GetModule():GetLocalBool("SERVER_SHUTTING_DOWN") then
     return false
  end
  Game.RemoveObject(ev.object)
  return false
end
NWNXEvents.DestroyObject:register(nil, destroy_object)
