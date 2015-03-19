local skynet = require "skynet"
local string = require "string"
local snax = require "snax"


local db_pool = {
    count = nil
}


function hash_key(key)
    local value = 0
    for i=1, #key do
        value = value + string.byte(key, i)
    end
    return value
end

function get_uid(key)
    local pos = string.find(key, "uid:")
    if pos then
        return tonumber(string.sub(key, pos + 4, #key))
    end
    return false
end

function choice_pos(key)
    local uid = get_uid(key)
    if not uid then
        uid = hash_key(key)
    end
    return uid % db_pool.count + 1
end


function init(cf)
    db_pool.count = #cf
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

function response.acquire(key)
    local pos = choice_pos(key)
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