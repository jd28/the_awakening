local lfs = require 'lfs'
local ffi = require 'ffi'
local C = ffi.C

local Ev  = require 'solstice.event'
local E = require 'ta.encounter'
local Log = require('ta.logger').Log

local dir = "lua/encounters/"

function ta_enc_enter(enc)
   if enc:GetIsValid()
      and enc.obj.enc_is_active == 1
      and enc:GetLocalInt("ssp_spawned") == 0
   then
      enc:SetLocalInt("ssp_spawned", 1)
      E.Spawn(enc, 0, Ev.GetEnteringObject())
   end
end

function ta_enc_exhaust(enc)
   enc:SetLocalInt("ssp_spawned", 0)
end

for f in lfs.dir(dir) do
   if string.find(f:lower(), ".lua", -4)  then
      local file = lfs.currentdir() .. "/" .. dir .. f
      C.Local_NWNXLog(0, "Loading Encounter: " .. file .. "\n")
      local tag = E.Load(file)
   end
end
