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
                while isAutoFarmEnabled do
                    local nearestCoin = nil
                    local shortestDistance = math.huge

                    -- Нахождение ближайшей монеты
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("Part") and obj.Name == "Coin_Server" then
                            local distance = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestCoin = obj
                            end
                        end
                    end

                    -- Логика для режимов фарма
                    if nearestCoin then
                        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            if selectedFarmMode == "Basic" then
                                humanoidRootPart.CFrame = nearestCoin.CFrame
                            elseif selectedFarmMode == "Safe" then
                                -- Перемещение персонажа под картой
                                humanoidRootPart.CFrame = CFrame.new(nearestCoin.Position + Vector3.new(0, -100, 0))
                                -- Притягивание монеты
                                nearestCoin.CFrame = humanoidRootPart.CFrame
                            end
                        else
                            warn("HumanoidRootPart не найден")
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
