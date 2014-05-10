local ffi = require 'ffi'
local C = ffi.C
local Creature = require 'ta.creature'
local creatures_dir = "lua/creatures/"
local fmt = string.format

for f in lfs.dir(creatures_dir) do
   if string.find(f:lower(), ".lua", -4)  then
      local file = lfs.currentdir() .. "/lua/creatures/" .. f
      C.Local_NWNXLog(0, "Loading Creature: " .. file .. "\n")
      Creature.Load(file)
   end
end
