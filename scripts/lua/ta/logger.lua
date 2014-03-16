require 'logging'
require 'logging.file'

local M = {}
M.Log = logging.file(OPT.LOG_DIR .. "/ta_log.txt")
return M
