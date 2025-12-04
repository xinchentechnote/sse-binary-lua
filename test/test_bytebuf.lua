package.path = "./?.lua;./submodules/luaunit/?.lua;" .. package.path

local luaunit = require("luaunit")
local ByteBuf = require("codec")

TestByteBuf = {}

function TestByteBuf:testWriteReadInt()
    local buf = ByteBuf:new()
    buf:writeInt(20251204)
    buf:writeInt(12345678)
    assertEquals(buf:readInt(), 20251204)
    assertEquals(buf:readInt(), 12345678)
end

function TestByteBuf:testWriteReadShort()
    local buf = ByteBuf:new()
    buf:writeShort(65535)
    buf:writeShort(1024)
    assertEquals(buf:readShort(), 65535)
    assertEquals(buf:readShort(), 1024)
end

function TestByteBuf:testWriteReadFixedString()
    local buf = ByteBuf:new()
    buf:writeFixedString("HELLO", 8)
    buf:writeFixedString("WORLD", 5)
    assertEquals(buf:readFixedString(8), "HELLO")
    assertEquals(buf:readFixedString(5), "WORLD")
end

function assertEquals(a,b)
    luaunit.assertEquals(a,b)
end

os.exit(luaunit.LuaUnit.run())
