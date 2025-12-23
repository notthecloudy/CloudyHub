-- CloudyHub Main Script
-- Roblox Exploit Hub with ESP, Aimbot, Movement, and Misc features

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CloudyHub",
   LoadingTitle = "CloudyHub",
   LoadingSubtitle = "by Cloudy",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Core Module
local Core = loadstring(game:HttpGet("https://raw.githubusercontent.com/CloudyHub/CloudyHub/main/core.lua"))()

-- Combat Tab
CombatTab:CreateSection("Aimbot")
CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(val)
        Core.State.AimbotEnabled = val
    end
})
CombatTab:CreateSlider({
    Name = "FOV",
    Range = {10, 180},
    Increment = 5,
    CurrentValue = 90,
    Flag = "AimbotFOV",
    Callback = function(val)
        Core.State.AimFOV = val
    end
})
CombatTab:CreateSlider({
    Name = "Smoothing",
    Range = {0.1, 1},
    Increment = 0.1,
    CurrentValue = 0.5,
    Flag = "AimbotSmoothing",
    Callback = function(val)
        Core.State.AimSmoothing = val
    end
})
CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "AimbotTeamCheck",
    Callback = function(val)
        Core.State.AimTeamCheck = val
    end
})
CombatTab:CreateToggle({
    Name = "Prediction",
    CurrentValue = false,
    Flag = "AimbotPrediction",
    Callback = function(val)
        Core.State.AimPrediction = val
    end
})

-- Visuals Tab
VisualsTab:CreateSection("ESP")
VisualsTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(val)
        Core.State.ESPEnabled = val
    end
})
VisualsTab:CreateToggle({
    Name = "Boxes",
    CurrentValue = true,
    Flag = "ESPBoxes",
    Callback = function(val)
        Core.State.ESPBoxes = val
    end
})
VisualsTab:CreateToggle({
    Name = "Names",
    CurrentValue = true,
    Flag = "ESPNames",
    Callback = function(val)
        Core.State.ESPNames = val
    end
})
VisualsTab:CreateToggle({
    Name = "Health",
    CurrentValue = true,
    Flag = "ESPHealth",
    Callback = function(val)
        Core.State.ESPHealth = val
    end
})
VisualsTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = false,
    Flag = "ESPTracers",
    Callback = function(val)
        Core.State.ESPTracers = val
    end
})
VisualsTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "ESPTeamCheck",
    Callback = function(val)
        Core.State.ESPTeamCheck = val
    end
})
VisualsTab:CreateSlider({
    Name = "Max Distance",
    Range = {100, 2000},
    Increment = 50,
    CurrentValue = 1000,
    Flag = "ESPMaxDistance",
    Callback = function(val)
        Core.State.ESPMaxDistance = val
    end
})

-- Movement Tab
MovementTab:CreateSection("Speed")
MovementTab:CreateToggle({
    Name = "WalkSpeed",
    CurrentValue = false,
    Flag = "WalkSpeedToggle",
    Callback = function(val)
        Core.State.WalkSpeedEnabled = val
    end
})
MovementTab:CreateSlider({
    Name = "WalkSpeed Value",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeedValue",
    Callback = function(val)
        Core.State.WalkSpeedValue = val
    end
})

MovementTab:CreateSection("Jump")
MovementTab:CreateToggle({
    Name = "JumpPower",
    CurrentValue = false,
    Flag = "JumpPowerToggle",
    Callback = function(val)
        Core.State.JumpPowerEnabled = val
    end
})
MovementTab:CreateSlider({
    Name = "JumpPower Value",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 50,
    Flag = "JumpPowerValue",
    Callback = function(val)
        Core.State.JumpPowerValue = val
    end
})

MovementTab:CreateSection("Fly")
MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(val)
        Core.State.FlyEnabled = val
    end
})
MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(val)
        Core.State.FlySpeed = val
    end
})

-- Misc Tab
MiscTab:CreateSection("Utilities")
MiscTab:CreateToggle({
    Name = "Auto Respawn",
    CurrentValue = false,
    Flag = "AutoRespawn",
    Callback = function(val)
        Core.State.AutoRespawn = val
    end
})
MiscTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(val)
        Core.State.AntiAFK = val
    end
})

-- Error handling and initialization
local success, err = pcall(function()
    Core:Init()
    Core:InitSaveManager()
end)
if not success then
    warn("Failed to initialize CloudyHub: " .. err)
    -- Fallback or cleanup
end
