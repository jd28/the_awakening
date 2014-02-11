local NWNXAreas = require 'solstice.nwnx.areas'

local M = {}

M.INSTANCE_LEVEL_DEFAULT = 0
M.INSTANCE_LEVEL_1       = 1
M.INSTANCE_LEVEL_2       = 2
M.INSTANCE_LEVEL_3       = 3

function M.GetIsInstanceable(transition)
   local instance_level = transition:GetLocalInt("instance_level")
   return instance_level > 0 and instance_level < 4
end

function M.CreateInstance(transition, area, level)
   local is_created = transition:GetLocalBool("instance_created_"..level)
   if is_created then return end

   local resref = area:GetResRef()
   if resref ~= "" then
      print("Instancing:", resref, level)
      local area = NWNXAreas.CreateArea(resref)
      if area:GetIsValid() then
	 area:SetLocalInt("instance_level", level)
	 area:SetLocalBool("area_no_loc_save", true)
      else
	 print("Area invalid")
      end
   end

   transition:SetLocalBool("instance_created_"..level, true)
end

function M.GetInstanceTarget(target, pc, level)
   local tag = target:GetTag()
   print(tag)
   local obj
   if level > 0 then
      local nth = 0
      
      repeat
	 obj = nwn.GetObjectByTag(tag, nth)
	 nth = nth + 1
	 if not obj:GetIsValid() then
	    break
	 end
	 local area = obj:GetArea()
	 if level == area:GetLocalInt("instance_level") then
	    break
	 end
      until false
   end
   -- Set Transition BMP
   
   if obj and obj:GetIsValid() then
      return obj
   end

   print "obj invalid"
   return target
end

return M