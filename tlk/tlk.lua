local ffi = require 'ffi'
local tinsert = table.insert
local fmt = string.format
local bit = require 'bit'

ffi.cdef[[
size_t fread (void *ptr, size_t size, size_t n, void* stream);
size_t fwrite ( const void * ptr, size_t size, size_t count, void * stream );
static const int SEEK_SET = 0;
int fseek ( void * stream, long int offset, int origin );
]]

ffi.cdef[[

struct TLKHeader {
   char     type[4];
   char     version[4];
   int32_t  lang;
   int32_t  str_count;
   int32_t  str_offset;
};

struct TLKEntry {
   int32_t  flags;
   char     sound_resref[16];
   int32_t  vol_variance;
   int32_t  pitch_variance;
   int32_t  offset;
   int32_t  size;
   float    sound_length;
};

]]

local function strip_null(str)
   for i = 1, #str do
      if string.byte(str, i) == 0 then
         return string.sub(str, 1, i-1)
      end
   end
   return str
end

local function runfile(scriptfile, env)
   env = env or setmetatable({}, {__index=_G})
   assert(pcall(setfenv(assert(loadfile(scriptfile)), env)))
   setmetatable(env, nil)
   return env
end

local tlk_mt = {}
tlk_mt.__index = tlk_mt

function tlk_mt:Add(index, str, sound, vol_variance, pitch_variance,
                    sound_length)
   self.table = self.table or {}
   self.table[index] = {
      text           = str or '',
      sound_resref   = sound or '',
      vol_variance   = vol_variance or 0,
      pitch_variance = pitch_variance or 0,
      sound_length   = sound_length or 0.0,
   }
end

-- If start is not present attempt to override.
function tlk_mt:Inject(tlk, start)
   local t = tlk:ToTable()
   local i = 0
   for j = 0, table.maxn(t) do
      if t[j] then
         local idx
         if start then
            idx = start + i
            i = i + 1
         else
            idx = k
         end
         self:Add(idx, v.text, v.sound_resref, v.vol_variance,
                  v.pitch_variance, v.sound_length)
      end
   end
end

function tlk_mt:GetString(i)
   if not self.table or not self.table[i] then
      if not self.entries then return end
      local entry = self.entries[i]
      local soff = self.header.str_offset + entry.offset

      if entry.size > 0 then
         ffi.C.fseek(self.f, soff, ffi.C.SEEK_SET)
         local s = ffi.new('char[?]', entry.size + 1)
         local res = ffi.C.fread(s, entry.size, 1, self.f)
         return ffi.string(s, entry.size)
      end
   else
      return self.table[i].text
   end
end

function tlk_mt:GetSoundResref(i)
   if not self.table or not self.table[i] then
      return strip_null(ffi.string(self.entries[i].sound_resref, 16))
   else
      return self.table[i].sound_resref
   end
end

function tlk_mt:GetVolumeVariance(i)
   if not self.table or not self.table[i] then
      return self.entries[i].vol_variance
   else
      return self.table[i].vol_variance
   end
end

function tlk_mt:GetPitchVariance(i)
   if not self.table or not self.table[i] then
      return self.entries[i].pitch_variance
   else
      return self.table[i].pitch_variance
   end
end

function tlk_mt:GetSoundLength(i)
   if not self.table or not self.table[i] then
      return self.entries[i].sound_length
   else
      return self.table[i].sound_length
   end
end

function tlk_mt:ToTable()
   local res = {}
   local count = self.header.str_count - 1
   if self.table then
      count = math.max(count, table.maxn(self.table))
   end
   for i = 0, count do
      local s = self:GetString(i)
      if s then
         res[i] = {}
         res[i].text           = s
         res[i].sound_resref   = self:GetSoundResref(i)
         res[i].vol_variance   = self:GetVolumeVariance(i)
         res[i].pitch_variance = self:GetPitchVariance(i)
         res[i].sound_length   = self:GetSoundLength(i)
      end
   end
   return { entries = res }
end

function tlk_mt:ToString()
   local tbl = self:ToTable()
   local t   = tbl.entries
   local res = {}
   tinsert(res, "entries = {")
   for i = 0, table.maxn(t) do
      if t[i] then
         local s = t[i].text
         s = string.gsub(s, "\n", "\\n") or s
         s = string.gsub(s, "'", "\\'") or s
         s = string.gsub(s, '"', '\\"') or s

         tinsert(res, fmt("   [%d] = { -- %d", i, i + 0x1000000))
         tinsert(res, fmt("      text = '%s',", s))
         tinsert(res, fmt("      sound_resref = '%s',", t[i].sound_resref))
         tinsert(res, fmt("      vol_variance = %d,", t[i].vol_variance))
         tinsert(res, fmt("      pitch_variance = %d,", t[i].pitch_variance))
         tinsert(res, fmt("      sound_length = %.2f,", t[i].sound_length))
         tinsert(res, "   },")
      end
   end
   tinsert(res, "}")
   return table.concat(res, "\n")
end

function tlk_mt:ToFile(file)
   local f = assert(io.open(file, "w"))
   f:write(self:ToString())
end

local function load(file)
   local tlk = {
      header = ffi.new("struct TLKHeader"),
      f = io.open(file),
   }
   assert(tlk.f)

   local res = ffi.C.fread(tlk.header, ffi.sizeof("struct TLKHeader"), 1, tlk.f)
   tlk.entries = ffi.new("struct TLKEntry[?]", tlk.header.str_count)
   res = ffi.C.fread(tlk.entries,
                     ffi.sizeof("struct TLKEntry"),
                     tlk.header.str_count,
                     tlk.f)

   return setmetatable(tlk, tlk_mt)
end

local function close(tlk)
   io.close(tlk.f)
end

local function from_table(file)
   local t = runfile(file, {})
   assert(table.maxn(t.entries) > 0)
   local tlk = {
      header = ffi.new("struct TLKHeader"),
      table  = t.entries,
   }
   ffi.copy(tlk.header.type, "TLK ")
   ffi.copy(tlk.header.version, "V3.0")
   return setmetatable(tlk, tlk_mt)
end

local function LuaToTlk(input, output)
   local t

   if type(input) == "table" then
      t = input
   elseif type(input) == "string" then
      t = runfile(input, {})
   else
      error("Invalid type.")
   end

   assert(table.maxn(t.entries) > 0)

   local tlk = {
      header = ffi.new("struct TLKHeader"),
      entries = ffi.new("struct TLKEntry[?]", table.maxn(t.entries) + 1)
   }
   tlk.header.str_offset = ffi.sizeof(tlk.header) + ffi.sizeof(tlk.entries)
   ffi.copy(tlk.header.type, "TLK ")
   ffi.copy(tlk.header.version, "V3.0")
   tlk.header.str_count = table.maxn(t.entries) + 1

   local str = {}
   local offset = 0
   for i=0, table.maxn(t.entries) do
      if t.entries[i] and #t.entries[i].text > 0 then
         tlk.entries[i].flags = 1
         if #t.entries[i].sound_resref > 0 then
            ffi.copy(tlk.entries[i].sound_resref,
                     t.entries[i].sound_resref,
                     math.min(16, #t.entries[i].sound_resref))
            tlk.entries[i].flags = bit.bor(tlk.entries[i].flags, 2)
         end

         tlk.entries[i].vol_variance   = t.entries[i].vol_variance
         tlk.entries[i].pitch_variance = t.entries[i].pitch_variance
         tlk.entries[i].sound_length   = t.entries[i].sound_length
         if t.entries[i].sound_length ~= 0 then
            tlk.entries[i].flags = bit.bor(tlk.entries[i].flags, 4)
         end

         tlk.entries[i].offset         = offset
         tlk.entries[i].size           = #t.entries[i].text
         offset = offset + #t.entries[i].text
         table.insert(str, t.entries[i].text)
      end
   end
   local out = io.open(output, "wb")
   ffi.C.fwrite(tlk.header, ffi.sizeof('struct TLKHeader'), 1, out)
   ffi.C.fwrite(tlk.entries, ffi.sizeof(tlk.entries), 1, out)
   local s = table.concat(str)
   ffi.C.fwrite(s, #s, 1, out)
   io.close(out)

end

-- Exports.
local M = {}
M.load = load
M.close = close
M.LuaToTlk = LuaToTlk
M.from_table = from_table
return M
