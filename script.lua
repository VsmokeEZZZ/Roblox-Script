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
                    player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(0, -100, 0)
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
