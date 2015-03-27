local skynet = require "skynet"
local string = require "string"
local snax = require "snax"


local db_pool = {}

function init(cf)
    for i = 1, #cf do
        local dbs = {}
        for j = 1, 2 do
            local db = snax.newservice("mod_redis", cf[i], 10)
            dbs[j] = db.handle
        end
        db_pool[i] = dbs
    end
end


function exit()
    for i = 1, #db_pool do
        local dbs = db_pool[i]
        for j = 1, #dbs do
            local db = snax.bind(dbs[j], "mod_redis")
            snax.kill(db)
        end
    end
    db_pool = {}
end

function response.acquire()
    return db_pool
end