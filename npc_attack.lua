local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local npc = script.Parent
local rootPart = npc:FindFirstChild("HumanoidRootPart")
local humanoid = npc:FindFirstChildOfClass("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

if not rootPart or not humanoid then
	warn("NPC is missing HumanoidRootPart or Humanoid")
	return
end

-- Set NPC speed
humanoid.WalkSpeed = 25 -- Adjust speed

-- Load animations
local function loadAnimation(id)
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. id
	return animator:LoadAnimation(anim)
end

local runTrack = loadAnimation("102711978375276")  -- Run Animation ID
local hitTrack = loadAnimation("92474426514293")  -- Hit Animation ID

-- Damage settings
local DAMAGE = 10        -- Damage per second
local DAMAGE_INTERVAL = 1 -- Damage every 1 second

-- Function to apply damage when NPC is touching a player
local function damagePlayer(player)
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")

	if hum then
		if not hitTrack.IsPlaying then
			hitTrack:Play() -- Play hit animation
		end
		hum:TakeDamage(DAMAGE) -- Reduce health
	end
end

-- Function to detect and deal damage while touching player
rootPart.Touched:Connect(function(hit)
	local player = Players:GetPlayerFromCharacter(hit.Parent)
	if player then
		while player and player.Character and (rootPart.Position - player.Character.PrimaryPart.Position).Magnitude < 5 do
			damagePlayer(player)
			wait(DAMAGE_INTERVAL)
		end
	end
end)

-- Function to follow the nearest player
local function followPlayer()
	while true do
		local target = nil
		local minDist = math.huge

		for _, player in pairs(Players:GetPlayers()) do
			local char = player.Character
			local playerRoot = char and char:FindFirstChild("HumanoidRootPart")

			if playerRoot then
				local distance = (playerRoot.Position - rootPart.Position).Magnitude
				if distance <= 25 and distance < minDist then
					target = playerRoot
					minDist = distance
				end
			end
		end

		if target then
			if not runTrack.IsPlaying then
				runTrack:Play() -- Play run animation
			end
			humanoid:MoveTo(target.Position)
		else
			if runTrack.IsPlaying then
				runTrack:Stop() -- Stop run animation if no player is found
			end
		end

		RunService.Heartbeat:Wait()
	end
end

task.spawn(followPlayer)
