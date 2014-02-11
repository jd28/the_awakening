local lfs = require 'lfs'
local ffi = require 'ffi'
local C = ffi.C

local DEBUG_ENCOUNTER_LOAD = true

local Ev  = require 'solstice.event'
local E = require 'ta.encounter'
local Log = require('ta.logger').Log

local dir = "lua/encounters/"

function ta_enc_enter(enc)
   if enc:GetIsValid()
      and enc.obj.enc_is_active == 1
      and not enc:GetLocalBool("ssp_spawned")
   then
      E.Spawn(enc, 0, Ev.GetEnteringObject())
   end
end

function ta_enc_exhaust(enc)
   enc:SetLocalBool("ssp_spawned", false)
end

for f in lfs.dir(dir) do
   if string.find(f:lower(), ".lua", -4)  then
      local file = lfs.currentdir() .. "/" .. dir .. f
      print("Loading: " .. file .. "\n")
      local tag = E.Load(file)
      if DEBUG_ENCOUNTER_LOAD then
         Log:info(E.Test(tag))
      end
   end
end
