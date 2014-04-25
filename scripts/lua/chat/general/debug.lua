command = "debug"

function action(info)
   local pc  = info.speaker
   local act = info.param:split(' ')
   if not act then return end

   if act[1] == "resist" then
      pc:SendMessage(pc:DebugDamageResistance())
   elseif act[1] == "soak" then
      pc:SendMessage(pc:DebugDamageReduction())
   end
end
