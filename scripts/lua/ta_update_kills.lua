local insert = table.insert
local fmt = string.format

function ta_update_kills(pc)
   if not OPT.dbcon then return end
   if string.find(pc:GetName(), '%[TEST%]') then return end
   local vars = pc:GetAllVars('^kill', VARIABLE_TYPE_INT)
   local s = [[INSERT INTO pwdata (tag, name, val)
               VALUES
               ('%s', '%s', '%s')
               ON DUPLICATE KEY UPDATE
               val='%s';]]

   for k, v in pairs(vars) do
      if k:starts('killg_') then
         local res = assert(OPT.dbcon:execute(fmt(s,
                                                  pc:GetLocalString('pc_player_name'),
                                                  k,
                                                  tostring(v),
                                                  tostring(v))))
      elseif k:starts('kill_') then
         local res = assert(OPT.dbcon:execute(fmt(s,
                                                  pc:GetTag(),
                                                  k,
                                                  tostring(v),
                                                  tostring(v))))
      end
   end
end

function ta_load_kills(pc)
   local s = fmt("SELECT name,val from pwdata where `name` LIKE '%%kill_%%' AND tag='%s'",
                 pc:GetTag())
   local cur = assert(OPT.dbcon:execute(s))
   local i = cur:numrows()
   local row = cur:fetch({}, 'a')
   while row and i > 0 do
      pc:SetLocalInt(row.name, tonumber(row.val))
      row = cur:fetch(row, 'a')
      i = i - 1
   end

   s = fmt("SELECT name,val from pwdata where `name` LIKE '%%killg_%%' AND tag='%s'",
           pc:GetLocalString('pc_player_name'))
   cur = assert(OPT.dbcon:execute(s))
   i = cur:numrows()
   row = cur:fetch({}, 'a')
   while row and i > 0 do
      pc:SetLocalInt(row.name, tonumber(row.val))
      row = cur:fetch(row, 'a')
      i = i - 1
   end
end
