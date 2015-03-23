local lfs = require 'lfs'
local ffi = require 'ffi'
local C = ffi.C

local E = require 'ta.encounter'
local Log = System.GetLogger()

local dir = "lua/encounters/"

function ta_enc_enter(enc)
   if enc:GetIsValid()
      and enc.obj.enc_is_active == 1
      and enc:GetLocalInt("ssp_spawned") == 0
   then
      enc:SetLocalInt("ssp_spawned", 1)
      E.Spawn(enc, 0, Game.GetEnteringObject())
   end
end

function ta_enc_exhaust(enc)
   enc:SetLocalInt("ssp_spawned", 0)
end

for f in lfs.dir(dir) do
   if string.find(f:lower(), ".lua", -4)  then
      local file = lfs.currentdir() .. "/" .. dir .. f
      Log:info("Loading Encounter: %s", file)
      local tag = E.Load(file)
   end
end
