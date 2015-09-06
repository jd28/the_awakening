local Log = System.GetLogger()
local db = System.GetDatabase()
local function GetIsTestCharacter(pc)
  return string.find(pc:GetName(), '%[TEST%]')
end

local function SetTag (pc, tag)
  pc:SetLocalString("NWNX!FUNCS!SETTAG", tag);
  return pc:GetLocalString("NWNX!FUNCS!SETTAG");
end


local function SQLEncodeSpecialChars(text)
   return string.gsub(text, "'", "~")
end

local function SQLDecodeSpecialChars(text)
   return string.gsub(text, "~", "'")
end

local UPDATE = [[UPDATE nwn.players SET last_seen=now() WHERE account=? RETURNING id]]

local INSERT = [[
  INSERT INTO nwn.players (account, cdkeys) VALUES (?, ?) RETURNING id;
]]

local INSERT_CHAR = [[
  INSERT INTO nwn.characters (name, owner, bic, version) VALUES (?, ?, ?, ?) RETURNING id;
]]

function pl_setup_pc(pc)
  if #pc:GetTag() > 0 then return end

  local bic = pc:GetBICFileName()
  local account = pc:GetPCPlayerName()
  local sanitized = SQLEncodeSpecialChars(account)
  local cdkey = pc:GetPCPublicCDKey()
  local name = pc:GetName()
  local mod = Game.GetModule()
  local pc_version = mod:GetLocalInt("TA_CURRENT_PC_VERSION")

  local player_id
  local row

  local usth = assert(db:prepare(UPDATE))
  local isth = assert(db:prepare(INSERT))
  local charsth = assert(db:prepare(INSERT_CHAR))

  local suc, err = usth:execute(sanitized)
  if not suc then
    Log:error(err)
    return
  end

  if usth:affected() == 0 then
    local suc, err = isth:execute(sanitized, cdkey)
    if not suc then
      Log:error(err)
      return
    end
    row = isth:fetch(false)
  else
    row = usth:fetch(false)
  end

  if not row then
    Log:error("Unable to fetch id for player %s (%s)", account, name)
    return
  else
    player_id = row[1]
  end

  isth:close()
  usth:close()

  suc, err = charsth:execute(SQLEncodeSpecialChars(name), player_id, bic, pc_version)
  if not suc then
    Log:error(err)
    return
  end
  row = charsth:fetch(false)
  local char_id
  if not row then
    Log:error("Unable to fetch id for character %s (%s)", account, name)
    return
  else
    char_id = row[1]
  end

  charsth:close()

  Log:info("NEW PLAYER: Name: %s, Account: %s, CDKey: %s, pid: %d, cid: %d, Bic: %s",
           name, account, cdkey, player_id, char_id, bic)

  SetTag(pc, string.format("%d_%d", player_id, char_id))

  local gold, xp;
  if GetIsTestCharacter(pc) then
      gold = 100000000;
      xp = 4800010;
  else
      gold = 10000;
      xp = 3000;
  end

  pc:GiveGold(gold, true)
  pc:SetXP(xp)

  local item = pc:GiveItem("nw_cloth022")
  pc:ForceEquip{ [INVENTORY_SLOT_CHEST] = item }
  pc:GiveItem("chatcommands")
end

function pl_enter_newpc()
  local pc = Game.GetPCSpeaker()
  pl_setup_pc(pc)
end
