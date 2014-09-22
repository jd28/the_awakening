command = "critical"
description = [[
* Usage: !critical [option]
  * Options:
    * 1: Critical Threat: 18-20, Critical Multiplier: x2
    * 2: Critical Threat: 19-20, Critical Multiplier: x3
    * 3: Critical Threat: 20, Critical Multiplier: x4
* Description: Modifies your weapons base critical hit properties.  The command will first look for a weapon in your right hand, if none it will attempt to apply to your gaunts.

* Notes:
  * Transferring the weapon will reset it to its base critical hit properties!
  * This command is purchased from the Wandering Spirit.
]]

local INVENTORY_SLOT_RIGHTHAND = INVENTORY_SLOT_RIGHTHAND
local INVENTORY_SLOT_ARMS      = INVENTORY_SLOT_ARMS
local tonumber = tonumber

function action(info)
   local pc  = info.speaker
   local act = info.param:split(' ')
   if not act then return end

   if pc:GetPlayerInt("pc_set_crit") == 0 then
      pc:ErrorMessage("You've not done what is necessary to use this command!")
      return
   end
   local item = pc:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   if not item:GetIsValid() then
      item = pc:GetItemInSlot(INVENTORY_SLOT_ARMS)
   end

   if not item:GetIsValid() then
      pc:ErrorMessage("You don't have a weapon or gaunts equipped!")
      return
   end

   local val = tonumber(act[1])
   if not val or val < 1 or val > 3 then
      pc:ErrorMessage("You need to specify what base critical type you want!")
      return
   end

   item:SetLocalInt("PL_CRIT_OVERRIDE", val)
   pc:SuccessMessage("Your weapon has been changed!")
   pc:UpdateCombatInfo(true)
end
