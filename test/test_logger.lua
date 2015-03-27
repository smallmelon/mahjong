local logger = require "lib_logger"
local skynet = require "skynet"
local cf = ...
local lib_utils = require "lib_utils"


skynet.start(function ()
    local log = logger:new("./mahjong/logs/test")
    function f ()
        print(cf)
        log:debug("debug log %s", lib_utils.format(1,2,2,23,23))
        log:warn("warn log %s", lib_utils.format_dict({a = 12, b = 12, c = "love you"}))
        log:info("info log"..cf)
        log:error("error log"..cf)
        log:fatal("fatal log"..cf) 
        skynet.timeout(300, f)
    end
    skynet.timeout(300, f)
end)