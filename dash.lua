local player = game.Players.LocalPlayer
local humanoid = player.Character:WaitForChild("Humanoid") -- Player's humanoid

local button = script.Parent -- Dash Button
local cooldown = false -- Cooldown state
local cooldownTime = 5 -- Cooldown in seconds
local dashDistance = 50 -- Distance to dash forward
local dashSpeed = 100 -- Temporary speed boost
local dashDuration = 0.2 -- Dash lasts 0.2 seconds

-- Function to perform the dash
local function activateDash()
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
	wait(dashDuration)

	-- Reset speed
	humanoid.WalkSpeed = originalSpeed
	print("Dash complete!")

	-- Reactivate button
	button.Text = "Dash"
	button.Active = true
	cooldown = false
end

-- Connect the button click to the function
button.MouseButton1Click:Connect(activateDash) Can you fix this script to only work when the player has level 3
