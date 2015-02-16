local skynet = require "skynet"
local string = require "string"
local lib_time = require "lib_time"
local netpack = require "netpack"
local core = require "skynet.core"


local Logger = {
    level = 0,
    logger = nil,
    time = nil,
    file = "",
    levels = { "DEBUG", "INFO", "WARN", "ERROR","FATAL" }
}



function Logger:new(file)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.time = lib_time:new()
    o.file = file
    o:open()
    return o
end

function Logger:open()
    local date = self.time:date("%x")
    local file = self.file.."-"..date..".log"
    print(file)
    self.logger = skynet.launch("logger", file)
end

function Logger:set_level(level)
    self.level = level
end

function Logger:log(level, ... )
    local s = string.format(...)
    local time = lib_time:new()
    local date = time:date()

    s = "[" .. date .. "] [" .. self.levels[level] .. "] " .. s
    core.send(self.logger, 0, 0, s)    

    if time:date("%d") ~= self.time:date("%d") then
        skynet.kill(self.logger)
        self.time = time
        self:open()
    end
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

