local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local lib_client = require "lib_client"
local lib_logger = require "lib_logger"
local lib_utils = require "lib_utils"
-- request process
local pp_player = require "pp_player"
local pp_seat = require "pp_seat"

local CMD = {}
local REQUEST = { user = pp_player, seat = pp_seat} -- process proto array

local client
local logger

local function router(name)
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


local function request(name, args, response)
    logger:debug("request", name, lib_utils.format_dict(args))
    local f = router(name)
    if not f then
        logger:warn("server no support this request", name, lib_utils.format_dict(args))
        client:close()
        skynet.exit()
    end
    local r = f(client, args) 
    if response then
        return response(r)
    end
end

skynet.register_protocol {
    name = "client",
    id = skynet.PTYPE_CLIENT,
    unpack = function (msg, sz)
        return client.host:dispatch(msg, sz)
    end,
    dispatch = function (_, _, type, ...)
        if type == "REQUEST" then
            local ok, result  = pcall(request, ...)
            if ok then
                if result then
                    client:send_package(result)
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
    client = lib_client:new()
    client:start(fd, proto)
    skynet.fork(function()
        while true do
            client:send_request("heartbeat")
            skynet.sleep(500)
        end
    end)
    skynet.call(gate, "lua", "forward", fd) 
end

function CMD.close( ... )
    client:close()
    skynet.exit()
end

function CMD.push(name, msg)
    client:send_request(name, msg)
end

function CMD.player(cmd, ...)
    local f = client.player[cmd]
    if f then
        return f(...)
    end
end

skynet.start(function()
    logger = lib_logger:new("./mahjong/logs/agent")
    skynet.dispatch("lua", function(_,_, command, ...)
        local f = CMD[command]
        if command ~= "push" then
            skynet.ret(skynet.pack(f(...)))
        else
            f(...)
        end
    end)
end)
