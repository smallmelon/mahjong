local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local sproto = require "sproto"
local bit32 = require "bit32"

-- request process
local pp_player = require "pp_player"
local pp_game = require "pp_game"

local host
local send_request

local CMD = {}
local REQUEST
local client_fd

local client = {
    fd = nil,
    player = nil,
    auth = false
}

-- first auth
-- game process

local function request(name, args, response)
    local f = REQUEST[name]
    if not f then
        if client.auth then
            REQUEST = pp_game
            f = assert(REQUEST(name))
        else
            print("user not pass auth")
            socket.close(client_fd)
            skynet.exit()
        end
    end
    local r = f(args, client) -- args self, clien
    if response then
        return response(r)
    end
end

local function send_package(pack)
    local size = #pack
    local package = string.char(bit32.extract(size,8,8)) ..
        string.char(bit32.extract(size,0,8))..
        pack

    socket.write(client_fd, package)
end

skynet.register_protocol {
    name = "client",
    id = skynet.PTYPE_CLIENT,
    unpack = function (msg, sz)
        return host:dispatch(msg, sz)
    end,
    dispatch = function (_, _, type, ...)
        if type == "REQUEST" then
            local ok, result  = pcall(request, ...)
            if ok then
                if result then
                    send_package(result)
                end
            else
                skynet.error(result)
            end
        else
            assert(type == "RESPONSE")
            error "This example doesn't support request client"
        end
    end
}

function CMD.start(gate, fd, proto)
    host = sproto.new(proto.c2s):host "package"
    send_request = host:attach(sproto.new(proto.s2c))
    REQUEST = pp_player
    skynet.fork(function()
        while true do
            send_package(send_request "heartbeat")
            print ("heartbeat")
            skynet.sleep(500)
        end
    end)

    client_fd = fd
    client.fd = fd
    skynet.call(gate, "lua", "forward", fd)
end

function CMD.close( ... )
    -- client close socket event
    print("agent client socket close", client_fd)
    skynet.exit()
end


skynet.start(function()
    skynet.dispatch("lua", function(_,_, command, ...)
        local f = CMD[command]
        skynet.ret(skynet.pack(f(...)))
    end)
end)
