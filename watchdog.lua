local skynet = require "skynet"
local netpack = require "netpack"
local proto = require "proto"

local CMD = {}
local SOCKET = {}
local gate
local agent = {}

function SOCKET.open(fd, addr)
    skynet.error("New client from : " .. addr)
    agent[fd] = skynet.newservice("mod_agent")
    skynet.call(agent[fd], "lua", "start", gate, fd, proto)
end

local function close_agent(fd)
    local a = agent[fd]
    if a then
        agent[fd] = nil
    end
end

function SOCKET.close(fd)
    print("socket close",fd)
    if agent[fd] then
        skynet.send(agent[fd], "lua", "close")
        close_agent(fd)
    end
end

function SOCKET.error(fd, msg)
    print("socket error",fd, msg)
    if agent[fd] then
        skynet.send(agent[fd], "lua", "close")
        close_agent(fd)
    end
end

function SOCKET.data(fd, msg)
end

function CMD.start(conf)
    skynet.call(gate, "lua", "open" , conf)
end

function CMD.close(fd)
    close_agent(fd)
end


skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
        if cmd == "socket" then
            local f = SOCKET[subcmd]
            f(...)
            -- socket api don't need return
        else
            local f = assert(CMD[cmd])
            skynet.ret(skynet.pack(f(subcmd, ...)))
        end
    end)
    skynet.register(".watchdog")
    gate = skynet.newservice("gate")
end)
