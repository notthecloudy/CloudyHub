-- Movement Module
-- Handles speed modifications, jump power, and fly

local Movement = {}

function Movement:Init(state)
    self.State = state
    self.LocalPlayer = game.Players.LocalPlayer
    self.Character = nil
    self.Humanoid = nil
    self.RootPart = nil
    self.FlyConnection = nil
    self.FlyVelocity = nil
    self.FlyGyro = nil

    -- Connect to character events
    self.LocalPlayer.CharacterAdded:Connect(function(character)
        self:OnCharacterAdded(character)
    end)

    self.LocalPlayer.CharacterRemoving:Connect(function()
        self:OnCharacterRemoved()
    end)

    -- Add existing character
    if self.LocalPlayer.Character then
        self:OnCharacterAdded(self.LocalPlayer.Character)
    end
end

function Movement:OnCharacterAdded(character)
    self.Character = character
    self.Humanoid = character:FindFirstChild("Humanoid")
    self.RootPart = character:FindFirstChild("HumanoidRootPart")

    if self.Humanoid then
        -- Store original values
        self.OriginalWalkSpeed = self.Humanoid.WalkSpeed
        self.OriginalJumpPower = self.Humanoid.JumpPower
    end
end

function Movement:OnCharacterRemoved()
    self.Character = nil
    self.Humanoid = nil
    self.RootPart = nil
    self:StopFly()
end

function Movement:UpdateHeartbeat(dt)
    if not self.Humanoid or not self.RootPart then return end

    -- WalkSpeed
    if self.State.WalkSpeedEnabled then
        self.Humanoid.WalkSpeed = self.State.WalkSpeedValue
    else
        self.Humanoid.WalkSpeed = self.OriginalWalkSpeed or 16
    end

    -- JumpPower
    if self.State.JumpPowerEnabled then
        self.Humanoid.JumpPower = self.State.JumpPowerValue
    else
        self.Humanoid.JumpPower = self.OriginalJumpPower or 50
    end

    -- Fly
    if self.State.FlyEnabled then
        self:StartFly()
    else
        self:StopFly()
    end
end

function Movement:StartFly()
    if not self.RootPart or self.FlyVelocity then return end

    -- Create BodyVelocity and BodyGyro for flying
    self.FlyVelocity = Instance.new("BodyVelocity")
    self.FlyVelocity.Velocity = Vector3.new(0, 0, 0)
    self.FlyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    self.FlyVelocity.Parent = self.RootPart

    self.FlyGyro = Instance.new("BodyGyro")
    self.FlyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    self.FlyGyro.D = 100
    self.FlyGyro.Parent = self.RootPart

    -- Connect to input for flying
    self.FlyConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
        self:UpdateFly(dt)
    end)
end

function Movement:StopFly()
    if self.FlyVelocity then
        self.FlyVelocity:Destroy()
        self.FlyVelocity = nil
    end
    if self.FlyGyro then
        self.FlyGyro:Destroy()
        self.FlyGyro = nil
    end
    if self.FlyConnection then
        self.FlyConnection:Disconnect()
        self.FlyConnection = nil
    end
end

function Movement:UpdateFly(dt)
    if not self.FlyVelocity or not self.FlyGyro or not self.RootPart then return end

    local camera = workspace.CurrentCamera
    local moveDirection = Vector3.new(0, 0, 0)

    -- Get input
    local userInput = game:GetService("UserInputService")
    if userInput:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + camera.CFrame.LookVector
    end
    if userInput:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - camera.CFrame.LookVector
    end
    if userInput:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - camera.CFrame.RightVector
    end
    if userInput:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + camera.CFrame.RightVector
    end
    if userInput:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveDirection = moveDirection - Vector3.new(0, 1, 0)
    end

    -- Normalize and apply speed
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * self.State.FlySpeed
    end

    self.FlyVelocity.Velocity = moveDirection
    self.FlyGyro.CFrame = camera.CFrame
end

function Movement:Cleanup()
    self:StopFly()
    -- Reset to original values
    if self.Humanoid then
        self.Humanoid.WalkSpeed = self.OriginalWalkSpeed or 16
        self.Humanoid.JumpPower = self.OriginalJumpPower or 50
    end
end

return Movement
