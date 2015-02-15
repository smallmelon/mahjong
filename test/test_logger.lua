local logger = require "lib_logger"

local test = {}

function  test:test( ... )
    log = logger:new("./mahjong/logs/test.log")
    log:set_level(4)
    log:debug("debug log")
    log:warn("warn log")
    log:info("info log")
    log:error("error log")
    log:fatal("fatal log")

end

return test