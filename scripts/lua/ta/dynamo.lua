
local M = {}
local ffi = require 'ffi'

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

function M.GetValue(value, use_max)
   if value.start == value.stop then
      return value.start
   elseif use_max then
      return value.stop
   else
      return math.random(value.start, value.stop)
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

return M
