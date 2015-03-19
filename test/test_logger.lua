local logger = require "lib_logger"
local skynet = require "skynet"
local cf = ...
print(cf)

skynet.start(function ()
    local log = logger:new("./mahjong/logs/test")
    log:set_level(4)
    function f ()
        log:debug("debug log"..cf)
        log:warn("warn log"..cf)
        log:info("info log"..cf)
        log:error("error log"..cf)
        log:fatal("fatal log"..cf) 
        skynet.timeout(300, f)
    end
    skynet.timeout(300, f)
end)