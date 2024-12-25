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
local isAntiAfkEnabled = false
local farmSpeed = 25
local antiAfkConnection
local antiAfkLabel

local isEspEnabled = false
local espConnection
VisualTab:CreateButton({
    Name = "ESP Box",
    Callback = function()
        isEspEnabled = not isEspEnabled

        if isEspEnabled then
            espConnection = game:GetService("RunService").Heartbeat:Connect(function()
                for _, child in ipairs(workspace:GetDescendants()) do
                    if child:FindFirstChild("Humanoid") then
                        if not child:FindFirstChild("EspBox") and child ~= game.Players.LocalPlayer.Character then
                            local esp = Instance.new("BoxHandleAdornment")
                            esp.Adornee = child
                            esp.Size = Vector3.new(4, 5, 1)
                            esp.Transparency = 0.65
                            esp.Color3 = Color3.fromRGB(255, 255, 255)
                            esp.AlwaysOnTop = true
                            esp.Name = "EspBox"
                            esp.Parent = child
                        end
                    end
                end
            end)
        else
            if espConnection then
                espConnection:Disconnect()
            end
            for _, child in ipairs(workspace:GetDescendants()) do
                if child:FindFirstChild("EspBox") then
                    child.EspBox:Destroy()
                end
            end
        end
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

                    for _, obj in ipairs(game.Workspace:GetDescendants()) do
                        if obj:IsA("Part") and obj.Name == "Coin_Server" then
                            local distance = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestCoin = obj
                            end
                        end
                    end

                    if nearestCoin then
                        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            local targetPosition = nearestCoin.Position + Vector3.new(0, 3, 0)
                            humanoidRootPart.CFrame = humanoidRootPart.CFrame:lerp(CFrame.new(targetPosition), farmSpeed / 100)
                        end
                    end

                    wait(0.1)
                end
            end)()
        end
    end,
})

PlayerTab:CreateButton({
    Name = "Anti AFK",
    Callback = function()
        isAntiAfkEnabled = not isAntiAfkEnabled

        if isAntiAfkEnabled then
            local vu = game:GetService("VirtualUser")
            antiAfkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                vu:CaptureController()
                vu:ClickButton2(Vector2.new(math.random(1, 500), math.random(1, 500)))
            end)

            if not antiAfkLabel then
                local screenGui = Instance.new("ScreenGui")
                screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                antiAfkLabel = Instance.new("TextLabel")
                antiAfkLabel.Parent = screenGui
                antiAfkLabel.Size = UDim2.new(0, 200, 0, 50)
                antiAfkLabel.Position = UDim2.new(0.5, -100, 0.05, 0)
                antiAfkLabel.BackgroundTransparency = 0.5
                antiAfkLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                antiAfkLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                antiAfkLabel.Text = "Anti AFK: Active"
                antiAfkLabel.TextScaled = true
                antiAfkLabel.Font = Enum.Font.SourceSansBold
            end
        else
            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end

            if antiAfkLabel then
                antiAfkLabel:Destroy()
                antiAfkLabel = nil
            end
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
