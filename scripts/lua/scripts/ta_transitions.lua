local Log = System.GetLogger()
local Inst = require 'ta.instance'
local Color = require 'solstice.color'

local function check_transition(trans, pc, tar_area)
  -- DMs can go anyhwere...
  if pc:GetIsDM() or pc:GetIsDMPossessed() then return true end

  local jump = true
  local area = pc:GetArea()
  local key  = trans:GetLocalString("KeyTag")
  local spawn = trans:GetLocalBool("CheckSpawn")
  local despawn = trans:GetLocalBool("CheckDespawn")
  local env = trans:GetLocalBool("CheckEnv")
  local level = trans:GetLocalInt("Level")
  local despawn_time = area:GetLocalInt("DespawnTime")

  Log:debug([[Check Transitions:
  Area: %s
  Key: %s
  Spawn: %s
  Despawn: %s
  Despawn Time: %d
  Environment: %s
  Level: %d]],
  tar_area:GetName(), key, tostring(spawn), tostring(despawn), despawn_time, tostring(env), level)

  if level > 0 and pc:GetHitDice() < level then
    pc:FloatingText(string.format("%sYou must be at least level %d to use this transition.%s",
                        Color.RED, level, Color.END))
    return false
  end

   return jump
end

function nw_g0_transition(trans)
  local pc = Game.GetClickingObject()
  if not pc:GetIsValid() then
    error("Invalid PC")
  end

  -- Don't allow plot NPC's to transition
  if not pc:GetIsPC() and pc:GetPlotFlag() then return end

  local target = trans:GetTransitionTarget()
  if not target:GetIsValid() then
    Log:error("Inavlid target: Area %s Trigger: %s", pc:GetArea():GetResRef(), trans:GetTag())
    return
  end

  local tar_area = target:GetArea()
  if not check_transition(trans, pc, tar_area) then
    Log:debug("Unable to transition: Area %s Trigger: %s", pc:GetArea():GetResRef(), trans:GetTag())
    return
  end

  if tar_area:GetLocalInt("area_requires_haks") > 0
    and pc:GetPlayerInt("pc_enhanced") <= 1
  then
    pc:ErrorMessage "You do not have the required hak files to enter this area!"
    return
  end

  local cur_area = pc:GetArea()
  local tag = target:GetTag()

   pc:JumpSafeToObject(target)
end
