local Colors = {}

Colors.Presets = {
    Red     = Color3.fromRGB(255, 80, 80),
    Blue    = Color3.fromRGB(80, 140, 255),
    Green   = Color3.fromRGB(80, 255, 160),
    Purple  = Color3.fromRGB(170, 90, 255),
    Orange  = Color3.fromRGB(255, 160, 80),
    Pink    = Color3.fromRGB(255, 100, 180),
    White   = Color3.fromRGB(240, 240, 240)
}

function Colors:Get(value)
    if typeof(value) == "Color3" then
        return value
    end

    if typeof(value) == "string" then
        return self.Presets[value] or self.Presets.Blue
    end

    return self.Presets.Blue
end

return Colors