local os = require "os"
local skynet = require "skynet"
local string = require "string"

local Time = {
    time = 0
}

function Time:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.time = skynet.time()
    return o
end

function Time:now( )
    return self.time
end

function Time:date(fmt, time)
    local s 
    if not fmt then
        s =  os.date("%x %X",self.time)
    elseif not time then
        time = self.time
        s = os.date(fmt, time)
    end
    return string.gsub(s, "/", "-")
end

return Time