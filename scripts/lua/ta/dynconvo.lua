local NWNXEv = require 'solstice.nwnx.events'

local DYNCONV_NEXT_NODE     = 7
local DYNCONV_PREVIOUS_NODE = 8
local DYNCONV_UNDO_NODE     = 9
local DYNCONV_ACCEPT_NODE   = 10
local DYNCONV_BACK_NODE     = 11

local Page = {}
Page.__index = Page

function Page.__tostring(p)
   local t = {}
   for i, it in ipairs(p.items) do
      table.insert(t, string.format("%d.   %s", i, it[1]))
   end
   return table.concat(t, '\n')
end

function Page:Size()
   return table.getn(self.items)
end

function Page:AddItem(item, value)
   self.items = self.items or {}
   table.insert(self.items, {item, value})
   return self
end

function Page:Dump(from)
   for i = from and from or 1, #self.items do
      print (i, self.items[i][1], self.items[i][2])
   end
end

function Page:Clear()
   self.items = {}
end

function Page:Sort()
   table.sort(self.items, function(a, b) return a[1] < b[1] end)
end

function Page:Get(index)
   if index > #self.items then return end
   return self.items[index]
end

function Page:SetUndoHandler(func)
   assert(type(func) == 'function', 'ERROR: Undo Handler be a function!')
   self.undo_handler = func
   return self
end

function Page:SetAcceptHandler(func)
   assert(type(func) == 'function', 'ERROR: Accept Handler be a function!')
   self.accept_handler = func
   return self
end

function Page:SetAccetpable(accept)
   self.acceptable = accept
   return self
end

function Page:SetBuilder(func, refresh)
   assert(type(func) == 'function', 'ERROR: Builder must be a function!')
   self.builder = func
   self.builder_refresh = refresh
   return self
end

function Page:SetSelectHandler(func)
   self.apply = func
end

function Page:SetBack(func)
   self.back = func
end

function Page:SetNext(func)
   self.next = func
end

function Page:SetPrompt(prompt)
   self.prompt = prompt
end

function Page.new(prompt)
   local t = {
      prompt = prompt,
      items  = {}
   }
   setmetatable(t, Page)
   return t
end

local _DYNCONVOS = {}

local DynConvo = {}
DynConvo.__index = DynConvo

function DynConvo.new(name, cache)
   if cache then
      local convo = _DYNCONVOS[name]
      if not convo then
         convo = {}
         setmetatable(convo, DynConvo)
         _DYNCONVOS[name] = convo
         return convo
      else
         return convo, true
      end
   else
      local convo = {}
      setmetatable(convo, DynConvo)
      return convo
   end
end

function DynConvo:AddPage(page, prompt, nextpage, apply)
   assert(page and type(page) == 'string', 'ERROR: No page name specified')
   assert(prompt and type(prompt) == 'string', 'ERROR: No prompt specified')

   self.pages = self.pages or {}
   self.pages[page] = Page.new(prompt)
   self.pages[page].next = nextpage
   self.pages[page].apply = apply
   return self.pages[page]
end

function DynConvo:GetPage(page)
   local res = assert(self.pages[page], "ERROR: No page found!")
   return res
end

function DynConvo:SetPage(pagename, newpage)
   self.pages[pagename] = newpage
end

function DynConvo:ChangePage(page, delay)
   if type(page) == 'function' then
      page, delay = page()
   end

   if delay then
      local pc = Game.GetPCSpeaker()
      pc:ActionPauseConversation()
      pc:DelayCommand(delay, function() pc:ActionResumeConversation() end)
   end

   local res = assert(self.pages[page], "ERROR: No page found!")
   if res.builder then
      if res.builder_refresh or not res.built then
         res:Clear()
         res.built = true
         res.builder(res, self)
      end
   end
   self.current_page = res
   self.current_pos  = 1
end

function DynConvo:GetCurrentPage()
   assert(self.current_page)
   return self.current_page
end

function DynConvo:HasNext()
   if self.current_page:Size() - self.current_pos > 7 then
      return true
   end
   return false
end

function DynConvo:HasPrevious()
   return self.current_pos and self.current_pos ~= 1
end

function DynConvo:Next()
   if not self:HasNext() then return false end
   self.current_pos = self.current_pos + 7
   return true
end

function DynConvo:Previous()
   if not self:HasPrevious() then return false end
   if not self.current_pos or self.current_pos == 1 then return end
   self.current_pos = self.current_pos - 7
   return true
end

function DynConvo:SortPages()
   for _, p in pairs(self.pages) do
      p:Sort()
   end
end

function DynConvo:DumpView()
   self.current_page:Dump(self.current_pos)
end

function DynConvo:Select(entry)
   if entry < 0 or entry > 12 then
      error "ERROR: Invalid Index!"
   end
   local cp = self:GetCurrentPage()

   if entry == DYNCONV_NEXT_NODE then
      self:Next()
   elseif entry == DYNCONV_PREVIOUS_NODE then
      self:Previous()
   elseif entry == DYNCONV_UNDO_NODE then
      if cp.undo_handler then
         cp.undo_handler(cp)
      end
   elseif entry == DYNCONV_ACCEPT_NODE then
      -- If there is no next page, assume conversation has ended.
      if cp.accept_handler then
         cp.accept_handler(cp)
      end
      if cp.next then
         self:ChangePage(cp.next)
      else
         self:Ended(Game.GetPCSpeaker())
      end
   elseif entry == DYNCONV_BACK_NODE then
      if cp.back then
         self:ChangePage(cp.back)
      end
   else
      local it = cp:Get(self.current_pos + entry)
      if cp.apply then
         cp.apply(self, it)
      end
   end
end

function DynConvo:SetCurrentNodeText()
   local node = NWNXEv.GetCurrentNodeID()

   if node >= DYNCONV_NEXT_NODE then
      if node == DYNCONV_NEXT_NODE and self:HasNext() then
         return true
      elseif node == DYNCONV_PREVIOUS_NODE and self:HasPrevious() then
         return true
      elseif node == DYNCONV_UNDO_NODE and self.current_page.undo_handler then
         return true
      elseif node == DYNCONV_ACCEPT_NODE and self.current_page.acceptable then
         return true
      elseif node == DYNCONV_BACK_NODE and self.current_page.back then
         return true
      end

      return false
   end

   local it = self.current_page:Get(self.current_pos + node)
   if not it then return false end

   local str
   if type(it[1]) == 'string' then
      str = it[1]
   else
      str = it[1](it)
   end

   NWNXEv.SetCurrentNodeText(str, 0, 0)

   return true
end

function DynConvo:SetCurrentPrompt()
   NWNXEv.SetCurrentNodeText(self.current_page.prompt, 0, 0)
   return true
end

function DynConvo:SetConverser(with)
   self.converser = with
end

function DynConvo:SetSpeaker(pc)
   self.speaker = pc
end

function DynConvo:GetSpeaker()
   return assert(self.speaker)
end

local _ACTIVE_CONVOS = {}
function DynConvo.GetActiveConversation(obj)
   return _ACTIVE_CONVOS[obj.id]
end

function DynConvo.Start(pc, with, conv, private,
                        play_hello, zoom)
   if private == nil then private = true end
   if play_hello == nil then play_hello = true end

   assert(conv)

   _ACTIVE_CONVOS[pc.id] = conv
   local dlg = zoom and "dync_converse" or "dync_converse_nz"

   if with.type == OBJECT_TRUETYPE_ITEM then
      with = pc
      conv:SetConverser(pc)
   else
      conv:SetConverser(with)
   end
   conv:SetSpeaker(pc)
   with:ActionStartConversation(pc, dlg, private, play_hello)
end

function DynConvo:Finish(obj)
   self.finished = true
   if self.finished_handler then
      self.finished_handler(obj)
   end
   _ACTIVE_CONVOS[obj.id] = nil
end

function DynConvo:Abort(obj)
   self.aborted = true
   if self.aborted_handler then
      self.aborted_handler(obj)
   end
   _ACTIVE_CONVOS[obj.id] = nil
end

function DynConvo:Ended(obj)
   self.ended = true
end

function DynConvo:SetFinishedHandler(f)
   assert(type(f) == 'function')
   self.finished_handler = f
end

function DynConvo:SetAbortedHandler(f)
   assert(type(f) == 'function')
   self.aborted_handler = f
end

-- Global exports

function dnyc_dlg_prompt()
   local obj = Game.GetPCSpeaker()
   local conv = DynConvo.GetActiveConversation(obj)
   if conv.finished or conv.aborted or conv.ended then
      return false
   end
   return conv:SetCurrentPrompt()
end

function dnyc_dlg_check()
   local obj = Game.GetPCSpeaker()
   local conv = DynConvo.GetActiveConversation(obj)
   if conv.finished or conv.aborted or conv.ended then
      return false
   end
   return conv:SetCurrentNodeText()
end

function dync_dlg_do()
   local obj  = Game.GetPCSpeaker()
   local conv = DynConvo.GetActiveConversation(obj)
   local node = NWNXEv.GetSelectedNodeID()
   conv:Select(node)
end

function dync_dlg_abort()
   local obj = Game.GetPCSpeaker()
   local conv = DynConvo.GetActiveConversation(obj)
   conv:Abort(obj)
end

function dync_dlg_end()
   local obj = Game.GetPCSpeaker()
   local conv = DynConvo.GetActiveConversation(obj)
   conv:Finish(obj)
end

return DynConvo
