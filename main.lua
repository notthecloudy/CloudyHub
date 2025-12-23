-- MyHub Main Loader
-- Loads Rayfield, initializes UI, and sets up core modules

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
    Name = "DMon Test Hub",
    LoadingTitle = "Loading Hub...",
    LoadingSubtitle = "Please wait",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MyHubConfigs",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },
    KeySystem = false,
    KeySettings = {
        Title = "Key System",
        Subtitle = "Enter Key",
        Note = "No key required",
        FileName = "Key",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = ""
    }
})

-- Tabs
local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
local MovementTab = Window:CreateTab("Movement")
local MiscTab = Window:CreateTab("Misc")
local SettingsTab = Window:CreateTab("Settings")

-- Combat Tab Elements
CombatTab:CreateSection("Aimbot")
CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(val)
        -- Placeholder: Implement in aimbot.lua
    end
})
CombatTab:CreateSlider({
    Name = "Aim FOV",
    Range = {10, 360},
    Increment = 1,
    CurrentValue = 90,
    Flag = "AimFOV",
    Callback = function(val)
        -- Placeholder: Implement in aimbot.lua
    end
})
CombatTab:CreateSlider({
    Name = "Smoothing",
    Range = {0.1, 1},
    Increment = 0.1,
    CurrentValue = 0.5,
    Flag = "AimSmoothing",
    Callback = function(val)
        -- Placeholder: Implement in aimbot.lua
    end
})
CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "AimTeamCheck",
    Callback = function(val)
        -- Placeholder: Implement in aimbot.lua
    end
})
CombatTab:CreateToggle({
    Name = "Prediction",
    CurrentValue = false,
    Flag = "AimPrediction",
    Callback = function(val)
        -- Placeholder: Implement in aimbot.lua
    end
})
CombatTab:CreateDropdown({
    Name = "Target Bone",
    Options = {"Head", "UpperTorso", "HumanoidRootPart"},
    CurrentOption = "Head",
    Flag = "AimBone",
    Callback = function(option)
        -- Placeholder: Implement in aimbot.lua
    end
})
CombatTab:CreateKeybind({
    Name = "Aim Key",
    CurrentKeybind = "MouseButton2",
    HoldToInteract = true,
    Flag = "AimKey",
    Callback = function(key)
        -- Placeholder: Implement in aimbot.lua
    end
})

CombatTab:CreateSection("Silent Aim")
CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(val)
        -- Placeholder: Implement in aimbot.lua
    end
})

-- Visuals Tab Elements
VisualsTab:CreateSection("ESP")
VisualsTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESPEnable",
    Callback = function(val)
        -- Placeholder: Implement in esp.lua
    end
})
VisualsTab:CreateToggle({
    Name = "Boxes",
    CurrentValue = true,
    Flag = "ESPBoxes",
    Callback = function(val)
        -- Placeholder: Implement in esp.lua
    end
})
VisualsTab:CreateToggle({
    Name = "Names",
    CurrentValue = true,
    Flag = "ESPNames",
    Callback = function(val)
        -- Placeholder: Implement in esp.lua
    end
})
VisualsTab:CreateToggle({
    Name = "Health Bars",
    CurrentValue = true,
    Flag = "ESPHealth",
    Callback = function(val)
        -- Placeholder: Implement in esp.lua
    end
})
VisualsTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = false,
    Flag = "ESPTracers",
    Callback = function(val)
        -- Placeholder: Implement in esp.lua
    end
})
VisualsTab:CreateToggle({
    Name = "Chams",
    CurrentValue = false,
    Flag = "ESPChams",
    Callback = function(val)
        -- Placeholder: Implement in esp.lua
    end
})
VisualsTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "ESPTeamCheck",
    Callback = function(val)
        -- Placeholder: Implement in esp.lua
    end
})
VisualsTab:CreateSlider({
    Name = "Max Distance",
    Range = {100, 10000},
    Increment = 50,
    CurrentValue = 1000,
    Flag = "ESPMaxDistance",
    Callback = function(val)
        -- Placeholder: Implement in esp.lua
    end
})
VisualsTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.new(1, 0, 0),
    Flag = "ESPColor",
    Callback = function(c)
        -- Placeholder: Implement in esp.lua
    end
})
VisualsTab:CreateColorPicker({
    Name = "Team Color",
    Color = Color3.new(0, 1, 0),
    Flag = "ESPTeamColor",
    Callback = function(c)
        -- Placeholder: Implement in esp.lua
    end
})

-- Movement Tab Elements
MovementTab:CreateSection("Speed")
MovementTab:CreateToggle({
    Name = "WalkSpeed",
    CurrentValue = false,
    Flag = "WalkSpeedToggle",
    Callback = function(val)
        -- Placeholder: Implement in movement.lua
    end
})
MovementTab:CreateSlider({
    Name = "WalkSpeed Value",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeedValue",
    Callback = function(val)
        -- Placeholder: Implement in movement.lua
    end
})

MovementTab:CreateSection("Jump")
MovementTab:CreateToggle({
    Name = "JumpPower",
    CurrentValue = false,
    Flag = "JumpPowerToggle",
    Callback = function(val)
        -- Placeholder: Implement in movement.lua
    end
})
MovementTab:CreateSlider({
    Name = "JumpPower Value",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 50,
    Flag = "JumpPowerValue",
    Callback = function(val)
        -- Placeholder: Implement in movement.lua
    end
})

MovementTab:CreateSection("Fly")
MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(val)
        -- Placeholder: Implement in movement.lua
    end
})
MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(val)
        -- Placeholder: Implement in movement.lua
    end
})

-- Misc Tab Elements
MiscTab:CreateSection("Utilities")
MiscTab:CreateButton({
    Name = "Teleport to Random Player",
    Callback = function()
        -- Placeholder: Implement in misc.lua
    end
})
MiscTab:CreateToggle({
    Name = "Auto Respawn",
    CurrentValue = false,
    Flag = "AutoRespawn",
    Callback = function(val)
        -- Placeholder: Implement in misc.lua
    end
})
MiscTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(val)
        -- Placeholder: Implement in misc.lua
    end
})

-- Settings Tab Elements
SettingsTab:CreateSection("UI")
SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        Rayfield:SaveConfiguration()
    end
})
SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        Rayfield:LoadConfiguration()
    end
})
SettingsTab:CreateButton({
    Name = "Unload Hub",
    Callback = function()
        Rayfield:Destroy()
        -- Placeholder: Cleanup code
    end
})
SettingsTab:CreateToggle({
    Name = "Panic Key (Disable All)",
    CurrentValue = false,
    Flag = "PanicKey",
    Callback = function(val)
        -- Placeholder: Implement panic disable
    end
})
SettingsTab:CreateKeybind({
    Name = "Panic Keybind",
    CurrentKeybind = "F1",
    HoldToInteract = false,
    Flag = "PanicKeybind",
    Callback = function(key)
        -- Placeholder: Implement panic disable
    end
})

-- Safety checks
if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not workspace.CurrentCamera then
    warn("Camera not found, waiting...")
    workspace:GetPropertyChangedSignal("CurrentCamera"):Wait()
end

-- Load Core Module (assuming MyHub is placed in a location accessible via require)
-- For local testing, you may need to adjust this path
local Core
local success, err = pcall(function()
    Core = require(script.Parent.Core)
end)

if not success then
    warn("Failed to load Core module: " .. err)
    return
end

-- Initialize Core
Core:Init()

print("MyHub Loaded Successfully")
