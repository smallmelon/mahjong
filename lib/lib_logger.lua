local skynet = require "skynet"
local string = require "string"
local lib_time = require "lib_time"
local netpack = require "netpack"
local core = require "skynet.core"
local snax = require "snax"
local lib_utils = require "lib_utils"

local Logger = {
    level = 0,
    logger = nil,
    time = nil,
    file = "",
    filename = "",
    levels = { "DEBUG", "INFO", "WARN", "ERROR","FATAL" }
}

function Logger:init()
    snax.uniqueservice("mod_logger_sup")
end

function Logger:new(file)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.time = lib_time:new()
    o.file = file
    o.logger_sup = snax.queryservice("mod_logger_sup")
    o:open()
    return o
end

function Logger:open()
    local date = self.time:date("%x")
    local file = self.file.."-"..date..".log"
    local logger = self.logger_sup.req.get(file)
    if not logger then
        logger = self.logger_sup.req.create(file)
    end
    self.filename = file
    self.logger = logger
end

function Logger:set_level(level)
    self.level = level
end

function Logger:log(level, ... )
    local time = lib_time:new()
    local date = time:date()
    
    local s = lib_utils.format(...)
    s = string.format("[%s] [%s] %s", date, self.levels[level], s)
    core.send(self.logger, 0, 0, s)    

    if time:date("%d") ~= self.time:date("%d") then
        self.logger_sup.post.close(self.filename)
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

