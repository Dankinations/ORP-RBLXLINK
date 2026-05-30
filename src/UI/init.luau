local ui = {}
ui.plugin = nil

local Window = require(script.Window)

function ui.init(plugin:Plugin) : typeof(ui)
    ui.plugin = plugin
    Window.init(plugin)
    return ui
end

function ui.CreateWindow() : Window.WindowType
    return Window.new()
end

return ui