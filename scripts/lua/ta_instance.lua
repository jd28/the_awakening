local NWNXEvents = require 'solstice.nwnx.events'
local Inst = require 'ta.instance'

function pl_inst_check()
   local pc = nwn.GetPCSpeaker()
   local trig = pc:GetLocalObject("PL_CONV_WITH")
   local node = NWNXEvents.GetCurrentNodeID()

   return node <= trig:GetLocalInt("instance_level")
end

function pl_inst_do()
   local pc = nwn.GetPCSpeaker()

   local trig = pc:GetLocalObject("PL_CONV_WITH")
   local target = trig:GetTransitionTarget()
   local tag = target:GetTag()
   local level = NWNXEvents.GetSelectedNodeID()

   if level > 0 then
      Inst.CreateInstance(trig, target:GetArea(), level)
      target = Inst.GetInstanceTarget(target, pc, level)
   end

   pc:JumpSafeToObject(target)
end
