local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local npc = script.Parent
local humanoid = npc:FindFirstChildOfClass("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

if not humanoid then
	warn("NPC is missing Humanoid")
	return
end

-- Ensure NPC is ready to move
for _, part in pairs(npc:GetChildren()) do
	if part:IsA("BasePart") then
		part.Anchored = false
		part.CanTouch = true -- Enable touch detection on all parts
	end
end

-- Adjust NPC movement settings
humanoid.WalkSpeed = 10 

-- Load animations
local function loadAnimation(id)
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. id
	return animator:LoadAnimation(anim)
end

local runTrack = loadAnimation("102711978375276")  -- Run Animation ID
local hitTrack = loadAnimation("92474426514293")  -- Hit Animation ID

-- Damage settings
local DAMAGE = 10
local DAMAGE_INTERVAL = 1
local CHASE_DISTANCE = 50
local ATTACK_RANGE = 10
local activeDamage = {} -- Prevents multiple damage triggers per player

-- Function to deal damage
local function damagePlayer(player)
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum and hum.Health > 0 then
		if not hitTrack.IsPlaying then
			hitTrack:Play()
		end
		hum:TakeDamage(DAMAGE)
	end
end

-- Handle damage when touching any part of the NPC
for _, part in pairs(npc:GetChildren()) do
	if part:IsA("BasePart") then
		part.Touched:Connect(function(hit)
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if player and not activeDamage[player] then
				activeDamage[player] = true -- Prevent multiple triggers
				while player and player.Character and (player.Character:FindFirstChild("HumanoidRootPart") and (player.Character.HumanoidRootPart.Position - part.Position).Magnitude < ATTACK_RANGE) do
					damagePlayer(player)
					wait(DAMAGE_INTERVAL)
				end
				activeDamage[player] = nil -- Allow damage again after they leave
			end
		end)
	end
end

-- Function to follow the nearest player
local function followPlayer()
	while true do
		local target = nil
		local minDist = math.huge

		for _, player in pairs(Players:GetPlayers()) do
			local char = player.Character
			local playerRoot = char and char:FindFirstChild("HumanoidRootPart")

			if playerRoot then
				local distance = (playerRoot.Position - humanoid.Parent:GetPivot().Position).Magnitude
				if distance <= CHASE_DISTANCE and distance < minDist then
					target = playerRoot
					minDist = distance
				end
			end
		end

		if target then
			if not runTrack.IsPlaying then
				runTrack:Play()
			end
			humanoid:MoveTo(target.Position + Vector3.new(0, 0, -ATTACK_RANGE / 2)) -- Stop just before the player
		else
			if runTrack.IsPlaying then
				runTrack:Stop()
			end
		end

		RunService.Heartbeat:Wait()
	end
end

task.spawn(followPlayer)
