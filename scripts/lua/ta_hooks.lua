local Hook = require 'solstice.hooks'
local ffi = require 'ffi'
local C = ffi.C
local Log = System.GetLogger()

for f in lfs.dir('lua/hooks') do
   if string.find(f:lower(), ".lua", -4)  then
      local file = lfs.currentdir() .. "/lua/hooks/" .. f
      Log:info("Loading Hook: " .. file)
      -- Wrap the dofile call in a pcall so that errors can be logged here
      -- and so that they will not cause the for loop to abort.
      local result, err = pcall(function() dofile(file) end)
      if not result then
         Log:error("ERROR Loading: %s : %s \n", file, err)
      end
   end
end
