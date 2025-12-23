-- Misc Module
-- Handles miscellaneous utilities

local Misc = {}

Misc.Enabled = false
Misc.AntiAFKConnection = nil

function Misc:Init(state)
    self.State = state
    self.LocalPlayer = game.Players.LocalPlayer
    self.VirtualUser = game:GetService("VirtualUser")
end

function Misc:UpdateHeartbeat(dt)
    if not self.Enabled then return end

    -- Auto Respawn
    if self.State.AutoRespawn then
        local humanoid = self:GetHumanoid()
        if humanoid and humanoid.Health <= 0 then
            wait(1) -- Small delay
            self.LocalPlayer:LoadCharacter()
        end
    end

    -- Anti AFK
    if self.State.AntiAFK then
        self:EnableAntiAFK()
    else
        self:DisableAntiAFK()
    end
end

function Misc:EnableAntiAFK()
    if self.AntiAFKConnection then return end

    self.AntiAFKConnection = self.LocalPlayer.Idled:Connect(function()
        self.VirtualUser:CaptureController()
        self.VirtualUser:ClickButton2(Vector2.new())
    end)
end

function Misc:DisableAntiAFK()
    if self.AntiAFKConnection then
        self.AntiAFKConnection:Disconnect()
        self.AntiAFKConnection = nil
    end
end

function Misc:TeleportToRandomPlayer()
    local players = game.Players:GetPlayers()
    local randomPlayer = players[math.random(1, #players)]

    if randomPlayer ~= self.LocalPlayer and randomPlayer.Character then
        local targetPos = randomPlayer.Character.HumanoidRootPart.Position
        local localCharacter = self.LocalPlayer.Character
        if localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") then
            localCharacter.HumanoidRootPart.CFrame = CFrame.new(targetPos)
        end
    end
end

function Misc:GetHumanoid()
    local character = self.LocalPlayer.Character
    return character and character:FindFirstChild("Humanoid")
end

function Misc:Cleanup()
    self:DisableAntiAFK()
end

return Misc
