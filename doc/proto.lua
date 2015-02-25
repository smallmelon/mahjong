-- short socket proto 
local proto = [[

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
        net 3 : integer
        sign 4 : string
    }
    response {
        code 0 : integer
        uid 1 : integer
        token 2 : integer
        host 3 : string
        port 4 : string
        time 5 : integer
        password 6 : string
        systime 7 : integer
    }
}

login 5 {
    request {
        uid 0 : integer
        password 1 : string
        channel 2 : integer
        net 3 : integer
        sign 4 : string
    }
    response {
        code 0 : integer
        uid 1 : integer
        token 2 : integer
        host 3 : string
        port 4 : string
        time 5 : integer
        systime 6 : integer
    }
}

version 7 {
    request {
        uuid 0 : string
        channel 1 : integer
        type 2 : integer
        appVer 3 : string
        resVer 4 : string
        sign   5 : string
    }
    response {
        appVer 0 : string
        appUrl 1 : string
        appVer 2 : string
        resUrl 3 : string
    }    
}
]]