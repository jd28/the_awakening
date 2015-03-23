local ffi = require 'ffi'
local C = ffi.C
local Item = require 'ta.item'
local items_dir = "lua/items/"
local fmt = string.format
local Log = System.GetLogger()

for f in lfs.dir(items_dir) do
   if string.find(f:lower(), ".lua", -4)  then
      local file = lfs.currentdir() .. "/lua/items/" .. f
      Log:info("Loading Item: " .. file)
      Item.Load(file)
   end
end
