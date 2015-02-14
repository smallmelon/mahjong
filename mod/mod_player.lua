local snax = require "snax"

local player = {uid = 0}

function init( p)
    player = p
end

function exit( )
    player = {}
end

function response.get()
    return player
end

function response.set(p)
    player = p
    return true
end