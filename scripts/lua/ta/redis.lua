local redis = require 'redis'
local client = redis.connect(OPT.REDIS_SOCKET)

if #OPT.REDIS_PASSWORD > 0 then
  client:auth(OPT.REDIS_PASSWORD)
end

local function GetClient()
  return client
end

local M = {}
M.GetClient = GetClient
return M