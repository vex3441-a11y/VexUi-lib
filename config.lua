local Config = {}

Config.Default = {
    Size = UDim2.fromOffset(540, 420),
    MobileSupport = true,
    PlayerProfile = {
        Enabled = true,
        Position = "Right"
    }
}

function Config:Merge(user)
    user = user or {}
    local final = {}

    for k, v in pairs(self.Default) do
        final[k] = user[k] ~= nil and user[k] or v
    end

    return final
end

return Config