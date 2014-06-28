
local M = {}
local ffi = require 'ffi'
local random = math.random

ffi.cdef [[
typedef struct {
   int32_t start;
   int32_t stop;
} Range;
]]

M.range_t = ffi.typeof("Range")

M.DYNAMO_INVALID = 0
M.DYNAMO_CHANCE  = 1
M.DYNAMO_ROTATE  = 2
M.DYNAMO_EVERY   = 3
M.DYNAMO_IF      = 4
M.DYNAMO_RANDOM  = 5
M.DYNAMO_PERCENT = 6
M.DYNAMO_OR      = 7

function M.GetLevelTable(tbl, level)
   if level >= 3 and tbl.Level3 then
      return tbl.Level3
   end
   if level >= 2 and tbl.Level2 then
      return tbl.Level3
   end
   if level >= 1 and tbl.Level1 then
      return tbl.Level1
   end

   return tbl.Default
end

function M.set_base(tbl)
   tbl._dynamo_base = true
end

function M.Capture(table, key)
   local is_const = string.match(key, '^%u[%u_]')
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
      M.set_base(t)
      return t
   end

   return f
end

function M.flatten(tbl, obj, acc)
   acc = acc or {}
   for _, sp in ipairs(tbl) do
      local ex = M.extract(sp, obj)
      if ex then
         if ex._dynamo_base then
            table.insert(acc, ex)
         else
            M.flatten(ex, obj, acc)
         end
      end
   end
   return acc
end

function M.extract(tbl, obj)
   local result = tbl

   if tbl.chance and tbl.chance < math.random(100) then
      return nil
   end

   -- If the passed in table, doesn't have a Dynamo type it, assume it
   -- doesn't need extraction.
   if not tbl._dynamo_type then return tbl end

   if tbl._dynamo_type == M.DYNAMO_ROTATE then
      if not tbl.rotate then
         print(debug.traceback())
      end
      result = tbl[tbl.rotate]
      if tbl.rotate == #tbl then
         tbl.rotate = 1
      else
         tbl.rotate = tbl.rotate + 1
      end
   elseif tbl._dynamo_type == M.DYNAMO_PERCENT then
      local r = math.random(100)
      local tot = 0
      for i=1, #tbl, 2 do
         tot = tot + tbl[i]
         if r <= tot then
            result = tbl[i+1]
            break
         end
      end
   elseif tbl._dynamo_type == M.DYNAMO_RANDOM then
      result = tbl[math.random(#tbl)]
   elseif tbl._dynamo_type == M.DYNAMO_EVERY then
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
   elseif tbl._dynamo_type == M.DYNAMO_IF then
      local r
      for i = 1, #tbl, 2 do
         if _G[tbl[i]](obj) then
            r = tbl[i+1]
            break
         end
      end
      result = r
   elseif tbl._dynamo_type == M.DYNAMO_OR then
      local r
      for _, v in ipairs(tbl) do
         local r = M.extract(v)
         if r then break end
      end
      result = r
   end

   return result
end

function M.Range(start, stop)
   return M.range_t(start, stop)
end

function M.GetValue(value, use_max)
   if type(value) == "number" then
      return value
   elseif type(value) == "table" then
      return value[random(1, #value)]
   elseif value.start == value.stop then
      return value.start
   elseif use_max then
      return value.stop
   else
      return random(value.start, value.stop)
   end
end

function M.Chance(chance, tbl)
   tbl.chance = chance
   return tbl
end

function M.Rotate(t)
   t.rotate = 1
   t._dynamo_type = M.DYNAMO_ROTATE
   return t
end

function M.Every(t)
   local res = {}
   res.every = 1
   res._dynamo_type = M.DYNAMO_EVERY
   res._dynamo_every_max = -1
   for i = 1, #t, 2 do
      res._dynamo_every_max = math.max(res._dynamo_every_max, t[i])
      res[t[i]] = t[i+1]
   end
   return res
end

function M.If(t)
   t._dynamo_type = M.DYNAMO_IF
   return t
end

function M.Random(t)
   t._dynamo_type = M.DYNAMO_RANDOM
   return t
end

function M.Percent(t)
   t._dynamo_type = M.DYNAMO_PERCENT
   assert(#t % 2 == 0)
   local sum = 0
   for i=1, #t, 2 do
      sum = sum + t[i]
   end
   assert(sum == 100)
   return t
end

function M.Or(t)
   t._dynamo_type = M.DYNAMO_OR
   return t
end

return M
