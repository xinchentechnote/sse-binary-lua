-- lua/bytebuf.lua
local ByteBuf = {}
ByteBuf.__index = ByteBuf

function ByteBuf:new()
    return setmetatable({chunks = {}, read_pos = 1}, ByteBuf)
end

-- 写入原始二进制字符串
function ByteBuf:write(bin)
    table.insert(self.chunks, bin)
end

-- 写入 int32 大端
function ByteBuf:writeInt(n)
    local bin = string.char(
        math.floor(n / 16777216) % 256,
        math.floor(n / 65536) % 256,
        math.floor(n / 256) % 256,
        n % 256
    )
    self:write(bin)
end

-- 写入 int16 大端
function ByteBuf:writeShort(n)
    local bin = string.char(math.floor(n / 256) % 256, n % 256)
    self:write(bin)
end

-- 写入固定长度字符串，不足补 0
function ByteBuf:writeFixedString(s, len)
    s = s or ""
    if #s > len then s = s:sub(1,len) end
    s = s .. string.rep("\0", len - #s)
    self:write(s)
end

-- 读取完整二进制
function ByteBuf:toBinary()
    return table.concat(self.chunks)
end

-- 内部函数：确保缓冲区已经合并
local function getBuffer(self)
    if not self._buf then
        self._buf = table.concat(self.chunks)
    end
    return self._buf
end

-- 读取 int32 大端
function ByteBuf:readInt()
    local buf = getBuffer(self)
    local b1,b2,b3,b4 = buf:byte(self.read_pos, self.read_pos+3)
    self.read_pos = self.read_pos + 4
    return b1*16777216 + b2*65536 + b3*256 + b4
end

-- 读取 int16 大端
function ByteBuf:readShort()
    local buf = getBuffer(self)
    local b1,b2 = buf:byte(self.read_pos, self.read_pos+1)
    self.read_pos = self.read_pos + 2
    return b1*256 + b2
end

-- 读取固定长度字符串
function ByteBuf:readFixedString(len)
    local buf = getBuffer(self)
    local s = buf:sub(self.read_pos, self.read_pos + len -1)
    self.read_pos = self.read_pos + len
    -- 去掉末尾补的 \0
    return s:gsub("%z+$","")
end

return ByteBuf
