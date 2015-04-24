local Rules = require 'solstice.rules.constants'
local System = require 'solstice.system'
local c = io.open(OPT.SCRIPT_DIR .. '/constants.md')
local Log = System.GetLogger()

for l in c:lines() do
  local m, n = string.match(l, "* (%u[%w_]+) = (%w+)")
  if m then
    Rules.RegisterConstant(m, tonumber(n) or n)
  end
end

c:close()
