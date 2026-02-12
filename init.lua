local BASE_URL = "https://raw.githubusercontent.com/vex3441-a11y/Vexzinho-repositorio/main/"

local Theme = loadstring(game:HttpGet(BASE_URL .. "core/theme.lua"))()
local Config = loadstring(game:HttpGet(BASE_URL .. "core/config.lua"))()
local WindowClass = loadstring(game:HttpGet(BASE_URL .. "core/window.lua"))()
local TabClass = loadstring(game:HttpGet(BASE_URL .. "core/tab.lua"))()

local VexUI = {}
VexUI.__index = VexUI
VexUI.Windows = {}

function VexUI:CreateWindow(options)
    options = options or {}
    local window = WindowClass:Create(self, {
        Theme = Theme:Create(options.Theme),
        Config = Config:Merge(options)
    })

    function window:CreateTab(name)
        local tab = TabClass:Create(window, name)
        table.insert(window.Tabs, tab)
        if #window.Tabs == 1 then
            tab.Frame.Visible = true
        end
        return tab
    end

    table.insert(self.Windows, window)
    return window
end

return setmetatable({}, VexUI)