local ui = {}
ui.plugin = nil

local Window = require(script.Window)

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

return ui