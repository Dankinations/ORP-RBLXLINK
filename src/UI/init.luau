local ui = {}
ui.plugin = nil

local Button = require(script.Button)
local Window = require(script.Window)

export type ButtonType = Button.ButtonType
export type WindowType = Window.WindowType

function ui.init(plugin:Plugin) : typeof(ui)
    ui.plugin = plugin
    for _,v in script:GetChildren() do
        require(v).init(plugin)
    end
    return ui
end

function ui.CreateWindow() : Window.WindowType
    return Window.new()
end

function ui.CreateButton() : Button.ButtonType
    return Button.new()
end

return ui