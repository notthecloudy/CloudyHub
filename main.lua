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
=======
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
