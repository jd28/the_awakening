command = "relog"

function action(info)
   local pc = info.speaker
   pc:ActivatePortal("173.255.209.70:5121", "", "", false)
end
