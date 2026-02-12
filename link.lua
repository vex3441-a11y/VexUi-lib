local Link = {}
Link.__index = Link

local Colors = require("utils/colors")

function Link:Create(parent, theme, data)
    data = data or {}
    local accent = Colors:Get(data.Color) or theme.Accent

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -20, 0, 80)
    card.Position = UDim2.fromOffset(10, 10)
    card.BackgroundColor3 = theme.Background
    card.BackgroundTransparency = theme.Transparency
    card.Parent = parent

    local stroke = Instance.new("UIStroke")
    stroke.Color = accent
    stroke.Thickness = 2
    stroke.Parent = card

    local title = Instance.new("TextLabel")
    title.Text = data.Title or "Link"
    title.TextColor3 = theme.Text
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(10, 8)
    title.Size = UDim2.new(1, -20, 0, 20)
    title.TextXAlignment = Left
    title.Parent = card

    local desc = Instance.new("TextLabel")
    desc.Text = data.Description or ""
    desc.TextColor3 = theme.Text
    desc.TextTransparency = 0.2
    desc.TextSize = 13
    desc.Font = Enum.Font.Gotham
    desc.BackgroundTransparency = 1
    desc.Position = UDim2.fromOffset(10, 30)
    desc.Size = UDim2.new(1, -20, 0, 20)
    desc.TextXAlignment = Left
    desc.Parent = card

    local button = Instance.new("TextButton")
    button.Text = "Copiar Link"
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.BackgroundColor3 = accent
    button.TextColor3 = Color3.new(1,1,1)
    button.Size = UDim2.fromOffset(110, 28)
    button.Position = UDim2.fromScale(1,1) - UDim2.fromOffset(120, 38)
    button.Parent = card

    button.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(data.Url or "")
        end
    end)

    return card
end

return Link