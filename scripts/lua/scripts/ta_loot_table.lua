local lfs = require 'lfs'
local ffi = require 'ffi'
local C = ffi.C

local E = require 'ta.loot'
local Log = System.GetLogger()

local dir = "lua/loot/"

for f in lfs.dir(dir) do
   if string.find(f:lower(), ".lua", -4)  then
      local file = lfs.currentdir() .. "/" .. dir .. f
      Log:info("Loading Loot Table: " .. file)
      local tag = E.Load(file)
   end
end

function ta_loot_gen(self)
   E.Run(self:GetResRef(), 0, self)
end
