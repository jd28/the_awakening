local lfs = require 'lfs'
local ffi = require 'ffi'
local C = ffi.C
local fmt = string.format
local inih = require 'inih'

-- Some sane defaults, can be overwritten in nwnx2.ini.
local script_dir = 'lua'
local log_dir = "logs.0"

require "solstice.util"

-- Read pertinent settings from nwnx2.ini
print(inih.parse('nwnx2.ini',
           function(section, name, value)
              if section == "SOLSTICE" and name == "script_dir" then
                 script_dir = (script_dir or value:trim())
              end
              if section == "LogDir" and name == 'logdir' then
                 log_dir = lfs.currentdir() .. '/' .. (log_dir or value:trim())
              end
              print(section, name, value)
              return true
           end))

OPT = runfile(fmt('./%s/settings.lua', script_dir))
OPT.LOG_DIR = log_dir
OPT.SCRIPT_DIR = script_dir
package.path = package.path .. ";./"..script_dir.."/?.lua;"

-- Bind servers default logger.
local Sys = require 'solstice.system'
local log = Sys.FileLogger(OPT.LOG_DIR .. '/' .. OPT.LOG_FILE, OPT.LOG_DATE_PATTERN)
Sys.SetLogger(log)

--- Constants MUST be loaded before solstice.
require(OPT.CONSTANTS)
require('solstice.preload')

require 'ta.new_combat_engine'

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
