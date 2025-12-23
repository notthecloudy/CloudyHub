-- Aimbot Module
-- Handles target selection and aiming

local Aimbot = {}

Aimbot.Enabled = false
Aimbot.CurrentTarget = nil
Aimbot.AimKeyHeld = false
Aimbot.SilentAimEnabled = false
Aimbot.OriginalMouse = nil

function Aimbot:Init(state)
    self.State = state
    self.Camera = workspace.CurrentCamera
    self.UserInputService = game:GetService("UserInputService")

    -- FOV Circle
    self.FOVCircle = Drawing.new("Circle")
    self.FOVCircle.Thickness = 1
    self.FOVCircle.Filled = false
    self.FOVCircle.Color = Color3.new(1, 1, 1)
    self.FOVCircle.Visible = false

    -- Keybind handling
    self.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then
            if input.UserInputType == Enum.UserInputType.MouseButton2 and self.State.AimKey == "MouseButton2" then
                self.AimKeyHeld = true
            elseif input.KeyCode == Enum.KeyCode[self.State.AimKey] then
                self.AimKeyHeld = true
            end
        end
    end)

    self.UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton2 and self.State.AimKey == "MouseButton2" then
            self.AimKeyHeld = false
        elseif input.KeyCode == Enum.KeyCode[self.State.AimKey] then
            self.AimKeyHeld = false
        end
    end)
end

function Aimbot:UpdateRender(dt)
    if not self.State.AimbotEnabled or not self.AimKeyHeld then return end

    self:SelectTarget()
    if self.CurrentTarget then
        self:AimAtTarget(dt)
    end
end

function Aimbot:SelectTarget()
    local localPlayer = game.Players.LocalPlayer
    local camera = self.Camera
    local mousePos = self.UserInputService:GetMouseLocation()
    local centerScreen = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    local bestTarget = nil
    local bestScore = math.huge

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                local isTeam = false
                if self.State.AimTeamCheck and player.Team and localPlayer.Team then
                    isTeam = player.Team == localPlayer.Team
                end

                if not isTeam then
                    local targetPart = character:FindFirstChild(self.State.AimBone)
                    if targetPart then
                        local targetPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local screenPos = Vector2.new(targetPos.X, targetPos.Y)
                            local distanceToCenter = (screenPos - centerScreen).Magnitude
                            local distanceToMouse = (screenPos - mousePos).Magnitude

                            if distanceToCenter <= self.State.AimFOV then
                                local healthScore = (character.Humanoid.Health / character.Humanoid.MaxHealth) * 100
                                local score = distanceToCenter * 0.5 + distanceToMouse * 0.3 + healthScore
                                if score < bestScore then
                                    bestScore = score
                                    bestTarget = {Player = player, Part = targetPart, ScreenPos = screenPos}
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    self.CurrentTarget = bestTarget
end

function Aimbot:AimAtTarget(dt)
    if not self.CurrentTarget then return end

    local targetPos = self.CurrentTarget.Part.Position

    if self.State.AimPrediction then
        -- Simple prediction: assume target is moving towards camera
        local humanoid = self.CurrentTarget.Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            local velocity = humanoid.MoveDirection * humanoid.WalkSpeed
            targetPos = targetPos + velocity * 0.1 -- Rough prediction
        end
    end

    local cameraPos = self.Camera.CFrame.Position
    local targetCFrame = CFrame.lookAt(cameraPos, targetPos)
    local currentCFrame = self.Camera.CFrame

    -- Smooth aiming
    self.Camera.CFrame = currentCFrame:Lerp(targetCFrame, self.State.AimSmoothing * dt * 10)
end

function Aimbot:Cleanup()
    self.CurrentTarget = nil
    self.AimKeyHeld = false
    self.FOVCircle.Visible = false
end

return Aimbot
