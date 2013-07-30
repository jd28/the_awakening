local ffi = require 'ffi'
local C = ffi.C
local Item = require 'solstice.item'
local items_dir = "lua/items/"

for f in lfs.dir(items_dir) do
   if string.find(f:lower(), ".lua", -4)  then
      local file = lfs.currentdir() .. "/lua/items/" .. f
      C.Local_NWNXLog(0, "Loading Item: " .. file .. "\n")
      Item.Load(file)
   end
end
