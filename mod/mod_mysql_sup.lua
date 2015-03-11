local skynet = require "skynet"
local snax = require "snax"


local db_pool = {}

function init(cf)
    for i = 1, 5 do 
        local db = snax.newservice("mod_mysql", cf)
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
    if #db_pool > 0 then
        return table.remove(db_pool, 1)
    end
    return 0
end

function accept.release(handle)
    table.insert(db_pool, handle)
end