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
local REQUEST = { PLAYER = pp_player, SEAT = pp_seat} -- process proto array

local client = {
    fd = nil,
    player = nil,
    auth = false,
    seat = nil
}

-- first auth
-- game process

local function request(name, args, response)
    local f = REQUEST.PLAYER[name]
    if not f then
        if client.auth then
            f = assert(REQUEST.SEAT[name]) -- seat proto
            if f then
                local r = f(client, args)
                if response then
                    return response(r)
                end
            end                
        else
            socket.close(client.fd)
            skynet.send(".watchdog", "lua", "close", client.fd)
            skynet.exit()
        end
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
            print ("heartbeat")
            skynet.sleep(500)
        end
    end)

    client.fd = fd
    skynet.call(gate, "lua", "forward", fd)
end

function CMD.close( ... )
    -- client close socket event
    skynet.exit()
end


function CMD.push(name, msg)
    send_package(send_request(name, msg))
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
