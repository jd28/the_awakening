local lfs = require 'lfs'
local ffi = require 'ffi'
local C = ffi.C
local fmt = string.format

-- Must be the same as in nwnx2.ini
local script_dir = 'lua'

require "solstice.util.lua_preload"
OPT = runfile(fmt('./%s/settings.lua', script_dir))
package.path = package.path .. ";./"..script_dir.."/?.lua;"

local Sys = require 'solstice.system'
local log = Sys.GetLogger()

--- Constants MUST be loaded before solstice.
require(OPT.CONSTANTS)
require('solstice.preload')

if OPT.DATABASE_TYPE
   and OPT.DATABASE_HOSTNAME
   and OPT.DATABASE_PASSWORD
   and OPT.DATABASE_NAME
   and OPT.DATABASE_USER
then
   local DBI = require 'DBI'
   System.ConnectDatabase(OPT.DATABASE_TYPE,
                          OPT.DATABASE_NAME,
                          OPT.DATABASE_USER,
                          OPT.DATABASE_PASSWORD,
                          OPT.DATABASE_HOSTNAME,
                          OPT.DATABASE_PORT)

end

for f in lfs.dir("./"..script_dir) do
   if f ~= "preload.lua" and
      f ~= "settings.lua" and
      f ~= OPT.CONSTANTS .. '.lua' and
      string.find(f:lower(), ".lua", -4)
   then
      local file = fmt('%s/%s/%s', lfs.currentdir(), script_dir, f)
      log:info("Loading: " .. file)

      -- Wrap the dofile call in a pcall so that errors can be logged here
      -- and so that they will not cause the for loop to abort.
      local result, err = pcall(function() dofile(file) end)
      if not result then
         log:error("ERROR Loading: %s : %s", file, err)
      end
   end
end
