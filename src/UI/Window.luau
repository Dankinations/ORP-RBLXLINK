--!nolint LocalShadow
local window = {}
window.plugin = nil
window.__index = window

function window.init(plugin:Plugin)
    window.plugin = plugin
end

export type WindowType = {
    dock:DockWidgetPluginGui,
    holder:Frame,
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
    frame.BackgroundColor3 = Color3.fromRGB(25, 26, 31)
    self.holder = frame
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

function window:AddElement(element:GuiBase|any)
    local self:WindowType = self
    if typeof(element) == "Instance" then
        if not element:IsA("GuiBase") then return end
        element.Parent = self.holder
    elseif typeof(element) == "table" then
        assert(typeof(element)=="table")
        for _,v in element do
            if typeof(v) ~= "Instance" then continue end
            if not v:IsA("GuiBase") then continue end
            v.Parent = self.holder
        end
    end
    return element
end

return window