local lfs = require 'lfs'
local ffi = require 'ffi'
local C = ffi.C

local E = require 'ta.loot'
local Log = require('ta.logger').Log

local dir = "lua/loot/"

for f in lfs.dir(dir) do
   if string.find(f:lower(), ".lua", -4)  then
      local file = lfs.currentdir() .. "/" .. dir .. f
      C.Local_NWNXLog(0, "Loading Loot Table: " .. file .. "\n")
      local tag = E.Load(file)
   end
end

function ta_loot_gen(self)
   E.Run(self:GetResRef(), 0, self)
end
