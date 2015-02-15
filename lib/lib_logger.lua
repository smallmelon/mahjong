local skynet = require "skynet"
local string = require "string"

local Logger = {
    level = 0,
    logger = nil,
    levels = { "DEBUG", "INFO", "WARN", "ERROR","FATAL" }
}

function Logger:new(file)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.logger = skynet.launch("logger", file)
    return o
end

function Logger:set_level(level)
    self.level = level
end

function Logger:log(level, ... )
    local s = string.format(...)
    skynet.send(self.logger, "lua", "[".. self.levels[level] .."] "..s) 
end

function Logger:debug( ... )
    if self.level > 1 then
        return
    end
    self:log(1, ...)
end

function Logger:info( ... )
    if self.level > 2 then
        return
    end
    self:log(2, ...)
end

function Logger:warn( ... )
    if self.level > 3 then
        return
    end
    self:log(3, ...)
end

function Logger:error( ... )
    if self.level > 4 then
        return
    end
    self:log(4, ...)
end

function Logger:fatal( ... )
    self:log(5, ...)
end


return Logger

