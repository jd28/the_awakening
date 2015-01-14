local D     = require 'ta.dynconvo'
local fmt   = string.format
local Color = require 'solstice.color'
local TDA   = require 'solstice.2da'
local TLK   = require 'solstice.tlk'
local NWNXLevels = require 'solstice.nwnx.levels'

local WELCOME_MESSAGE = "Welcome to the NEW Legendary Leveler, would you like to gain a level?  Note throughout the process there will be some small " ..
                        "delays in the conversation, this is to ensure that all nodes are properly initialized.  Please report missing nodes, but " ..
                        "restarting the conversation or exiting the dialog typically will fix it.  If not try taking the conversation slow.\n"

local function GetIsFeatAvailable(pc, feat, class)
    local stat = Rules.GetGainsStatOnLevelUp(pc:GetHitDice() +  1) and pc:GetLocalInt("LL_STAT") or -1
	local class_pos = pc:GetLocalInt("LL_CLASS_POSITION")
	local class_lvl = pc:GetLocalInt("LL_CLASSLEVEL_"..tostring(class_pos)) + 1

    if Rules.GetFeatIsFirstLevelOnly(feat) then return false end
    if pc:GetKnowsFeat(feat) and feat ~= 13 then return false end

    -- Custom Feat Requirements:
--    if GetMeetsCustomFeatReq(pc, feat, class) then
--        return true
--    end

	if Rules.GetIsClassGrantedFeat(feat, class) == class_lvl then
		return false
	end

    if not Rules.GetIsClassGeneralFeat(feat, class) and not Rules.GetIsClassBonusFeat(feat, class) then
        return false --if it's not a class skill and it's not a general skill return FALSE
    end

	if NWNXLevels.GetMeetsLevelUpFeatRequirements(pc, feat) then
        return true
    end

    return false
end

local function LoadFeats(pc, class)
	local class_lvl = pc:GetLevelByClass(class) + 1
    local feats = Rules.GetLevelBonusFeats(pc, class, class_lvl)
    local feat_count = pc:GetLocalInt("LL_FEAT_COUNT")
    for _, f in ipairs(feats) do
       pc:SetLocalInt("LL_FEAT_"..tostring(feat_count), f + 1)
       feat_count = feat_count + 1
    end
    pc:SetLocalInt("LL_FEAT_COUNT", feat_count)
end


local function GetSkillsSortedByName()
   local t = {}
   for i=0, SKILL_LAST do
      local name = Rules.GetSkillName(i)
      table.insert(t, {name,  i})
   end
   table.sort(t, function(a, b) return a[1] < b[1] end)

   local res = {}
   for i=0, SKILL_LAST do
      table.insert(res, t[i+1][2])
   end
   return res
end

local SORTED_SKILLS = GetSkillsSortedByName()

local function GetFeatTable()
   local ms_inserted = {}
   local t = {}
   local mt = {}
   local twoda = TDA.GetCached2da("feat")
   local size = TDA.GetRowCount(twoda) - 1
   for i = 0, size do
      local master = -1
      local msfeat = TDA.GetString('feat', 'MASTERFEAT', i)
      if #msfeat > 0 then
         master = tonumber(msfeat)
         if not ms_inserted[master] then
            table.insert(mt, { Rules.GetMasterFeatName(master).."...", -1, master })
            ms_inserted[master] = true
         end
      end

      table.insert(t, { Rules.GetFeatName(i), i, master })
   end

   -- Sort everything alphabetically.
   table.ksort(t, 1)
   table.ksort(mt, 1)

   return t, mt
end

local SORTED_FEATS, SORTED_MASTER_FEATS = GetFeatTable()

local function finish(pc)
   for i=0, SKILL_LAST do
      pc:DeleteLocalInt(fmt('LL_SKILL_%d', i))
   end

   for i=0, pc:GetLocalInt('LL_FEAT_COUNT') -1 do
      pc:DeleteLocalInt("LL_FEAT_" .. tostring(i))
   end
   pc:DeleteLocalInt('LL_FEAT_COUNT')
   pc:DeleteLocalInt('LL_HP')
   pc:DeleteLocalInt('LL_CLASS')
   pc:DeleteLocalInt('LL_STAT')
   pc:DeleteLocalInt('LL_SPGN')
end

local function ability_select(conv, it)
   local pc = Game.GetPCSpeaker()
   local cp = conv:GetCurrentPage()
   local abil = it[2]

   cp:SetAccetpable(true)
   cp:SetPrompt(fmt("You've selected <CUSTOM112>%s<CUSTOM100>.  Is this the ability you'd like to select?", Rules.GetAbilityName(abil)))
   pc:SetLocalInt("LL_STAT", abil + 1);
   pc:SetLocalInt("LL_STAT_"..tostring(abil), 1);
end

local function skill_prompt(data)
   local obj = Game.GetPCSpeaker()
   local added = obj:GetLocalInt(fmt('LL_SKILL_%d', data[2]))
   local current =  added + obj:GetSkillRank(data[2], nil, true)
   local is_class_skill = Rules.GetIsClassSkill(data[2], obj:GetLocalInt('LL_CLASS') - 1)
   local maximum = 4 + obj:GetHitDice() + 1

   if is_class_skill then
      if added > 0 then
         return fmt('<CUSTOM112>%s: %d / %d<CUSTOM100>', Rules.GetSkillName(data[2]), current, maximum)
      else
         return fmt('%s: %d / %d', Rules.GetSkillName(data[2]), current, maximum)
      end
   else
      maximum = math.floor(maximum / 2)
      if added > 0 then
         return fmt('<CUSTOM112>%s [Cross-Class]: %d / %d<CUSTOM100>', Rules.GetSkillName(data[2]), current, maximum)
      else
         return fmt('%s [Cross-Class]: %d / %d', Rules.GetSkillName(data[2]), current, maximum)
      end
   end
end

local function skill_add(conv, it)
   local pc = Game.GetPCSpeaker()
   local is_class_skill = Rules.GetIsClassSkill(it[2], pc:GetLocalInt('LL_CLASS') - 1)
   local cost = is_class_skill and 1 or 2
   local maximum = 4 + pc:GetHitDice()
   maximum = is_class_skill and maximum or math.floor(maximum / 2)
   local current = pc:GetLocalInt(fmt('LL_SKILL_%d', it[2])) + pc:GetSkillRank(it[2], nil, true)
   local cp  = conv:GetCurrentPage()
   local sps = pc:GetLocalInt("LL_SKILL_POINTS")
   if cost > sps or current >= maximum then return end

   cp.undo = cp.undo or {}
   table.insert(cp.undo, it[2])
   pc:IncrementLocalInt(fmt('LL_SKILL_%d', it[2]))
   pc:DecrementLocalInt("LL_SKILL_POINTS", cost)
   cp:SetPrompt(fmt("Please select a skill to add a point to. You have %d points remaining to spend.",
                    pc:GetLocalInt("LL_SKILL_POINTS")))

end

local function skill_undo(page)
   local pc = Game.GetPCSpeaker()
   if page.undo and #page.undo > 0 then
      local skill = table.remove(page.undo)
      local is_class_skill = Rules.GetIsClassSkill(skill, pc:GetLocalInt('LL_CLASS') - 1)
      local cost = is_class_skill and 1 or 2

      pc:DecrementLocalInt(fmt('LL_SKILL_%d', skill))
      pc:IncrementLocalInt("LL_SKILL_POINTS", cost)
      page:SetPrompt(fmt("Please select a skill to add a point to. You have %d points remaining to spend.",
                         pc:GetLocalInt("LL_SKILL_POINTS")))

   end
end

local function skill_builder(page)
   local pc = Game.GetPCSpeaker()
   for i=1, #SORTED_SKILLS do
      -- todo[josh]: make sure the person can actually take the skill...
      if Rules.CanUseSkill(SORTED_SKILLS[i], Game.GetPCSpeaker()) then
         page:AddItem(skill_prompt, SORTED_SKILLS[i])
      end
   end
   page:SetPrompt(fmt("Please select a skill to add a point to. You have %d points remaining to spend.",
                      pc:GetLocalInt("LL_SKILL_POINTS")))
end

local function feat_select(conv, it)
   local pc = Game.GetPCSpeaker()
   local cp = conv:GetCurrentPage()

   -- Handle returning to the main feat page.
   if it[2] < 0 then
      if cp.subfeat then
         conv:ChangePage('feats')
      else
         conv:ChangePage('feats'..tostring(it[3]))
      end
      return
   end

   cp.feat = it[2]
   cp:SetPrompt(fmt("You selected <CUSTOM112>%s<CUSTOM100>. Is that the feat you want?", it[1]))
   cp:SetAccetpable(true)
end

local function feat_accept(page)
   local pc = Game.GetPCSpeaker()
   local featcount = pc:GetLocalInt("LL_FEAT_COUNT")
   if page.feat then
      pc:SetLocalInt("LL_FEAT_"..tostring(featcount), page.feat + 1)
      pc:IncrementLocalInt("LL_FEAT_COUNT");
   end
end

local function feat_builder(page, conv)
   local mpage = {}
   local pc = Game.GetPCSpeaker()
   local class = pc:GetLocalInt('LL_CLASS') - 1
   LoadFeats(pc, class)
   -- todo[josh]: make sure the person can actually take the feat...
   for i=1, #SORTED_FEATS do
      if #SORTED_FEATS[i][1] > 0
         and (SORTED_FEATS[i][2] < 1080 or SORTED_FEATS[i][2] > 2000)
         and (SORTED_FEATS[i][2] == -1 or GetIsFeatAvailable(pc, SORTED_FEATS[i][2], class))
      then
         local master = SORTED_FEATS[i][3]

         if SORTED_FEATS[i][2] ~= -1 and master >= 0 then
            mpage[master] = mpage[master] or conv:AddPage('feats'..tostring(master),
                                                          "Please select the feat you would like to gain this level.",
                                                          'confirm', feat_select)
            mpage[master].subfeat = true
            table.insert(mpage[master].items, SORTED_FEATS[i])
         else
            table.insert(page.items, SORTED_FEATS[i])
         end
      end
   end
   for k, v in pairs(mpage) do
      v:SetAcceptHandler(feat_accept)
      v:SetBack('feats')
   end

   local sort = false
   for _, v in ipairs(SORTED_MASTER_FEATS) do
      if mpage[v[3]] then
         table.insert(page.items, v)
         sort = true
      end
   end
   if sort then
      table.ksort(page.items, 1)
   end
end

local function skill_next()
   local pc = Game.GetPCSpeaker()
   if Rules.GainsFeatAtLevel(pc:GetHitDice() + 1) then
      return "feats", 4.0
   else
      return "confirm", 1.0
   end
end


local function class_next()
   local pc = Game.GetPCSpeaker()
   if Rules.GetGainsStatOnLevelUp(pc:GetHitDice() + 1) then
      return "abilities"
   else
      return "skills"
   end
end

local function confirm_builder(page)
   local pc = Game.GetPCSpeaker()
   local t = {}

   local class = pc:GetLocalInt("LL_CLASS") - 1;

   table.insert(t, "You will gain BAB as well as any saving throw bonuses.\n")
   table.insert(t, fmt("Class: %s", Rules.GetClassName(class)))
   table.insert(t, fmt("Hitpoints: %d", pc:GetLocalInt('LL_HP')))
   local any = false
   table.insert(t, "Abilities:")
   local abilities = {}
   for i=0, 5 do
      local value = pc:GetLocalInt("LL_STAT_" .. tostring(i))
      if value > 0 then
         any = true
         table.insert(t, fmt("    %s: +%d", Rules.GetAbilityName(i), value))
      end
      table.insert(abilities, value)
   end
   if not any then
      table.insert(t, '    none')
   end

   any = false
   table.insert(t, "Skills:")
   for i=0, SKILL_LAST do
      local value = pc:GetLocalInt("LL_SKILL_" .. tostring(i))
      if value > 0 then
         any = true
         table.insert(t, fmt("    %s: +%d", Rules.GetSkillName(i), value))
      end
   end
   if not any then
      table.insert(t, '    none')
   end

   any = false
   table.insert(t, "Feats:")
   for i=0, pc:GetLocalInt('LL_FEAT_COUNT') -1 do
      local value = pc:GetLocalInt("LL_FEAT_" .. tostring(i))
      if value > 0 then
         any = true
         table.insert(t, fmt("    %s", Rules.GetFeatName(value - 1)))
      end
   end
   if not any then
      table.insert(t, '    none')
   end

   page:SetPrompt(table.concat(t, '\n'))
end

local function confirm_accept(page)
   print 'actually do level up'
end

local function class_select(conv, it)
   local pc = Game.GetPCSpeaker()
   local class = it[2]
   local pos = pc:GetPositionByClass(class)
   local cls_level = pc:GetLevelByClass(class) + 1
   local level = pc:GetHitDice() + 1
   local total = 0
   local cp = conv:GetCurrentPage()

   cp:SetPrompt(fmt("You've selected <CUSTOM112>%s<CUSTOM100>.  Is this the class you'd like to level up in?", Rules.GetClassName(class)))

   pc:SetLocalInt('LL_CLASS_POSITION', pos)
   pc:SetLocalInt("LL_CLASS", class + 1)
   pc:SetLocalInt("LL_HP", Rules.GetHitPointsGainedOnLevelUp(class, pc))
   pc:SetLocalInt("LL_SKILL_POINTS", pc:GetSkillPoints() + Rules.GetSkillPointsGainedOnLevelUp(class, pc))

   if class == CLASS_TYPE_WIZARD
      and cls_level < 41
      and pc:GetAbilityScore(ABILITY_INTELLIGENCE, true) > 10
   then
      pc:SetLocalInt("LL_SPGN", 2);
   elseif cls_level < 21 then
      local cha =  pc:GetAbilityScore(ABILITY_CHARISMA, true) - 10;
      local old, new

      if class == CLASS_TYPE_BARD then
         for i=0, 6 do
            if cha - i >= 0 then
               old = TDA.Get2DAInt("cls_spkn_bard", "SpellLevel"..tostring(i), cls_level - 1);
               new = TDA.Get2DAInt("cls_spkn_bard", "SpellLevel"..tostring(i), cls_level);

               pc:SetLocalInt("LL_SPKN_"..tostring(i), new - old);
               total = total + new - old;
            end
         end
      elseif class == CLASS_TYPE_SORCERER then
         for i=0, 9 do
            if cha - i >= 0 then
               old = TDA.GetInt("cls_spkn_sorc", "SpellLevel"..tostring(i), cls_level - 1);
               new = TDA.GetInt("cls_spkn_sorc", "SpellLevel"..tostring(i), cls_level);
               pc:SetLocalInt("LL_SPKN_"..tostring(i), new - old);
               total = total + new - old;
            end
         end
      end
   end
   pc:SetLocalInt("LL_SPGN", total)
   conv:GetCurrentPage():SetAccetpable(true)
end

local function class_next()
   local pc = Game.GetPCSpeaker()
   if Rules.GetGainsStatOnLevelUp(pc:GetHitDice() + 1) then
      return "abilities", 1.0
   else
      return "skills", 1.0
   end
end

local function class_builder(page)
   local pc = Game.GetPCSpeaker()
   if pc:GetSubrace() == 'Paragon' then
      local class = pc:GetHighestLevelClass()
      page:AddItem(Rules.GetClassName(class), class)
   else
      local class = pc:GetClassByPosition(0)
      page:AddItem(Rules.GetClassName(class), class)

      class = pc:GetClassByPosition(1)
      if class ~= 255 then
         page:AddItem(Rules.GetClassName(class), class)
      end

      class = pc:GetClassByPosition(2)
      if class ~= 255 then
         page:AddItem(Rules.GetClassName(class), class)
      end
   end
end

local function preload(pc)
   	local class1, class2, class3, level1, level2, level3, new_level;

	class1 = pc:GetClassByPosition(0) + 1;

	class2 = pc:GetClassByPosition(1);
    class2 = class2 == CLASS_TYPE_INVALID and 0 or class2 + 1

	class3 = pc:GetClassByPosition(2);
    class3 = class3 == CLASS_TYPE_INVALID and 0 or class3 + 1

    level1 = pc:GetLevelByClass(class1 - 1)
    if class2 > 0 then
        level2 = pc:GetLevelByClass(class2 - 1)
    end

    if class3 > 0 then
       level3 = pc:GetLevelByClass(class3 - 1)
    end

	new_level = level1 + level2 + level3 + 1

    pc:SetLocalInt("LL_CLASS_1", class1)
    pc:SetLocalInt("LL_CLASSLEVEL_1", level1)
    pc:SetLocalInt("LL_CLASS_2", class2)
    pc:SetLocalInt("LL_CLASSLEVEL_2", level2)
   	pc:SetLocalInt("LL_CLASS_3", class3)
    pc:SetLocalInt("LL_CLASSLEVEL_3", level3)
    pc:SetLocalInt("LL_LEVEL", new_level)
end

function pl_ll3_conv(obj)
   local pc    = Game.GetItemActivator()
   local item  = Game.GetItemActivated()
   local event = Game.GetUserDefinedItemEventNumber(obj)
   if event ~= ITEM_EVENT_ACTIVATE then return end
   local level = pc:GetHitDice()
   local xp = Rules.GetXPLevelRequirement(level + 1)

   Game.ExportSingleCharacter(pc)
   if pc:GetHitDice() >= 60 then
      pc:ErrorMessage('You are unable to advance passed 60th level!')
      return
   elseif pc:GetHitDice() < 40 then
      pc:ErrorMessage('You are unable to take Legendary Levels until you have reached 40th level!')
      return
   elseif pc:GetXP() < xp then
      pc:ErrorMessage(fmt('You need %d more XP before you are able to level up.', xp - pc:GetXP()))
      return
   end
   pc:ForceRest()
   local c = D.new("pl_ll3_conv")
   c:SetFinishedHandler(finish)
   c:SetAbortedHandler(finish)

   preload(pc)

   -- Welcome
   local p = c:AddPage('welcome', WELCOME_MESSAGE, 'class')
   p:SetAccetpable(true)

   -- Class selection
   p = c:AddPage('class', "Please select the class you would like to increase this level.",
                 class_next, class_select)
   p:SetBuilder(class_builder)

   -- Abilities
   p = c:AddPage('abilities', 'Please select the ability you would like to increase this level.',
                 'skills', ability_select)
   p:AddItem('Strength', ABILITY_STRENGTH)
   p:AddItem('Dexterity', ABILITY_DEXTERITY)
   p:AddItem('Constitution', ABILITY_CONSTITUTION)
   p:AddItem('Wisdom', ABILITY_WISDOM)
   p:AddItem('Intelligence', ABILITY_INTELLIGENCE)
   p:AddItem('Charisma', ABILITY_CHARISMA)

   -- Skills
   p = c:AddPage('skills', "", skill_next, skill_add)
   p:SetBuilder(skill_builder)
   p:SetUndoHandler(skill_undo)
   p:SetAccetpable(true)

   -- Feats
   p = c:AddPage('feats', "Please select the feat you would like to gain this level.", 'confirm', feat_select)
   p:SetBuilder(feat_builder)
   p:SetAcceptHandler(feat_accept)

   -- Confirmation
   p = c:AddPage('confirm', 'Confirm Everything')
   p:SetAccetpable(true)
   p:SetAcceptHandler(confirm_accept)
   p:SetBuilder(confirm_builder)

   c:ChangePage('welcome')
   D.Start(pc, item, c)
end
