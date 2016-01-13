--- Determines a creatures attack bonus using a particular weapon.
-- @param cre Creature weilding weapon
-- @param weap The weapon in question.
local function GetWeaponAttackBonus(cre, weap)
  local feat = -1
  local ab = 0
  local ewf = false
  local feat_wf, feat_ewf, feat_woc = -1, -1, -1

  if not weap:GetIsValid() or Rules.GetIsUnarmedWeapon(weap) then
    feat_wf, feat_ewf, feat_woc = TA_FEAT_WEAPON_FOCUS_UNARMED,
                                  TA_FEAT_EPIC_WEAPON_FOCUS_UNARMED,
                                  TA_FEAT_WEAPON_OF_CHOICE_UNARMED
  elseif Rules.GetIsRangedWeapon(weap) then
    feat_wf, feat_ewf = TA_FEAT_WEAPON_FOCUS_RANGED,
                        TA_FEAT_EPIC_WEAPON_FOCUS_RANGED
  elseif cre:GetRelativeWeaponSize(weap) > 0 then
    feat_wf, feat_ewf, feat_woc = TA_FEAT_WEAPON_FOCUS_TWOHAND,
                                  TA_FEAT_EPIC_WEAPON_FOCUS_TWOHAND,
                                  TA_FEAT_WEAPON_OF_CHOICE_TWOHAND
  else
    feat_wf, feat_ewf, feat_woc = TA_FEAT_WEAPON_FOCUS_SINGLE,
                                  TA_FEAT_EPIC_WEAPON_FOCUS_SINGLE,
                                  TA_FEAT_WEAPON_OF_CHOICE_SINGLE
  end


  -- Epic Weapon Focus
  if feat_ewf ~= -1 and cre:GetHasFeat(feat_ewf) then
    ab = ab + 3
    ewf = true
  end

  -- Weapon Focus, included above if creature has EWF
  if not ewf and feat_wf ~= -1 and cre:GetHasFeat(feat_wf) then
    ab = ab + 1
  end

  -- WM Weapon of Choice
  local wm = cre:GetLevelByClass(CLASS_TYPE_WEAPON_MASTER)
  if wm >= 5 and feat_woc ~= -1 and cre:GetHasFeat(feat_woc) then
    ab = ab + 1
    if wm >= 13 then
      ab = ab + math.floor((wm - 10) / 3)
    end
    if wm >= 30 then
      ab = ab + 4
    elseif wm >= 29 then
      ab = ab + 2
    elseif wm >= 10 then
      ab = ab + 1
    end
  end

  local monk, lvl = Rules.CanUseClassAbilities(cre, CLASS_TYPE_MONK)
  if monk and Rules.GetIsMonkWeapon(weap, cre) then
    if cre:GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_5) then
      ab = ab + 5
    elseif cre:GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_4) then
      ab = ab + 4
    elseif cre:GetHasFeat(FEAT_KI_STRIKE_3) then
      ab = ab + 3
    elseif cre:GetHasFeat(FEAT_KI_STRIKE_2) then
      ab = ab + 2
    elseif cre:GetHasFeat(FEAT_KI_STRIKE) then
      ab = ab + 1
    end
  end

  if not weap:GetIsValid() then return ab end
  local base = weap:GetBaseType()

  -- NOTE: Derived from nwnx_weapons
  -- rogues with the Opportunist feat get to add their base int modifier
  -- to attacks with light weapons (including slings, light crossbows,
  -- and morningstars) capped by rogue level
  local rogue = cre:GetLevelByClass(CLASS_TYPE_ROGUE)
  if rogue >= 25                              and
     cre.obj.cre_stats.cs_ac_armour_base <= 3 and
     (GetIsWeaponLight(weap, cre)             or
      base == BASE_ITEM_LIGHTCROSSBOW         or
      base == BASE_ITEM_MORNINGSTAR           or
      base == BASE_ITEM_SLING)
  then
    local mx = math.min(5, math.floor((rogue - 20) / 5))
    local int = math.floor((cre:GetAbilityScore(ABILITY_INTELLIGENCE) - 10) / 2)
    int = math.clamp(int, 0, mx)
    if int > 0 and rogue >= 30 then
      int = int + 1
    end
    ab = ab + int
  end

  -- Enchant Arrow
  if base == BASE_ITEM_LONGBOW or base == BASE_ITEM_SHORTBOW then
    local aa = cre:GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER)
    if aa > 0 then
      ab = ab + 1 + math.floor(aa/2)
    end
  end

  return ab
end

local function GetWeaponPower(cre, item)
  local power = 0

  local monk, lvl = Rules.CanUseClassAbilities(cre, CLASS_TYPE_MONK)
  if monk and Rules.GetIsMonkWeapon(item, cre) then
    if cre:GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_5) then
      power = 5
    elseif cre:GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_4) then
      power = 4
    elseif cre:GetHasFeat(FEAT_KI_STRIKE_3) then
      power = 3
    elseif cre:GetHasFeat(FEAT_KI_STRIKE_2) then
      power = 2
    elseif cre:GetHasFeat(FEAT_KI_STRIKE) then
      power = 1
    end
  end

  if not item:GetIsValid() then return power end

  -- NOTE: Attack Bonus no longer affects weapon power.  This is
  -- NOT default behavior.
  for ip in item:ItemProperties() do
    if ip:GetPropertyType() == ITEM_PROPERTY_ENHANCEMENT_BONUS then
      power = math.max(power, ip:GetCostTableValue())
    end
  end

  local base = item:GetBaseType()
  -- Enchant Arrow
  if base == BASE_ITEM_LONGBOW or base == BASE_ITEM_SHORTBOW then
    local aa_level = cre:GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER)
    if aa_level > 0 then
      math.max(power, 1 + math.floor(aa_level/2))
    end
  end

  return power
end

Rules.GetWeaponAttackBonus = GetWeaponAttackBonus
Rules.GetWeaponPower = GetWeaponPower