local NXItems = require 'solstice.nwnx.items'
local Eff = require 'solstice.effect'
local fmt = string.format
local Log = System.GetLogger()

-- Load IP Handlers.
for f in lfs.dir('lua/ip_handlers') do
   if string.find(f:lower(), ".lua", -4)  then
      local file = lfs.currentdir() .. "/lua/ip_handlers/" .. f
      Log:info("Loading Itemprop Handler: " .. file)
      -- Wrap the dofile call in a pcall so that errors can be logged here
      -- and so that they will not cause the for loop to abort.
      local result, err = pcall(function() dofile(file) end)
      if not result then
         Log:error("ERROR Loading: %s : %s \n", file, err)
      end
   end
end
