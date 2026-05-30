local UI = require(script.Parent.UI)
UI.init(plugin)
local Webserver = require(script.Parent.WebServer) 

local toolbar = plugin:CreateToolbar("ORP-RBLXLINK")
local toggleBtn = toolbar:CreateButton(`ORP_TOGGLE_{tick()}`, `Toggles the main window of RBLXLINK`,"","ORP RBLXLINK")

local window = UI.CreateWindow()
local active = false

toggleBtn.Click:Connect(function()
    active = not active
    toggleBtn:SetActive(active)
    window:SetVisible(toggleBtn.Enabled)
end)

local icon:ImageLabel = window:AddElement(Instance.new("ImageLabel"))
icon.AnchorPoint = Vector2.one*.5
icon.Position = UDim2.fromScale(.5, .125)
icon.Size = UDim2.fromScale(.125,.125)
Instance.new("UIAspectRatioConstraint",icon)