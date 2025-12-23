-- ESP Module
-- Handles drawing ESP elements like boxes, names, health bars, tracers

local ESP = {}

ESP.Enabled = false
ESP.DrawingObjects = {}
ESP.Players = {}

function ESP:Init(state)
    self.State = state
    self.Camera = workspace.CurrentCamera
    self.PlayersService = game:GetService("Players")
    self.LocalPlayer = self.PlayersService.LocalPlayer

    -- Create drawing object pools
    self.DrawingObjects.Boxes = {}
    self.DrawingObjects.Names = {}
    self.DrawingObjects.HealthBars = {}
    self.DrawingObjects.Tracers = {}

    -- Preallocate drawing objects
    self:CreateDrawingPool()

    -- Connect to player events
    self.PlayersService.PlayerAdded:Connect(function(player)
        self:AddPlayer(player)
    end)

    self.PlayersService.PlayerRemoving:Connect(function(player)
        self:RemovePlayer(player)
    end)

    -- Add existing players
    for _, player in ipairs(self.PlayersService:GetPlayers()) do
        if player ~= self.LocalPlayer then
            self:AddPlayer(player)
        end
    end
end

function ESP:CreateDrawingPool()
    -- Create pool of drawing objects for performance
    for i = 1, 50 do -- Preallocate for up to 50 players
        -- Box
        local box = Drawing.new("Square")
        box.Thickness = 1
        box.Filled = false
        box.Visible = false
        table.insert(self.DrawingObjects.Boxes, box)

        -- Name
        local name = Drawing.new("Text")
        name.Size = 14
        name.Center = true
        name.Outline = true
        name.Visible = false
        table.insert(self.DrawingObjects.Names, name)

        -- Health Bar Background
        local healthBg = Drawing.new("Square")
        healthBg.Filled = true
        healthBg.Visible = false
        table.insert(self.DrawingObjects.HealthBars, {Bg = healthBg})

        -- Health Bar Fill
        local healthFill = Drawing.new("Square")
        healthFill.Filled = true
        healthFill.Visible = false
        self.DrawingObjects.HealthBars[i].Fill = healthFill

        -- Tracer
        local tracer = Drawing.new("Line")
        tracer.Thickness = 1
        tracer.Visible = false
        table.insert(self.DrawingObjects.Tracers, tracer)
    end
end

function ESP:GetDrawingObject(type)
    local pool = self.DrawingObjects[type]
    if not pool then return nil end

    for _, obj in ipairs(pool) do
        if not obj.InUse then
            obj.InUse = true
            return obj
        end
    end

    -- If no available objects, create new one
    if type == "Boxes" then
        local box = Drawing.new("Square")
        box.Thickness = 1
        box.Filled = false
        box.Visible = false
        box.InUse = true
        table.insert(pool, box)
        return box
    elseif type == "Names" then
        local name = Drawing.new("Text")
        name.Size = 14
        name.Center = true
        name.Outline = true
        name.Visible = false
        name.InUse = true
        table.insert(pool, name)
        return name
    elseif type == "Tracers" then
        local tracer = Drawing.new("Line")
        tracer.Thickness = 1
        tracer.Visible = false
        tracer.InUse = true
        table.insert(pool, tracer)
        return tracer
    end

    return nil
end

function ESP:ReturnDrawingObject(obj)
    if obj then
        obj.Visible = false
        obj.InUse = false
    end
end

function ESP:AddPlayer(player)
    if player == self.LocalPlayer then return end

    self.Players[player] = {
        Box = nil,
        Name = nil,
        HealthBar = nil,
        Tracer = nil,
        Chams = nil,
        Character = nil,
        Humanoid = nil
    }

    -- Connect to character events
    player.CharacterAdded:Connect(function(character)
        self:OnCharacterAdded(player, character)
    end)

    player.CharacterRemoving:Connect(function()
        self:OnCharacterRemoved(player)
    end)

    -- Add existing character
    if player.Character then
        self:OnCharacterAdded(player, player.Character)
    end
end

function ESP:RemovePlayer(player)
    if self.Players[player] then
        -- Return drawing objects to pool
        if self.Players[player].Box then
            self:ReturnDrawingObject(self.Players[player].Box)
        end
        if self.Players[player].Name then
            self:ReturnDrawingObject(self.Players[player].Name)
        end
        if self.Players[player].HealthBar then
            self:ReturnDrawingObject(self.Players[player].HealthBar.Bg)
            self:ReturnDrawingObject(self.Players[player].HealthBar.Fill)
        end
        if self.Players[player].Tracer then
            self:ReturnDrawingObject(self.Players[player].Tracer)
        end

        self.Players[player] = nil
    end
end

function ESP:OnCharacterAdded(player, character)
    if not self.Players[player] then return end

    self.Players[player].Character = character
    self.Players[player].Humanoid = character:FindFirstChild("Humanoid")

    -- Get drawing objects
    if self.State.ESPBoxes then
        self.Players[player].Box = self:GetDrawingObject("Boxes")
    end
    if self.State.ESPNames then
        self.Players[player].Name = self:GetDrawingObject("Names")
    end
    if self.State.ESPHealth then
        self.Players[player].HealthBar = {
            Bg = self:GetDrawingObject("HealthBars").Bg,
            Fill = self:GetDrawingObject("HealthBars").Fill
        }
    end
    if self.State.ESPTracers then
        self.Players[player].Tracer = self:GetDrawingObject("Tracers")
    end

    -- Chams
    if self.State.ESPChams then
        self:CreateChams(player, character)
    end
end

function ESP:OnCharacterRemoved(player)
    if not self.Players[player] then return end

    -- Return drawing objects
    if self.Players[player].Box then
        self:ReturnDrawingObject(self.Players[player].Box)
        self.Players[player].Box = nil
    end
    if self.Players[player].Name then
        self:ReturnDrawingObject(self.Players[player].Name)
        self.Players[player].Name = nil
    end
    if self.Players[player].HealthBar then
        self:ReturnDrawingObject(self.Players[player].HealthBar.Bg)
        self:ReturnDrawingObject(self.Players[player].HealthBar.Fill)
        self.Players[player].HealthBar = nil
    end
    if self.Players[player].Tracer then
        self:ReturnDrawingObject(self.Players[player].Tracer)
        self.Players[player].Tracer = nil
    end

    self.Players[player].Character = nil
    self.Players[player].Humanoid = nil
end

function ESP:UpdateRender(dt)
    if not self.State.ESPEnabled then return end

    self.UpdateTimer = (self.UpdateTimer or 0) + dt

    for player, data in pairs(self.Players) do
        if data.Character and data.Humanoid and data.Humanoid.Health > 0 then
            local rootPart = data.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local distance = (rootPart.Position - self.Camera.CFrame.Position).Magnitude
                if distance <= self.State.ESPMaxDistance then
                    local isTeam = false
                    if self.State.ESPTeamCheck and player.Team and self.LocalPlayer.Team then
                        isTeam = player.Team == self.LocalPlayer.Team
                    end

                    if not isTeam then
                        -- Update close players every frame, distant players less frequently
                        local updateFrequency = distance > 500 and 0.5 or 0 -- 0.5 seconds for distant, every frame for close
                        if not data.LastUpdate or (self.UpdateTimer - data.LastUpdate) >= updateFrequency then
                            self:UpdateESP(player, data, distance)
                            data.LastUpdate = self.UpdateTimer
                        end
                    else
                        self:HideESP(data)
                    end
                else
                    self:HideESP(data)
                end
            else
                self:HideESP(data)
            end
        else
            self:HideESP(data)
        end
    end
end

function ESP:UpdateESP(player, data, distance)
    local rootPart = data.Character.HumanoidRootPart
    local head = data.Character:FindFirstChild("Head")

    if not rootPart or not head then
        self:HideESP(data)
        return
    end

    -- Calculate screen position
    local rootPos, rootOnScreen = self.Camera:WorldToViewportPoint(rootPart.Position)
    local headPos, headOnScreen = self.Camera:WorldToViewportPoint(head.Position)

    if not rootOnScreen or not headOnScreen then
        self:HideESP(data)
        return
    end

    -- Determine color
    local color = self.State.ESPColor
    if player.Team and self.LocalPlayer.Team and player.Team ~= self.LocalPlayer.Team then
        color = self.State.ESPTeamColor
    end

    -- Update Box
    if data.Box and self.State.ESPBoxes then
        local height = math.abs(headPos.Y - rootPos.Y)
        local width = height * 0.6

        data.Box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height)
        data.Box.Size = Vector2.new(width, height)
        data.Box.Color = color
        data.Box.Visible = true
    elseif data.Box then
        data.Box.Visible = false
    end

    -- Update Name
    if data.Name and self.State.ESPNames then
        data.Name.Position = Vector2.new(rootPos.X, rootPos.Y - 40)
        data.Name.Text = player.Name
        data.Name.Color = color
        data.Name.Visible = true
    elseif data.Name then
        data.Name.Visible = false
    end

    -- Update Health Bar
    if data.HealthBar and self.State.ESPHealth then
        local healthPercent = data.Humanoid.Health / data.Humanoid.MaxHealth
        local barWidth = 4
        local barHeight = 20

        -- Background
        data.HealthBar.Bg.Position = Vector2.new(rootPos.X - 20, rootPos.Y - 10)
        data.HealthBar.Bg.Size = Vector2.new(barWidth, barHeight)
        data.HealthBar.Bg.Color = Color3.new(0, 0, 0)
        data.HealthBar.Bg.Visible = true

        -- Fill
        data.HealthBar.Fill.Position = Vector2.new(rootPos.X - 20, rootPos.Y - 10 + (barHeight * (1 - healthPercent)))
        data.HealthBar.Fill.Size = Vector2.new(barWidth, barHeight * healthPercent)
        data.HealthBar.Fill.Color = Color3.new(0, 1, 0)
        data.HealthBar.Fill.Visible = true
    elseif data.HealthBar then
        data.HealthBar.Bg.Visible = false
        data.HealthBar.Fill.Visible = false
    end

    -- Update Tracer
    if data.Tracer and self.State.ESPTracers then
        local screenCenter = Vector2.new(self.Camera.ViewportSize.X / 2, self.Camera.ViewportSize.Y / 2)
        data.Tracer.From = screenCenter
        data.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
        data.Tracer.Color = color
        data.Tracer.Visible = true
    elseif data.Tracer then
        data.Tracer.Visible = false
    end
end

function ESP:HideESP(data)
    if data.Box then data.Box.Visible = false end
    if data.Name then data.Name.Visible = false end
    if data.HealthBar then
        data.HealthBar.Bg.Visible = false
        data.HealthBar.Fill.Visible = false
    end
    if data.Tracer then data.Tracer.Visible = false end
end

function ESP:CreateChams(player, character)
    if self.Players[player].Chams then
        self.Players[player].Chams:Destroy()
    end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = self.State.ESPColor
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = character

    self.Players[player].Chams = highlight
end

function ESP:Cleanup()
    -- Hide all ESP elements
    for _, data in pairs(self.Players) do
        self:HideESP(data)
        if data.Chams then
            data.Chams:Destroy()
        end
    end

    -- Clear players table
    self.Players = {}
end

return ESP
