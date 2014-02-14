--- Server
-- @module server

local M = {}

--- Verify Admin
-- @param obj Object to test for admin privileges.
function M.VerifyAdmin(obj)
   local cdkey = obj:GetPCPublicCDKey()
   local mod = Game.GetModule()
   return mod:GetLocalInt("AUTH_"+cdkey) > 0
end

--- Verify DM
-- @param obj Object to test for DM privileges.
function M.VerifyDM(obj)
   local cdkey = obj:GetPCPublicCDKey()
   return mod:GetLocalInt("AUTH_"+cdkey) > 1
end

return M
