local btn = {}
btn.plugin = nil
btn.__index = btn

function btn.init(plugin:Plugin)
    btn.plugin = plugin
end

