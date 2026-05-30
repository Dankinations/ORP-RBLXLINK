local _Webserver = require(script.Parent.WebServer)
local UI = require(script.Parent.UI)
UI.init(plugin)


local toolbar = plugin:CreateToolbar("ORP-RBLXLINK")
local toggleBtn = toolbar:CreateButton(`ORP_TOGGLE_{tick()}`, `Toggles the main window of RBLXLINK`,"","ORP RBLXLINK")

local window = UI.CreateWindow()

toggleBtn.Click:Connect(function()
    window:SetVisible(true)
end)

local icon:ImageLabel = Instance.new("ImageLabel")
icon.AnchorPoint = Vector2.one*.5
icon.Position = UDim2.fromScale(.5, .25)
icon.Size = UDim2.fromScale(.35,.35)
icon.Image = "rbxassetid://91660423153728"
icon.BackgroundTransparency = 1
Instance.new("UIAspectRatioConstraint",icon)
window:AddElement(icon)

local btn:UI.ButtonType = UI.CreateButton()
btn:SetLabel("Start webserver")
btn:SetPosition(UDim2.fromScale(.5, .5))
btn.main.TextSize = 20
btn = window:AddElement(btn)