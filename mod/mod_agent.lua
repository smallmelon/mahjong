local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local sproto = require "sproto"
local bit32 = require "bit32"


-- request process
local pp_player = require "pp_player"
local pp_seat = require "pp_seat"

local host
local send_request

local CMD = {}
local REQUEST = { user = pp_player, seat = pp_seat} -- process proto array

local client = {
    fd = nil,
    player = nil,
    auth = false,
    seat = nil
}

function router(name)
    local pos = string.find(name, "_", 1, true)
    if pos then
        local pp = string.sub(name, 1, pos - 1)
        local cmd = string.sub(name, pos + 1, #name)

        if REQUEST[pp] and REQUEST[pp][cmd] then
            if pp == "user" or client.auth then
                return REQUEST[pp][cmd]
            end
        end
    end
    return nil
end

-- first auth
-- game process

local function request(name, args, response)
    local f = router(name)
    if not f then
        print("request", name)
        socket.close(client.fd)
        skynet.send(".watchdog", "lua", "close", client.fd)
        skynet.exit()
    end
    local r = f(client, args) 
    if response then
        return response(r)
    end
end

local function send_package(pack)
    local size = #pack
    local package = string.char(bit32.extract(size,8,8)) ..
        string.char(bit32.extract(size,0,8))..
        pack

    socket.write(client.fd, package)
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
    skynet.fork(function()
        while true do
            send_package(send_request "heartbeat")
            skynet.sleep(500)
        end
    end)

    client.fd = fd
    skynet.call(gate, "lua", "forward", fd)
end

function CMD.close( ... )
    skynet.exit()
end


function CMD.push(name, msg)
    send_package(send_request(name, msg))
end

function CMD.player(cmd, ...)
    local f = client.player[cmd]
    if f then
        return f(...)
    end
end

skynet.start(function()
    skynet.dispatch("lua", function(_,_, command, ...)
        local f = CMD[command]
        if command ~= "push" then
            skynet.ret(skynet.pack(f(...)))
        else 
            f(...)
        end
    end)
end)
