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
        uid 0 : integer
        passwd 1 : string
    }
    response {
        code 0 : integer
        gold 1 : integer
        diamond 2 : integer
        icon_url 3 : string
        sex 4 : integer
        nickname 5 : string
        uid 6 : integer
    }
}

user_register 3 {
    request {
        uuid 0 : string
        channel 1 : integer
    }
    response {
        code 0 : integer
        uid 1 : integer
    }
}

seat_enter 4 {
    request {
        uid 0 : integer
    }
    response {
        code 0 : integer
    }
}

seat_leave 5 {
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

user_push 2 {
    request {
        uid 0 : integer
        name 1 : string
    }
}

seat_enter 3 {
    request {
        uid 0 : integer
    }
}
]]


return proto
