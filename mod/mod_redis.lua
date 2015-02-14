local skynet = require "skynet"
local redis = require "redis"
local snax = require "snax"
local string = require "string"

local conf1 = {
    host = "127.0.0.1" ,
    port = 6380 ,
    db = 0,
    auth = "_jiami2013"
}

local conf2 = {
    host = "127.0.0.1" ,
    port = 6379 ,
    db = 0,
    auth = "_jiami2013"
}

local db_pool = {}

function hash_key(key)
    local value = 0
    for i=1, #key do
        value = value + string.byte(key, i)
    end
    return value
end

function choice_db(...)
    local hash_value = hash_key(select(1, ...))
    return db_pool[hash_value % 2 + 1]
end


function init()
    db_pool[1] = redis.connect(conf1)
    db_pool[2] = redis.connect(conf2)
end

function exit( )
    local db = db_pool[1]
    db:close()
    db = db_pool[2]
    db:close()
end

function response.get( ... )
    local db = choice_db(...)
    return db:get(...)
end

function response.set( ... )
    local db = choice_db(...)
    return db:set(...)
end
