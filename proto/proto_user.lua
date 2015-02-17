local sprotoparser = require "sprotoparser"

local proto = {}

proto.c2s = sprotoparser.parse [[
.package {
    type 0 : integer
    session 1 : integer
}

handshake 1 {
    response {
        msg 0  : string
    }
}

register 4 {
    request {
        uuid 0 : string
        device 1 : string
        channel 2 : integer
    }
    response {
        uid 0 : integer
        passwd 1 : string
        key 2 : string
    }
}

login 5 {
    request {
        uid 0 : integer
        key 1 : string
    }
    response {
        code 0 : integer
    }
}


player 6 {
    request {
        uid 0 : integer
    }
    response {
        code 0 : integer
        nickname 1 : string
        gold 2 : integer
    }
}

]]

proto.s2c = sprotoparser.parse [[
.package {
    type 0 : integer
    session 1 : integer
}

heartbeat 1 {}
]]

return proto
