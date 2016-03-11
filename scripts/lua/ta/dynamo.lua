
local M = {}
local ffi = require 'ffi'
local random = math.random
local max = math.max
local min = math.min
local floor = math.floor

ffi.cdef [[
typedef struct {
   int32_t start;
   int32_t stop;
} Range;

typedef struct DynamoValue {
   int32_t start;
   int32_t stop;
   double  add;
   bool    mult;
} DynamoValue;
]]

local range_t = ffi.typeof("Range")
local dynamo_value_t = ffi.typeof("DynamoValue")

local DYNAMO_INVALID = 0
local DYNAMO_CHANCE  = 1
local DYNAMO_ROTATE  = 2
local DYNAMO_EVERY   = 3
local DYNAMO_IF      = 4
local DYNAMO_RANDOM  = 5
local DYNAMO_PERCENT = 6
local DYNAMO_OR      = 7
local DYNAMO_WEIGHT  = 8

local function GetPlayerTable(tbl, num_players)
   local place
   local minimum = 1000000
   for x, y in pairs(tbl) do
      if type(x) == 'number' then
         place = place or x
         minimum = min(minimum, x)
         if x >= num_players and x <= place then
            place = x
         end
      end
   end
   if minimum > num_players then
      return tbl[minimum]
   end
   return tbl[place]
end

local function set_base(tbl)
   tbl._dynamo_base = true
end

local function Capture(table, key)
   local is_const = string.match(key, '^%u[%u_]+')
   if is_const and not _CONSTS[key] then
      error(string.format("Invalid constant: %s!", key))
   end

   if _CONSTS[key] then
      return _CONSTS[key]
   elseif M[key] then
      return M[key]
   end

   local function f(...)
      local t = {...}
      t.f = key
      set_base(t)
      return t
   end

   return f
end

local function extract(tbl, obj)
   local result = tbl

   if tbl.chance and tbl.chance < random(100) then
      return nil
   end

   -- If the passed in table, doesn't have a Dynamo type it, assume it
   -- doesn't need extraction.
   if not tbl._dynamo_type then return tbl end

   if tbl._dynamo_type == DYNAMO_ROTATE then
      if not tbl.rotate then
         print(debug.traceback())
      end
      result = tbl[tbl.rotate]
      if tbl.rotate == #tbl then
         tbl.rotate = 1
      else
         tbl.rotate = tbl.rotate + 1
      end
   elseif tbl._dynamo_type == DYNAMO_PERCENT then
      local r = random(100)
      local tot = 0
      for i=1, #tbl, 2 do
         tot = tot + tbl[i]
         if r <= tot then
            result = tbl[i+1]
            break
         end
      end
   elseif tbl._dynamo_type == DYNAMO_WEIGHT then
      local r = random(tbl._weight_sum)
      local tot = 0
      for i=1, #tbl, 2 do
         tot = tot + tbl[i]
         if r <= tot then
            result = tbl[i+1]
            break
         end
      end
   elseif tbl._dynamo_type == DYNAMO_RANDOM then
      result = tbl[random(#tbl)]
   elseif tbl._dynamo_type == DYNAMO_EVERY then
      if tbl[tbl.every] then
         result = tbl[tbl.every]
      else
         result = nil
      end
      if tbl.every == tbl._dynamo_every_max then
         tbl.every = 1
      else
         tbl.every = tbl.every + 1
      end
   elseif tbl._dynamo_type == DYNAMO_IF then
      local r
      for i = 1, #tbl, 2 do
         if tbl[i](obj) then
            r = tbl[i+1]
            break
         end
      end
      result = r
   elseif tbl._dynamo_type == DYNAMO_OR then
      local r
      for _, v in ipairs(tbl) do
         local r = extract(v)
         if r then break end
      end
      result = r
   end

   return result
end

local function flatten(tbl, obj, acc)
   acc = acc or {}
   for _, sp in ipairs(tbl) do
      local ex = extract(sp, obj)
      if ex then
         if ex._dynamo_base then
            table.insert(acc, ex)
         else
            flatten(ex, obj, acc)
         end
      end
   end
   return acc
end

local function Range(start, stop)
   return dynamo_value_t(start, stop)
end

local function PerPlayer(base, add, multiply)
   multiply = multiply and 1 or 0
   if type(base) == 'number' then
      return dynamo_value_t(base, base, add, multiply)
   else -- We assume this is already a range value...
      base.add = add
      base.mult = multiply
      return base
   end
end

local function GetValue(value, use_max, players)
   if type(value) == "number" then
      return value
   elseif type(value) == "table" then
      return value[random(1, #value)]
   end

   players = players or 1
   local res
   if value.start == value.stop then
      res = value.start
   elseif use_max then
      res = value.stop
   else
      res = random(value.start, value.stop)
   end

   if value.add > 0 then
      local nres = res
      for i=1, players do
         if value.mult then
            nres = nres * value.add
         else
            nres = nres + value.add
         end
      end
      res = nres
   end

   return floor(res)
end

local function Chance(chance, tbl)
   tbl.chance = chance
   return tbl
end

local function Rotate(t)
   t.rotate = 1
   t._dynamo_type = DYNAMO_ROTATE
   return t
end

local function Every(t)
   local res = {}
   res.every = 1
   res._dynamo_type = DYNAMO_EVERY
   res._dynamo_every_max = -1
   for i = 1, #t, 2 do
      res._dynamo_every_max = max(res._dynamo_every_max, t[i])
      res[t[i]] = t[i+1]
   end
   return res
end

local function If(t)
   t._dynamo_type = DYNAMO_IF
   return t
end

local function Random(t)
   t._dynamo_type = DYNAMO_RANDOM
   return t
end

local function Percent(t)
   t._dynamo_type = DYNAMO_PERCENT
   assert(#t % 2 == 0)
   local sum = 0
   for i=1, #t, 2 do
      sum = sum + t[i]
   end
   assert(sum == 100)
   return t
end

local function Or(t)
   t._dynamo_type = DYNAMO_OR
   return t
end

local function Weight(t)
   t._dynamo_type = DYNAMO_WEIGHT
   assert(#t % 2 == 0)
   local sum = 0
   for i=1, #t, 2 do
      sum = sum + t[i]
   end

   t._weight_sum = sum

   return t
end

M.GetPlayerTable = GetPlayerTable
M.Capture = Capture
M.flatten = flatten
M.extract = extract
M.Range = Range
M.PerPlayer = PerPlayer
M.GetValue = GetValue
M.Chance = Chance
M.Rotate = Rotate
M.Every = Every
M.If = If
M.Random = Random
M.Percent = Percent
M.Or = Or
M.Weight = Weight
M.set_base = set_base
return M
