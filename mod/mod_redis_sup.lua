local skynet = require "skynet"
local string = require "string"
local snax = require "snax"


local db_pool = {}


function hash_key(key)
    local value = 0
    for i=1, #key do
        value = value + string.byte(key, i)
    end
    return value
end

function choice_pos(...)
    local hash_value = hash_key(select(1, ...))
    return hash_value % (#db_pool) + 1
end


function init(cf)
    for i = 1, #cf do
        local dbs = {}
        for j = 1, 3 do
            local db = snax.newservice("mod_redis", cf[i])
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

function response.acquire(...)
    local pos = choice_pos(...)
    local dbs = db_pool[pos]
    if #dbs > 0 then
        return table.remove(dbs, 1), pos
    end
    return 0, 0
end

function accept.release(handle, pos)
    local dbs = db_pool[pos]
    table.insert(dbs, handle)
end 