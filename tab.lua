local Tab = {}
Tab.__index = Tab

function Tab:Create(window, name)
    local self = setmetatable({}, Tab)
    self.Window = window
    self.Name = name

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = window.Main

    self.Frame = frame
    return self
end

function Tab:AddLink(data)
    local Link = require("elements/link")
    return Link:Create(self.Frame, self.Window.Theme, data)
end

return Tab