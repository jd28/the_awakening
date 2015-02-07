local Log = System.GetLogger()
local Color = require 'solstice.color'

function door_attacked(door)
   local pc = door:GetLastAttacker()
   if not door:GetPlotFlag()
      or door:GetKeyRequired()
   then
      pc:FloatingText(Color.RED..'You will never bash this door open.'..Color.END, true)
      return
   end

   local dc = door:GetUnlockDC()
   local str = pc:GetAbilityScore(ABILITY_STRENGTH)
   local roll = math.random(20)

   Log:debug("Door Bash - dc: %d, strength: %d, roll: %d", dc, str, roll)

   if roll + str > dc then
      pc:FloatingText(Color.GREEN..'You have forced the door open.'..Color.END, true)
      door:PlaySound("as_sw_metalop1")
      door:ApplyVisual(VFX_IMP_DUST_EXPLOSION)
      door:SetLocked(false)
   elseif 20 + str < dc then
      pc:FloatingText(Color.RED..'You will never bash this door open.'..Color.END, true)
   else
      pc:FloatingText(Color.YELLOW..'The door creaks under the force of the blow but holds fast.'..Color.END, true)
   end
end
