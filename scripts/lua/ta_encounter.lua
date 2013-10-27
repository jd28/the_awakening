local lfs = require 'lfs'
local ffi = require 'ffi'
local C = ffi.C

local Ev  = require 'solstice.event'
local E = require 'ta.encounter'

local dir = "lua/encounters/"

function ta_enc_enter(enc)
   if enc:GetIsValid()
      and enc.obj.enc_is_active == 1
      and not enc:GetLocalBool("ssp_spawned")
   then
      Enc.Spawn(enc, 0, Ev.GetEnteringObject())
   end
end

function ta_enc_exhaust(enc)
   enc:SetLocalBool("ssp_spawned", false)
end

for f in lfs.dir(dir) do
   if string.find(f:lower(), ".lua", -4)  then
      local file = lfs.currentdir() .. "/" .. dir .. f
      print("Loading: " .. file .. "\n")
      E.Load(file)
   end
end

print(E.Test('pl_drow_1'))