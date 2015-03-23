local apps = { 93, 9, 175, 22, 15 }
function pl_corshift_001(obj)
   local app = math.random(#apps)
   obj:SetAppearanceType(apps[app])
end
