local redis = require 'redis'
local client = redis.connect('127.0.0.1', 6379)

local function GetClient()
  return client
end

local M = {}
M.GetClient = GetClient
return M