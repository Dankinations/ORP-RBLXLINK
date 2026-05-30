--[[
- WEBSERVER - ORP - WEBSERVER - ORP - WEBSERVER - ORP - WEBSERVER - ORP - WEBSERVER - ORP -

- How does it work?
    Let's say it receives a signal saying "sync|{JSONDATA}".
    It will remove "sync|" from the string and send the rest to sync.luau
        (Inside of requestHandlers).

- WEBSERVER - ORP - WEBSERVER - ORP - WEBSERVER - ORP - WEBSERVER - ORP - WEBSERVER - ORP -
]]


export type WebserverType = {
    Start:()->(),
    Port:number,
    Client:WebStreamClient
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

    local client:WebStreamClient = HttpService:CreateWebStreamClient(
        Enum.WebStreamClientType.WebSocket, {
        `localhost:{ws.Port}`
    })
    ws.Client = client

    table.insert(connections,client.MessageReceived:Connect(function(msg: string)
        local split = msg:split("|")
        if #split <= 1 then error(`ORP-RBLXLINK: Invalid request ({msg})`) end
        local find = script:FindFirstChild(split[1]:lower())
        if not find then error(`ORP-RBLXLINK: Invalid request type! ({split[1]})`) end
        table.remove(split,1)
        require(find)(table.unpack(split))
    end))
end

return ws :: WebserverType