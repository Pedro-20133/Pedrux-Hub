local ProtectionConfig = {
	-- 🔴 CRITICAL: This MUST exactly match the 'Secret' value in your Key System's Config!
	-- If your Key System has: Secret = "Test"
	-- Then this must also be: SecretKey = "Test"
	SecretKey = "MLXjpEL9F#4N4x!hoBIfwPDBIU!cPrf2T+2U(pdSdNATJ03@o#I",

	-- The name of your Hub (shown in the kick message if they try to bypass)
	HubName = "Pedrux Hub"
}

-- Anti-Bypass Logic: Checks if the Key System successfully set the global variable
if not _G[ProtectionConfig.SecretKey] then
	local player = game:GetService("Players").LocalPlayer
	if player then
		player:Kick("\n🛡️ Unauthorized Execution 🛡️\n\nPlease use the official Key System to run " .. ProtectionConfig.HubName)
	end
	return -- Stops the rest of the script from loading!
end

-------------------------------------------------------------------------------
-- 👇 YOUR MAIN SCRIPT CODE STARTS HERE 👇
-------------------------------------------------------------------------------

print(ProtectionConfig.HubName .. " Loaded Successfully!")

if not game:IsLoaded() then game.Loaded:Wait() end

-- getgenv().RAYFIELD_SECURE = true
local key_init = _G.KEY

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local player = Players.LocalPlayer
while not player do
	task.wait(0.1)
	player = Players.LocalPlayer
end

local char
local hrp
local hum

DISCORD_INVITE = "test"

local function setupCharacter(newChar)
	if not newChar then return end
	char = newChar

	hrp = char:WaitForChild("HumanoidRootPart", 5)
	hum = char:WaitForChild("Humanoid", 5)
end

if player.Character then setupCharacter(player.Character) end
player.CharacterAdded:Connect(setupCharacter)

local MainWindow = Rayfield:CreateWindow({
	name = "Pedrux Hub",
	subtitle = "Hub Mode",
	sidebarLayout = true,
	theme = "cobalt",

	configuration = {
		autoSave = true,
		autoLoad = true,
		fileName = "PedruxHub",
	},
})

local MainTab = MainWindow:CreateTab({ name = "Main", icon = 93364949241311 })
local ConfigsTab = MainWindow:CreateTab({ name = "Configs", icon = nil })

local Configs = {
	AutoChests = false,
}

MainTab:CreateToggle({
	name = "Auto Chests",
	flag = "AutoChests",
	value = false,
	callback = function(value)
		Configs.AutoChests = value
	end,
})

local ActiveTasks = {}
local function registerTask(taskName, interval, callback)
	if ActiveTasks[taskName] then
		task.cancel(ActiveTasks[taskName])
		ActiveTasks[taskName] = nil
	end

	ActiveTasks[taskName] = task.spawn(function()
		while true do
			if Configs[taskName] then
				local success, err = pcall(callback)
				if not success then
					warn("[Task Error][" .. taskName .. "]: " .. tostring(err))
				end
			end
			task.wait(interval)
		end
	end)
end

registerTask("AutoChests", 0.5, function()
	print("AutoChests Task Running")
end)

ConfigsTab:CreateButton({
	Name = "Desligar Tasks & Rayfield",
	Callback = function()
		for key in pairs(Configs) do
			Configs[key] = false
		end

		for taskName, thread in pairs(ActiveTasks) do
			if thread then
				task.cancel(thread)
			end
		end
		ActiveTasks = {}

		MainWindow:Unload()
	end,
})
