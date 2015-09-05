local NWNXHaks = require 'solstice.nwnx.haks'
local SELECT = [[SELECT enhanced from nwn.players WHERE id=?]]
local db = System.GetDatabase()
local Log = System.GetLogger()

function pl_load_enhance(pc)
  if not pc:GetIsValid() then return end
  local tag = pc:GetTag()
  if #tag == 0 then return end
  local pid, cid = string.match(tag, "(%d+)_(%d+)")
  if not pid then return end

  pc:SetLocalInt("pc_is_pc", 1)
  pc:SetLocalBool("pc_is_dm", pc:GetIsDM())
  pc:SetLocalString("pc_player_name", pc:GetPCPlayerName())

  local sth = assert(db:prepare(SELECT))
  local suc, err = sth:execute(tonumber(pid))
  if not suc then
    Log:error(err)
    return
  end

  local row = sth:fetch(false)
  if not row then return end
  NWNXHaks.SetPlayerEnhanced(pc, row[1])
  Log:debug("Player %s has enhancement: %d", pc:GetPCPlayerName(), row[1])
end
