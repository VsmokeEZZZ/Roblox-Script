local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Anonsperma Script",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "Big Hub"
    },
    KeySystem = false
})

local VisualTab = Window:CreateTab("Visual", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)

local isAutoFarmEnabled = false
local selectedFarmMode = "Basic"

PlayerTab:CreateDropdown({
    Name = "Auto-Farm Mode",
    Options = {"Basic", "Safe"},
    CurrentOption = "Basic",
    Callback = function(Value)
        selectedFarmMode = Value
    end,
})

PlayerTab:CreateButton({
    Name = "Auto Farm",
    Callback = function()
        isAutoFarmEnabled = not isAutoFarmEnabled

        if isAutoFarmEnabled then
            local player = game.Players.LocalPlayer

            coroutine.wrap(function()
                if selectedFarmMode == "Safe" then
                    player.Character.Humanoid.Health = 0
                    player.CharacterAdded:Wait()
                    wait(1)
                    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
                    humanoidRootPart.CFrame = CFrame.new(0, -100, 0)
                    player.Character:WaitForChild("Humanoid").PlatformStand = true
                end

                while isAutoFarmEnabled do
                    local nearestCoin = nil
                    local shortestDistance = math.huge

                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("Part") and obj.Name == "Coin_Server" then
                            local distance = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestCoin = obj
                            end
                        end
                    end

                    if nearestCoin then
                        if selectedFarmMode == "Basic" then
                            player.Character.HumanoidRootPart.CFrame = nearestCoin.CFrame
                        elseif selectedFarmMode == "Safe" then
                            nearestCoin.CFrame = player.Character.HumanoidRootPart.CFrame
                        end
                    else
                        print("Монеты не найдены!")
                    end

                    wait(0.1)
                end
            end)()
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {10, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "Slider1",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

PlayerTab:CreateSlider({
    Name = "Jump Height",
    Range = {10, 500},
    Increment = 1,
    Suffix = "Height",
    CurrentValue = 50,
    Flag = "Slider3",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
})

VisualTab:CreateButton({
    Name = "ESP Box",
    Callback = function()
        local player = game.Players.LocalPlayer

        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= player.Character then
                local espBox = Instance.new("BillboardGui")
                espBox.Adornee = v.HumanoidRootPart
                espBox.Size = UDim2.new(0, 200, 0, 200)
                espBox.StudsOffset = Vector3.new(0, 3, 0)
                espBox.Parent = v

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                frame.BorderSizePixel = 0
                frame.Parent = espBox
            end
        end
    end,
})
