require 'plugins.combat.ctypes'
local ClearCache = require 'plugins.combat.clear_cache'
local Update = require 'plugins.combat.update'
local Combat = require 'plugins.combat.new_combat_engine'

local function OnLoad(interface)
  Game.OnObjectClearCacheData:register(nil, ClearCache.ClearCacheData)
  Game.OnUpdateCombatInfo:register(nil, Update.UpdateCombatInfo)
  Rules.RegisterCombatEngine(interface)
end

local function OnUnload(interface)
  Game.OnObjectClearCacheData:deregister(nil, ClearCache.ClearCacheData)
  Game.OnUpdateCombatInfo:deregister(nil, Update.UpdateCombatInfo)
  Rules.RegisterCombatEngine(nil)
end

Game.LoadPlugin(
  Game.PLUGIN_COMBAT_ENGINE,
  { DoRangedAttack = Combat.DoRangedAttack,
    DoMeleeAttack  = Combat.DoMeleeAttack,
    DoPreAttack = Combat.ResolvePreAttack,
    OnLoad = OnLoad,
    OnUnload = OnUnload })
