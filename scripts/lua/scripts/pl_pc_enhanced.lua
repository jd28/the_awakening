local NWNXHaks = require 'solstice.nwnx.haks'
local Log = System.GetLogger()

function pl_load_enhance(pc)
  if not pc:GetIsValid() then return end

  if pc:GetPCPlayerName() == 'pope_leo' then
    NWNXHaks.SetPlayerEnhanced(pc, 2)
    return
  end

  pc:SetLocalInt("pc_is_pc", 1)
  pc:SetLocalBool("pc_is_dm", pc:GetIsDM())
  pc:SetLocalString("pc_player_name", pc:GetPCPlayerName())
  pc:SetLocalString("pc_bic_file", pc:GetBICFileName())

  local enhanced = pc:GetPlayerInt('pc:enhanced', true)
  NWNXHaks.SetPlayerEnhanced(pc, enhanced)
  Log:debug("Player %s has enhancement: %d", pc:GetPCPlayerName(), enhanced)
end
