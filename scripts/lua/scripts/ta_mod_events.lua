local db = System.GetDatabase()
local Log = System.GetLogger()
CDKEYS = [[
SELECT cdkeys, admin from nwn.players where admin > 0
]]

function ta_mod_load(obj)
  local stm = assert(db:prepare(CDKEYS))
  local mod = Game.GetModule()
  stm:execute()
  for row in stm:rows() do
    local keys = string.split(row[1], '-')
    local level = tonumber(row[2])
    for _, key in ipairs(keys) do
      Log:info("Adding DM/Admin key: %s at level: %d", key, level)
      mod:SetLocalInt(key, level)
    end
  end
  stm:close()
end
