local M = require 'solstice.objects.init'
local Creature = M.Creature
local Redis = require('ta.redis').GetClient()
local fmt = string.format

function Creature:GetRedisID(global)
  if global then
    return self:GetLocalString('pc_player_name')
  else
    return fmt('%s:%s',
               self:GetLocalString('pc_player_name'),
               self:GetLocalString('pc_bic_file'))
  end
end

-- NOTE: These are all lowered to a string type.
-- Different types are not stored seperately.

function Creature:GetPlayerString(var, global)
  if not self:GetIsValid() then return 0 end
  local val = self:GetLocalString(var)
  if #val > 0 then
    return val
  end
  return Redis:get(fmt("%s:%s", var, self:GetRedisID(global))) or ''
end

function Creature:SetPlayerString(var, val, global)
  if not self:GetIsValid() then return end
  self:SetLocalString(var, val)
  Redis:set(fmt("%s:%s", var, self:GetRedisID(global)), val)
end

function Creature:GetPlayerInt(var, global)
  return tonumber(self:GetPlayerString(var, global)) or 0
end

function Creature:SetPlayerInt(var, val, global)
  self:SetPlayerString(var, tostring(val), global)
end