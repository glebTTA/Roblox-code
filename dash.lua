local player = game.Players.LocalPlayer
local humanoid = player.Character:WaitForChild("Humanoid") -- Player's humanoid

local button = script.Parent -- Dash Button
local cooldown = false -- Cooldown state
local cooldownTime = 5 -- Cooldown in seconds
local dashDistance = 50 -- Distance to dash forward
local dashSpeed = 100 -- Temporary speed boost
local dashDuration = 0.2 -- Dash lasts 0.2 seconds
local requiredLevel = 3 -- Minimum level required to dash

-- Function to get the player's level
local function getPlayerLevel()
	local leaderstats = player:FindFirstChild("leaderstats") -- Find the leaderstats folder
	if leaderstats then
		local level = leaderstats:FindFirstChild("Level") -- Find the Level value
		if level and level:IsA("IntValue") then
			return level.Value
		end
	end
	return 0 -- Default to level 0 if not found
end

-- Function to perform the dash
local function activateDash()
	-- Check if player meets level requirement
	if getPlayerLevel() < requiredLevel then
		print("You need to be at least level 3 to use Dash!")
		return
	end

	-- Check cooldown
	if cooldown then
		print("Dash is on cooldown!")
		return
	end

	-- Activate dash
	cooldown = true -- Start cooldown
	button.Text = "Dashing!" -- Update button text
	button.Active = false -- Disable button during dash

	-- Save original speed
	local originalSpeed = humanoid.WalkSpeed

	-- Boost speed temporarily
	humanoid.WalkSpeed = dashSpeed

	-- Dash forward
	local rootPart = player.Character.PrimaryPart -- Get player's root part
	rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -dashDistance) -- Move forward

	-- Wait for dash duration
	task.wait(dashDuration)

	-- Reset speed
	humanoid.WalkSpeed = originalSpeed
	print("Dash complete!")

	-- Start cooldown timer
	task.delay(cooldownTime, function()
		cooldown = false
		button.Text = "Dash"
		button.Active = true
		print("Dash is ready to use again!")
	end)
end

-- Connect the button click to the function
button.MouseButton1Click:Connect(activateDash)
