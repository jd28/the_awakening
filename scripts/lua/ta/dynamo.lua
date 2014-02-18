
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

function M.GetLevelHolder(tbl, obj)
   local result = tbl
   if tbl.rotate then
      result = tbl[tbl.rotate]
      if tbl.rotate == #tbl then
         tbl.rotate = 1
      else
         tbl.rotate = tbl.rotate + 1
      end
   elseif tbl.every then
      if tbl[tbl.every] then
         result = tbl[tbl.every]
      else
         result = tbl[0]
      end
      tbl.every = tbl.every + 1
   elseif tbl.if_ then
      result = default
      for i = 1, #tbl.if_, 2 do
         if _G[tbl.if_[i]](obj) then
            result = tbl.if_[i+1]
            break
         end
      end
   end
   return result
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

--- Creates a range for random values.
-- @see math.random
function M.Random(start, stop)
   return M.range_t(start, stop)
end

function M.Chance(chance, tbl)
   tbl.chance = chance
   return tbl
end

function M.Rotate(...)
   local t = {...}
   t.rotate = 1
end

function M.Every(default, ...)
   local t = { every = 1 }
   t[0] = default

   local temp = {...}
   for i=1, #temp, 2 do
      t[temp[i]] = temp[i+1]
   end

   return t
end

function M.If(default, ...)
   default.if_ = {...}
   return default
end

return M
