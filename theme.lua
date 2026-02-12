local Colors = require("utils/colors")

local Theme = {}

Theme.Default = {
    Accent = "Blue",
    Background = Color3.fromRGB(20, 20, 20),
    Transparency = 0.25,
    Text = Color3.fromRGB(235, 235, 235)
}

function Theme:Create(custom)
    custom = custom or {}
    local t = {}

    t.Accent = Colors:Get(custom.Accent or self.Default.Accent)
    t.Background = custom.Background or self.Default.Background
    t.Transparency = custom.Transparency or self.Default.Transparency
    t.Text = custom.Text or self.Default.Text

    return t
end

return Theme