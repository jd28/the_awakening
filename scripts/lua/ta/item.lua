--- Functions
-- @section

local _ITEMS = {}
local Dyn = require 'ta.dynamo'
local ip = require 'solstice.itemprop'

local env_mt = { __index = Dyn.Capture }

local M = {}

function env_mt.Item(tbl)
   _ITEMS[assert(tbl.resref)] = tbl
   return tbl
end


--- Load item file.
-- @param file Item file to load.
function M.Load(file)
   local t   = setmetatable({
         Item = env_mt.Item
      }, env_mt)
   local res = runfile(file, t)
end

--- Generate item
-- @param object Object to create item on.
-- @param resref Resref of item to create.
-- @param[opt=false] max If true, the maximum value of an
-- item property parameter.
-- @see solstice.item.Load
function M.Generate(object, resref, max)
   local item = _ITEMS[resref]

   local it = object:GiveItem(resref)
   if not it:GetIsValid() then
      error("Invalid item: Resref: " .. resref)
   end
   if not item then return end

   -- This probably could be done in a better fashion...

   if item.value then
      it:SetGoldValue(item.value)
   end

   for _, p in ipairs(item.properties) do
      local f = p.f
      if not f then
         error "No item property function!"
      end

      local t = {}
      for _, v in ipairs(p) do
         local val = Dyn.GetValue(v, max)
         table.insert(t, val)
      end

      local count = p.n or 1
      for i = 1,count do
         if not p.chance or math.random(1, 100) <= p.chance then
            local func = ip[f]
            if not func then
               error(string.format("No such funtion: %s\n%s", f, debug.traceback()))
            end
            it:AddItemProperty(DURATION_TYPE_PERMANENT, func(unpack(t)))
         end
      end
   end
   return it
end

function M.Test(resref, max)
   local item = _ITEMS[resref]
   local ips  = Dyn.flatten(item.properties, OBJECT_INVALID)
   local res = { "Item: "..resref }

   for _, p in ipairs(ips) do
      local t = {}
      for _, v in ipairs(p) do
         local val = Dyn.GetValue(v, max)
         table.insert(t, val)
      end

      table.insert(res, p.f .. "(" .. table.concat(t, ', ') .. ")")
   end

   return table.concat(res, '\n')
end

function M.List()
   local t = {}
   for k, _ in pairs(_ITEMS) do
      table.insert(t, k)
   end
   return table.concat(t, '\n')
end

return M
