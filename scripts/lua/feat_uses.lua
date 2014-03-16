local TDA = require 'solstice.2da'

local function infinite() return 100 end
local function one() return 1 end
local function none() return 0 end

Rules.RegisterFeatUses(
   function (feat, cre)
      return 1 + cre:GetLevelByClass(CLASS_TYPE_BARBARIAN)
   end,
   293)

local function bard_song(feat, cre)
   local level = cre:GetLevelByClass(CLASS_TYPE_BARD)
   local uses = level

   if cre:GetHasFeat(FEAT_EXTRA_MUSIC) then
      uses = uses + (level > 6 and uses / 6 or 1)
   end

   return uses
end

Rules.RegisterFeatUses(bard_song, 257)
-- This is because Bioware decided to make a bunch of (pointless)
-- extra bard song feats.
for i = 355, 373 do
   Rules.RegisterFeatUses(bard_song, i)
end

Rules.RegisterFeatUses(
   function(feat, cre)
      if cre:GetLevelByClass(CLASS_TYPE_BLACKGUARD) >= 45 or
         cre:GetLevelByClass(CLASS_TYPE_ASSASSIN) >= 45
      then return 2
      else return 1
      end
   end,
   FEAT_CONTAGION)

Rules.RegisterFeatUses(
   function(feat, cre)
      local uses = 1
      local l = cre:GetLevelByClass(CLASS_TYPE_DIVINE_CHAMPION)
      if l >= 40 then
         uses = 4
      elseif l >= 30 then
         uses = 3
      elseif l >= 20 then
         uses = 2
      end
      return uses
   end,
   FEAT_DIVINE_WRATH)

Rules.RegisterFeatUses(
   function(feat, cre)
      return 3 + (cre:GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE) / 10)
   end,
   FEAT_DRAGON_DIS_BREATH)

Rules.RegisterFeatUses(
   function(feat, cre)
      local uses = (cre:GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER) - 1) / 2
      return 1 + uses
   end,
   FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE)

Rules.RegisterFeatUses(none, FEAT_KI_DAMAGE)

Rules.RegisterFeatUses(one,
                       FEAT_HARPER_CATS_GRACE,
                       FEAT_HARPER_EAGLES_SPLENDOR,
                       FEAT_HARPER_SLEEP)

local function harper(feat, cre)
   local level = cre:GetLevelByClass(CLASS_TYPE_HARPER)
   local uses = 1
   if level >= 45 then
      uses = 3
   elseif level >= 20 then
      uses = 2
   end
   return uses
end

Rules.RegisterFeatUses(harper,
                       FEAT_DENEIRS_EYE,
                       2097)

Rules.RegisterFeatUses(
   function (feat, cre)
      local level = cre:GetLevelByClass(CLASS_TYPE_ASSASSIN)
      local uses  = 1
      if level >= 40 then
         uses = 4
      elseif level >= 30 then
         uses = 3
      elseif level >= 20 then
         uses = 2
      end
      return uses
   end,
   FEAT_PRESTIGE_DARKNESS)

Rules.RegisterFeatUses(
   function (feat, cre)
      return 2
   end,
   FEAT_UNDEAD_GRAFT_1)

Rules.RegisterFeatUses(
   function (feat, cre)
      return 3
   end,
   FEAT_UNDEAD_GRAFT_2)

Rules.RegisterFeatUses(
   function (feat, cre)
      local uses = 1
      local level = cre:GetLevelByClass(CLASS_TYPE_SHADOWDANCER)
      if level >= 45 then
         uses = 2
      end
      return uses
   end,
   2089)

Rules.RegisterFeatUses(
   function (feat, cre)
      local level = cre:GetLevelByClass(CLASS_TYPE_MONK)
      local uses = 1 + (level / 4)
      if cre:GetHasFeat(FEAT_EXTRA_STUNNING_ATTACK) then
         uses = uses + 3
      end
      return uses
   end,
   FEAT_STUNNING_FIST)

Rules.RegisterFeatUses(
   function (feat, cre)
      local uses = 3 + cre:GetAbilityModifier(ABILITY_CHARISMA)
      if cre:GetHasFeat(FEAT_EXTRA_TURNING) then
         uses = uses + 6
      end
      return uses
   end,
   FEAT_TURN_UNDEAD)


local function smite(feat, cre)
   if cre:GetHasFeat(FEAT_EXTRA_SMITING) then
      return 3
   end
   return 1
end

Rules.RegisterFeatUses(smite,
                       FEAT_SMITE_EVIL,
                       FEAT_SMITE_GOOD)

local function epic_spell(feat, cre)
   local level = math.max(cre:GetLevelByClass(CLASS_TYPE_SORCERER),
                          cre:GetLevelByClass(CLASS_TYPE_WIZARD))

   level = math.max(level, cre:GetLevelByClass(CLASS_TYPE_DRUID))
   level = math.max(level, cre:GetLevelByClass(CLASS_TYPE_CLERIC))

   if level >= 50 then
      return 3
   elseif level >= 40 then
      return 2
   end

   level = cre:GetLevelByClass(CLASS_TYPE_PALEMASTER)
   if level >= 40 then
      return 3
   elseif level >= 30 then
      return 2
   end

   return 1
end

Rules.RegisterFeatUses(epic_spell,
                       FEAT_EPIC_SPELL_RUIN,
                       FEAT_EPIC_SPELL_HELLBALL)

Rules.RegisterFeatUses(infinite,
                       FEAT_EPIC_SHIFTER_INFINITE_HUMANOID_SHAPE,
                       FEAT_EPIC_DRUID_INFINITE_WILDSHAPE,
                       FEAT_EPIC_DRUID_INFINITE_ELEMENTAL_SHAPE)

Rules.RegisterFeatUses(
   function(feat, cre)
      if cre:GetHasFeat(FEAT_EPIC_DRUID_INFINITE_ELEMENTAL_SHAPE) then
         return 100
      else
         local tda = TDA.Get2daString("feat", "USESPERDAY", feat)
         return tonumber(tda) or 100
      end
   end,
   304, 340, 341, 342)

Rules.RegisterFeatUses(
   function(feat, cre)
      if cre:GetHasFeat(FEAT_EPIC_DRUID_INFINITE_WILDSHAPE) then
         return 100
      else
         local tda = TDA.Get2daString("feat", "USESPERDAY", feat)
         return tonumber(tda) or 100
      end
   end,
   305, 335, 336, 337, 338, 339)
