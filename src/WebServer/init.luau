--[[
- WEBSERVER - ORP - WEBSERVER - ORP - WEBSERVER - ORP - WEBSERVER - ORP - WEBSERVER - ORP -

- How does it work?
    Let's say it receives a signal saying "sync|{JSONDATA}".
    It will remove "sync|" from the string and send the rest to sync.luau
        (Inside of requestHandlers).

- WEBSERVER - ORP - WEBSERVER - ORP - WEBSERVER - ORP - WEBSERVER - ORP - WEBSERVER - ORP -
]]


export type WebserverType = {
    Start:()->(boolean),
    Stop:()->(),
    Send:(msg:string)->()
}

local HttpService = game:GetService("HttpService")

local ws = {} :: WebserverType
local connections:{RBXScriptConnection} = {}

ws.Port = 2763
ws.Client = nil

function ws.Start()
    if ws.Client ~= nil then error("ORP-RBLXLINK: Client already started!") end
    
    for _,v:RBXScriptConnection in connections do
        v:Disconnect()
    end
    table.clear(connections)

    local client:WebStreamClient = HttpService:CreateWebStreamClient(
        Enum.WebStreamClientType.WebSocket, {
        ["Url"] = `ws://127.0.0.1:{ws.Port}`
    })
    ws.Client = client

    table.insert(connections,client.MessageReceived:Connect(function(msg: string)
        print(`ORP-RBLXLINK: Received message: "{msg}"`)
        local split = msg:split("|")
        if #split <= 1 then error(`ORP-RBLXLINK: Invalid request ({msg})`) end
        local find = script:FindFirstChild(split[1]:lower())
        if not find then error(`ORP-RBLXLINK: Invalid request type! ({split[1]})`) end
        table.remove(split,1)
        require(find)(table.unpack(split))
    end))

    print("ORP-RBLXLINK: Started listening to port "..ws.Port)
    return true
end

function ws.Stop()
    if ws.Client == nil then error("ORP-RBLXLINK: Can't stop client if it's not turned on!") end
    local client:WebSocketClient = ws.Client
    client:Close()
    ws.Client = nil
end

function ws.Send(msg:string)
    if ws.Client == nil then error("ORP-RBLXLINK: Can't send webserver message if it's not turned on!") end
    local client:WebSocketClient = ws.Client
    client:Send(msg)
end

return ws :: WebserverType