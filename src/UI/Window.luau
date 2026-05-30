--!nolint LocalShadow
local window = {}
window.plugin = nil
window.__index = window

function window.init(plugin:Plugin)
    window.plugin = plugin
end

export type WindowType = {
    dock:DockWidgetPluginGui,
    plugin:Plugin,
    SetVisible:(WindowType,boolean)->(),
    IsVisible:(WindowType)->(boolean),
    AddElement:(WindowType,GuiBase)->(GuiBase)
}

local dockInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false,600,400,300,200)

-- Creates the window Instance!
function window.new() : WindowType
    local self = setmetatable({}, window)
    
    self.plugin = window.plugin :: Plugin
    self.dock = self.plugin:CreateDockWidgetPluginGuiAsync(`ORP_RBLXLINK_WINDOW_{tick()}`, dockInfo)
    self.dock.Title = "Test"
    local frame = Instance.new("Frame",self.dock)
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundColor3 = Color3.new(0.152941, 0.160784, 0.239216)

    return self
end

function window:SetVisible(new:boolean)
    local self:WindowType = self
    self.dock.Enabled = new
end

function window:IsVisible()
    local self:WindowType = self
    return self.dock.Enabled
end

function window:AddElement(element:GuiBase)
    local self:WindowType = self
    element.Parent = self.dock:FindFirstAncestorOfClass("Frame")
    return element
end

return window