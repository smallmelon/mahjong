local sprotoparser = require "sprotoparser"

local proto = {}

proto.c2s = sprotoparser.parse [[
.package {
    type 0 : integer
    session 1 : integer
}

user_handshake 1 {
    response {
        msg 0  : string
    }
}

user_login 2 {
    request {
        ver 0 : integer
        token 1 : string
    }
    response {
        code 0 : integer
    }
}


seat_enter 3 {
    request {
        uid 0 : integer
    }
    response {
        code 0 : integer
    }
}


]]

proto.s2c = sprotoparser.parse [[
.package {
    type 0 : integer
    session 1 : integer
}

heartbeat 1 {}

seat_enter 2 {
    request {
        uid 0: integer
    }
}
]]


return proto
