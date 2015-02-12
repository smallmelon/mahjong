local snax = require "snax"

local player = { uid = 0}

function init()
    -- init player  
    print("init player")  
end

function exit()
    
end

function response.load_from_redis(uid)
    -- body
    return true
end

function response.register(uid)
    return true
end

function reaspone.acquice_items(items)
    -- body
    return true
end

function response.hello( ... )
    -- body
    print(uid, "hello")
end