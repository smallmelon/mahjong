local snax = require "snax"
local skynet = require "skynet"

local logger = {}

function init( ... )
end

function exit( ... )
    for k,v in pairs(logger) do
        skynet.kill(v)
    end
end

function response.get(filename)
    return logger[filename]
end

function response.create(filename)
    local log = logger[filename]
    if not log then
        log = skynet.launch("logger", filename)
        logger[filename] = log
    end
    return log
end

function accept.close(filename)
    if logger[filename] then
        skynet.kill(logger[filename])
        logger[filename] = nil
    end
end