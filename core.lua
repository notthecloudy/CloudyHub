-- Core Module for MyHub
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
            if feature.UpdateRender and feature.Enabled then
                feature:UpdateRender(dt)
            end
        end
    end)

    self.Connections.Heartbeat = game:GetService("RunService").Heartbeat:Connect(function(dt)
        for _, feature in pairs(self.Features) do
            if feature.UpdateHeartbeat and feature.Enabled then
                feature:UpdateHeartbeat(dt)
            end
        end
    end)

    -- Load feature modules
    self:RegisterFeature("ESP", require(game:GetService("ReplicatedStorage"):WaitForChild("MyHub").Features.ESP))
    self:RegisterFeature("Aimbot", require(game:GetService("ReplicatedStorage"):WaitForChild("MyHub").Features.Aimbot))
    self:RegisterFeature("Movement", require(game:GetService("ReplicatedStorage"):WaitForChild("MyHub").Features.Movement))
    self:RegisterFeature("Misc", require(game:GetService("ReplicatedStorage"):WaitForChild("MyHub").Features.Misc))

    print("Core Initialized")
end

function Core:Cleanup()
    -- Disconnect loops
    for _, conn in pairs(self.Connections) do
        conn:Disconnect()
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
