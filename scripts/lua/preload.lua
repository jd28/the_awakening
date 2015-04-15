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
local res = inih.parse('nwnx2.ini',
           function(section, name, value)
              if section == "SOLSTICE" and name == "script_dir" then
                 script_dir = (script_dir or value:trim())
              end
              if section == "LogDir" and name == 'logdir' then
                 log_dir = lfs.currentdir() .. '/' .. (log_dir or value:trim())
              end
              return true
           end)


OPT = runfile(fmt('./%s/settings.lua', script_dir))
OPT.LOG_DIR = log_dir
OPT.SCRIPT_DIR = script_dir
package.path = package.path .. ";./"..script_dir.."/?.lua;"

-- Bind servers default logger.
local Sys = require 'solstice.system'
local Log = Sys.FileLogger(OPT.LOG_DIR .. '/' .. OPT.LOG_FILE, OPT.LOG_DATE_PATTERN)
Sys.SetLogger(Log)

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
   System.ConnectDatabase(OPT.DATABASE_TYPE,
                          OPT.DATABASE_NAME,
                          OPT.DATABASE_USER,
                          OPT.DATABASE_PASSWORD,
                          OPT.DATABASE_HOSTNAME,
                          OPT.DATABASE_PORT)
end

local function load_dir(subdir, name, act)
   local dir = fmt('%s/%s/%s/', lfs.currentdir(), script_dir, subdir)
   for f in lfs.dir(dir) do
      if string.find(f:lower(), ".lua", -4)  then
         local file = fmt('%s/%s', dir, f)
         Log:info("Loading %s: %s", name, file)
         local result, err = pcall(function() act(file) end)
         if not result then
            Log:error("ERROR Loading: %s : %s \n", file, err)
         end
      end
   end
end

load_dir('scripts', 'Script', Game.LoadScript)

-- Lock the script environment so we can avoid undeclared variables.
Game.LockScriptEnvironment()

-- Encounters
local E = require 'ta.encounter'
load_dir('encounters', 'Encounter', E.Load)

-- Loot
E = require 'ta.loot'
load_dir('loot', 'Loot Table', E.Load)

-- Items
local Item = require 'ta.item'
load_dir('items', 'Item', Item.Load)

-- Load IP Handlers.
load_dir('ip_handlers', 'Itemprop Handler', dofile)

-- Hooks
load_dir('hooks', 'Hook', dofile)

-- Creatures
local Creature = require 'ta.creature'
load_dir('creatures', 'Creature', Creature.Load)

-- Subraces
load_dir('subraces', 'Subrace', dofile)

-- Chat
safe_require 'ta_chat'
