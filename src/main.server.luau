local ServerStorage = game:GetService("ServerStorage")

local Promise = require(ServerStorage["ORP-RBLXLINK"].Libraries.Promise)
local UI = require(script.Parent.UI)
local WebServer = require(script.Parent.WebServer)
UI.init(plugin)

local toolbar = plugin:CreateToolbar("ORP-RBLXLINK")
local toggleBtn = toolbar:CreateButton(`ORP_TOGGLE_{tick()}`, `Toggles the main window of RBLXLINK`, "", "ORP RBLXLINK")

local window = UI.CreateWindow()

toggleBtn.Click:Connect(function()
	window:SetVisible(true)
end)

local icon: ImageLabel = Instance.new("ImageLabel")
icon.AnchorPoint = Vector2.one * 0.5
icon.Position = UDim2.fromScale(0.5, 0.25)
icon.Size = UDim2.fromScale(0.35, 0.35)
icon.Image = "rbxassetid://91660423153728"
icon.BackgroundTransparency = 1
Instance.new("UIAspectRatioConstraint").Parent = icon
window:AddElement(icon)

local btn: UI.ButtonType = UI.CreateButton()
btn:SetLabel("Webserver OFF")
btn.toggle = true
btn:SetPosition(UDim2.fromScale(0.5, 0.5))
btn.main.TextSize = 20
btn = window:AddElement(btn)

btn.StateChanged:Connect(function(state:boolean)
	if state == true then
		local ws_promise = Promise.new(function(resolve: (any) -> (), fail: (any) -> (), cancelled)
			local result = WebServer.Start()
			if result then
				resolve("Sucessfully turned on webserver!")
			end
		end)
		
		ws_promise:AndThen(function()
			btn:SetLabel("Webserver ON")
		end):Catch(function(reason)
			btn:SetLabel("FAILED! Check output!")
			btn:SetState(false)
		end)
	else
		btn:SetLabel("Webserver OFF")
		WebServer.Stop()
	end
end)