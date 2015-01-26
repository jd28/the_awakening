local insert = table.insert
local fmt = string.format
local db = System.GetDatabase()

function ta_update_kills(pc)
   if string.find(pc:GetName(), '%[TEST%]') then return end
   local s = [[INSERT INTO pwdata (tag, name, val)
               VALUES (?, ?, ?)
               ON DUPLICATE KEY UPDATE
               val = VALUES(val)]]
   local sth = assert(db:prepare(s))
   local props = pc:GetAllProperties()
   if not props then return end
   for k, v in pairs(props) do
      if k:starts('kill_') then
         sth:execute(pc:GetTag(), k, v)
      end
   end

   sth:close()
end

function ta_load_kills(pc)
   if string.find(pc:GetName(), '%[TEST%]') then return end
   local s = [[SELECT name, val FROM pwdata WHERE name LIKE '%%kill_%%' and tag=?]]
   local sth = assert(db:prepare(s))
   sth:execute(pc:GetTag())
   for row in sth:rows() do
      pc:SetProperty(row[1], tonumber(row[2]))
   end
   sth:close()
end
