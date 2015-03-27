local skynet = require "skynet"
local snax = require "snax"


local db_pool = {}

function init(cf)
    for i = 1, 2 do 
        local db = snax.newservice("mod_mysql", cf, 10)
        db_pool[i] = db.handle
    end
end

function exit()
    for i = 1, #db_pool do
        local db = snax.bind(db_pool[i], "mod_mysql")
        snax.kill(db)
    end
    db_pool = {}
end

function response.acquire()
    return db_pool
end