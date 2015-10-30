local command = "opt"
local desc = ''

local Eff = require 'solstice.effect'
local chat = require 'ta.chat'

local function action(info)
  local opt, optvar

  local pc  = info.speaker
  local act = info.param:split(' ')
  if not act then return end

  if act[1] == "dragshape" then
    if act[2] == 'kin' then
      opt, optvar = 1, "pc:dragshape"
    elseif act[2] == 'drag' then
      opt, optvar = 0, "pc:dragshape"
    end

  elseif act[1] == "helm" then
    local nval
    if act[2] == 'show' then
      nval = 0
      pc:SuccessMessage("Helmet Unhidden!")
    elseif act[2] == 'hide' then
      nval = 1
      pc:SuccessMessage("Helmet Hidden! Note: you may need to reequip for the effect to work.")
    else
      pc:ErrorMessage("Invalid option!")
      return
    end
    pc:SetLocalInt("NWNX_HELM_HIDDEN", nval)
    pc:SetPlayerInt("pc:helm", nval)
    return

  elseif act[1] == "enhanced" then
    if act[2] == 'off' then
      pc:SetPlayerInt("pc:enhanced", 0, true)
      pc:SuccessMessage("Your login is no longer flagged as being enhanced!")
      return
    elseif act[2] == 'basic' then
      pc:SetPlayerInt("pc:enhanced", 1, true)
      pc:SuccessMessage("Your login is now flagged enhanced at the basic level! Please relog to see all content.")
      return
    elseif act[2] == 'full' then
      local enhanced = pc:GetPlayerInt("pc:enhanced", true)
      pc:SetPlayerInt("pc:enhanced", 2, true)
      if enhanced <= 1 then
        pc:SuccessMessage("Your login is now flagged fully enhanced! Please relog to see all content.")
      else
        pc:SuccessMessage("Your login is now flagged with the current HAK version.")
      end
      local mod = Game.GetModule()
      pc:SetPlayerInt("pc:hak_version", mod:GetLocalInt("HAK_VERSION"), true)
      return
    end

  elseif act[1] == "appear" then
    if act [2] == 'off' then
      if pc:GetPlayerInt("pc:style_dragon") > 0
        or pc:GetPlayerInt("pc:style_undead") > 0
      then
        local race = pc:GetRacialType()
        pc:SetCreatureAppearanceType(pc:GetDefaultAppearance(race))
        pc:SuccessMessage("Appearance reverted!")
        return
      end
    end
  elseif act[1] == "anims" then
    if act [2] == 'off' then
      pc:SetPhenoType(PHENOTYPE_NORMAL)
      pc:SuccessMessage("Animations reverted!")
    end
    return
    -- todo[josh] Add anims on option.
  elseif act[1] == "noblock" then
    if act[2] == 'off' then
      opt, optvar = 0, "pc:block"
      pc:RemoveEffectsByType(EFFECT_TYPE_CUTSCENEGHOST)
      pc:SuccessMessage("You will now block on creatures!")
    elseif act[2] == 'on' then
      opt, optvar = 1, "pc:block"
      pc:RemoveEffectsByType(EFFECT_TYPE_CUTSCENEGHOST)
      pc:ApplyEffect(4, Eff.CutsceneGhost())
      pc:SuccessMessage("You will no longer block on creatures!")
    end
  end

  if opt and optvar then
    pc:SetPlayerInt(optvar, opt)
  else
    pc:ErrorMessage("Invalid option!")
  end
end

chat.RegisterCommand(CHAT_SYMBOL_GENERAL, command, action, desc)
