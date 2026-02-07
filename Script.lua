-- LocalScript
-- Hecho por Yahiaryx

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local godMode = false
local speedEnabled = false
local tsunamiAuto = false
local speedValue = 16
local loopConn

-- ================= FUNCIONES =================

local function mainLoop()
	if loopConn then loopConn:Disconnect() end

	loopConn = RunService.RenderStepped:Connect(function()
		local char = player.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then return end

		if godMode then
			hum.Health = hum.MaxHealth
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		end

		if speedEnabled then
			hum.WalkSpeed = speedValue
		end

		if tsunamiAuto then
			local waves = workspace:FindFirstChild("Waves")
			if waves then
				for _, obj in pairs(waves:GetDescendants()) do
					if obj:IsA("BasePart") or obj:IsA("Model") then
						pcall(function()
							obj:Destroy()
						end)
					end
				end
			end
		end
	end)
end

-- ================= GUI =================

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "Tsunami Control"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- God Mode
local godBtn = Instance.new("TextButton", frame)
godBtn.Position = UDim2.new(0.1,0,0,45)
godBtn.Size = UDim2.new(0.8,0,0,40)
godBtn.Text = "God Mode: OFF"
godBtn.Font = Enum.Font.GothamBold
godBtn.TextScaled = true
godBtn.BackgroundColor3 = Color3.fromRGB(140,0,0)
godBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", godBtn)

-- Speed
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Position = UDim2.new(0.1,0,0,95)
speedBtn.Size = UDim2.new(0.8,0,0,40)
speedBtn.Text = "Speed: OFF"
speedBtn.Font = Enum.Font.GothamBold
speedBtn.TextScaled = true
speedBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
speedBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedBtn)

-- Auto Destroy Tsunami
local tsunamiBtn = Instance.new("TextButton", frame)
tsunamiBtn.Position = UDim2.new(0.1,0,0,145)
tsunamiBtn.Size = UDim2.new(0.8,0,0,45)
tsunamiBtn.Text = "Auto Destroy Tsunami: OFF"
tsunamiBtn.Font = Enum.Font.GothamBold
tsunamiBtn.TextScaled = true
tsunamiBtn.BackgroundColor3 = Color3.fromRGB(0,80,140)
tsunamiBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tsunamiBtn)

-- ================= BOTONES =================

godBtn.MouseButton1Click:Connect(function()
	godMode = not godMode
	godBtn.Text = "God Mode: " .. (godMode and "ON" or "OFF")
	godBtn.BackgroundColor3 = godMode and Color3.fromRGB(0,160,0) or Color3.fromRGB(140,0,0)
	mainLoop()
end)

speedBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedValue = speedEnabled and 60 or 16
	speedBtn.Text = "Speed: " .. (speedEnabled and "ON" or "OFF")
	speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(0,160,0) or Color3.fromRGB(60,60,60)
	mainLoop()
end)

tsunamiBtn.MouseButton1Click:Connect(function()
	tsunamiAuto = not tsunamiAuto
	tsunamiBtn.Text = "Auto Destroy Tsunami: " .. (tsunamiAuto and "ON" or "OFF")
	tsunamiBtn.BackgroundColor3 = tsunamiAuto and Color3.fromRGB(0,160,0) or Color3.fromRGB(0,80,140)
	mainLoop()
end)

player.CharacterAdded:Connect(function()
	task.wait(0.2)
	mainLoop()
end)
