local TLK = require 'tlk'

local tlk = TLK.load('ta_tlk_v01.tlk')
tlk:ToFile("ta_tlk_v01.tlk.lua")
TLK.close(tlk)
