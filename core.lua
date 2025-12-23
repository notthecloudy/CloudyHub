-- Core Module for CloudyHub
-- Manages global state, feature registration, and update loops

local Core = {}

-- Global State
Core.State = {
    -- Combat
    AimbotEnabled = false,
    AimFOV = 90,
    AimSmoothing = 0.5,
    AimTeamCheck = true,
    AimPrediction = false,
    AimBone = "Head",
    SilentAimEnabled = false,

    -- Visuals
    ESPEnabled = false,
    ESPBoxes = true,
    ESPNames = true,
    ESPHealth = true,
    ESPTracers = false,
    ESPChams = false,
    ESPTeamCheck = true,
    ESPMaxDistance = 1000,
    ESPColor = Color3.new(1, 0, 0),
    ESPTeamColor = Color3.new(0, 1, 0),

    -- Movement
    WalkSpeedEnabled = false,
    WalkSpeedValue = 16,
    JumpPowerEnabled = false,
    JumpPowerValue = 50,
    FlyEnabled = false,
    FlySpeed = 50,

    -- Misc
    AutoRespawn = false,
    AntiAFK = false,
}

-- Feature Modules
Core.Features = {}

-- Update Loops
Core.Connections = {}

function Core:RegisterFeature(name, featureModule)
    self.Features[name] = featureModule
    if featureModule.Init then
        featureModule:Init(self.State)
    end
end

function Core:UnregisterFeature(name)
    if self.Features[name] and self.Features[name].Cleanup then
        self.Features[name]:Cleanup()
    end
    self.Features[name] = nil
end

function Core:Init()
    -- Set up update loops
    self.Connections.RenderStepped = game:GetService("RunService").RenderStepped:Connect(function(dt)
        for _, feature in pairs(self.Features) do
            if feature.UpdateRender then
                feature:UpdateRender(dt)
            end
        end
    end)

    self.Connections.Heartbeat = game:GetService("RunService").Heartbeat:Connect(function(dt)
        for _, feature in pairs(self.Features) do
            if feature.UpdateHeartbeat then
                feature:UpdateHeartbeat(dt)
            end
        end
    end)

    -- Load feature modules
    self:RegisterFeature("ESP", loadstring(game:HttpGet("https://raw.githubusercontent.com/notthecloudy/CloudyHub/refs/heads/main/features/esp.lua"))())
    self:RegisterFeature("Aimbot", loadstring(game:HttpGet("https://raw.githubusercontent.com/notthecloudy/CloudyHub/refs/heads/main/features/aimbot.lua"))())
    self:RegisterFeature("Movement", loadstring(game:HttpGet("https://raw.githubusercontent.com/notthecloudy/CloudyHub/refs/heads/main/features/movement.lua"))())
    self:RegisterFeature("Misc", loadstring(game:HttpGet("https://raw.githubusercontent.com/notthecloudy/CloudyHub/refs/heads/main/features/misc.lua"))())

    -- Load config
    self:LoadConfig()

    print("Core Initialized")
end

function Core:LoadConfig()
    local success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile("CloudyHubConfigs/config.json"))
    end)
    if success and data then
        for key, value in pairs(data) do
            if self.State[key] ~= nil then
                self.State[key] = value
            end
        end
        print("Config loaded successfully")
    else
        print("No config found, using defaults")
    end
end

function Core:SaveConfig()
    local configFolder = "CloudyHubConfigs"
    if not isfolder(configFolder) then
        makefolder(configFolder)
    end

    local success, err = pcall(function()
        writefile(configFolder .. "/config.json", game:GetService("HttpService"):JSONEncode(self.State))
    end)
    if success then
        print("Config saved successfully")
    else
        warn("Failed to save config: " .. err)
    end
end

-- SaveManager: Auto-save on changes
function Core:InitSaveManager()
    -- Hook into state changes (simple polling for now)
    self.LastState = table.clone(self.State)
    self.SaveConnection = game:GetService("RunService").Heartbeat:Connect(function()
        local changed = false
        for key, value in pairs(self.State) do
            if self.LastState[key] ~= value then
                changed = true
                break
            end
        end
        if changed then
            self:SaveConfig()
            self.LastState = table.clone(self.State)
        end
    end)
end

function Core:Cleanup()
    -- Disconnect loops
    for _, conn in pairs(self.Connections) do
        conn:Disconnect()
    end
    if self.SaveConnection then
        self.SaveConnection:Disconnect()
    end

    -- Cleanup features
    for name, feature in pairs(self.Features) do
        self:UnregisterFeature(name)
    end

    -- Reset state
    for key, _ in pairs(self.State) do
        if key:find("Enabled") then
            self.State[key] = false
        end
    end

    print("Core Cleaned Up")
end

return Core
