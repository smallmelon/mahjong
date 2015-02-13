local skynet = require "skynet"
local redis = require "redis"

local conf = {
    host = "127.0.0.1" ,
    port = 6380 ,
    db = 0,
    auth = "_jiami2013"
}

local db
local command = {}


skynet.start(function()
    db = redis.connect(conf)
    print(db:set("mykey", "aaa"))
    print(db:get("mykey"))
    skynet.dispatch("lua", function(session, address, cmd, ...)
        local f = command[string.upper(cmd)]
        if f then
            skynet.ret(skynet.pack(f(...)))
        else
            error(string.format("Unknown command %s", tostring(cmd)))
        end
    end)
    skynet.register "SIMPLEDB"
end)


