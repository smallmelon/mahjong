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

login 2 {
    request {
        ver 0 : integer
        token 1 : string
    }
    response {
        code 0 : integer
    }
}


enter 3 {
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

enter 2 {
    request {
        uid 0: integer
    }
}
]]


return proto
