local button = script.Parent
local player = game.Players.LocalPlayer
local debounce = false

-- Super jump settings
local superJumpPower = 120 -- Temporary jump power for super jump
local defaultJumpPower = 50 -- Normal jump power (set your game's default here)
local cooldownTime = 3 -- Cooldown between jumps
local requiredLevel = 15 -- Minimum level required

button.MouseButton1Click:Connect(function()
	if debounce then return end

	-- Wait for character and stats
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local leaderstats = player:FindFirstChild("leaderstats")
	local levelStat = leaderstats and leaderstats:FindFirstChild("Level")

	if levelStat and levelStat.Value >= requiredLevel then
		debounce = true

		-- Enable UseJumpPower and set to super jump value
		if humanoid then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = superJumpPower
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- Force jump
		end

		-- Wait a short moment to let the jump happen, then reset JumpPower
		wait(0.5)
		if humanoid then
			humanoid.JumpPower = defaultJumpPower
		end

		wait(cooldownTime)
		debounce = false
	else
		-- Optional: notify player (print, warn, or GUI message)
		warn("You need to be at least level " .. requiredLevel .. " to use Super Jump!")
	end
end)
