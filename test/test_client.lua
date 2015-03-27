local uid = ...
local socket = require "clientsocket"
local proto = require "proto"
local sproto = require "sproto"
local skynet = require "skynet"
local print_r = require "print_r"

local host = sproto.new(proto.s2c):host "package"
local request = host:attach(sproto.new(proto.c2s))

local client = {
    fd = nil,
    req = {},
    session = 0,
    last = ""
}

function client:create_connect(ip, port)
    self.fd = assert(socket.connect(ip, port))
end

function client:new( o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function client:close( )
    if self.fd then
        socket.close(self.fd)
        self.fd = nil
    end
end


function client:send_request(name, args, callback)
    self.session = self.session + 1
    local str = request(name, args, self.session)
    self:send_package(str)
    --print("Request:", self.session)
    if callback then
        self.req[self.session] = callback
    end
end

function  client:send_package(pack)
    local package = string.pack(">s2", pack)
    if self.fd then
        socket.send(self.fd, package)
    end
end

local function unpack_package(text)
    local size = #text
    if size < 2 then
        return nil, text
    end
    local s = text:byte(1) * 256 + text:byte(2)
    if size < s+2 then
        return nil, text
    end
    return text:sub(3,2+s), text:sub(3+s)
end



function client:request(name, args)
    --print("REQUEST", name)
    if args then
        --for k,v in pairs(args) do
            --print(k,v)
        --end
        return
    end
end

function client:response(session, args)
    --print("RESPONSE", session)
    local callback = self.req[session]
    if callback then
        self.req[session] = nil
        callback(args)
        return
    end
    if args then
        for k,v in pairs(args) do
            --print(k,v)
            return
        end
    end
end

function client:process(type, ...)
    if type == "REQUEST" then
        self:request(...)
    else
        assert(type == "RESPONSE")
        self:response(...)
    end
end


function client:recv_package()
    local result
    result, self.last = unpack_package(self.last)
    if result then
        return result
    end
    if not self.fd then
        return nil
    end
    local r = socket.recv(self.fd)
    skynet.sleep(200)
    if not r then
        return nil
    end
    if r == "" then
        error "Server closed"
        return
    end
    result, self.last = unpack_package(self.last .. r)
    return result
end


function client:dispatch()
    while true do
        if not self.fd then
            return
        end
        local v
        v = self:recv_package()
        if v then
            self:process(host:dispatch(v))
        end
    end
end

function dispatch_package(conn)
    conn:dispatch()
end

local player = nil
function test_server( uid)
    local conn = client:new() 
    conn:create_connect("127.0.0.1", 10086)
    conn:send_request("user_handshake")
--        conn:send_request("user_register", {uuid = "device is iPhone 6 plus", channel = "1018"}, function (msg)
--                print("register callback msg : ")
--               print_r(msg)
--        end)
    skynet.fork(dispatch_package, conn)
    skynet.fork(function (conn)
        conn:send_request("user_login", { uid = uid, passwd = "like you"}, function ( msg)
                if msg and msg.code == 400then
                    print("can not pass auth")
                end
            conn:send_request("seat_enter", {uid = uid}, function ( ... )
                    skynet.sleep(100)
                    conn:send_request("seat_leave", {uid = uid})
                    conn:close()
                    print("close")
                    skynet.fork(test_server, uid)
            end)
        end)
    end, conn)
end


function register( )
    local conn = client:new()
    conn:create_connect("127.0.0.1", 10086)
    skynet.fork(dispatch_package, conn)
    for i = 1, 1000 do
        conn:send_request("user_handshake")
        conn:send_request("user_register", {uuid = "device is iPhone 6 plus", channel = 1018}, function (msg)
                print("register callback msg : ")
                if msg and msg.code == 400 then
                    print("register fail")
                    return
                end
                print_r(msg)
        end)
        skynet.sleep(20)
    end
end


skynet.start(function ()
        --skynet.fork(test_server, uid)
        skynet.fork(register)
end)
