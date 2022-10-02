-----------------				Billy (TylrPopcorn) || Trulineo
--7,26,2021;

--[[
	The purpose of this script is to simulate a 'crowd' experience.
]]
wait(math.random(0,1))
local RunService = game:GetService('RunService')
local CrowdObj = script:WaitForChild('Crowd')
local UserInputService = game:GetService("UserInputService")

local Cheer = false --Used to determine if the crowd is active or not.
local functions = {} --All of the functions needed.
local parts = {} --All of the different parts that will be used.

local JumpHeight 	= 2 --Height
local JumpSpeed 	= 2 --Speed
------	----------
---FUNCTIONS:

functions.EnableCheer = function() --Allow cherring.
	if not Cheer then --If the function is not already active then
		--Trulineo:----------
		for i, Stand in pairs(parts) do
			Stand.lastTick = tick() + math.random(0, 100)/120
		end
		
		functions.Cheer = RunService.RenderStepped:Connect(function(deltaTime) 
			for i, Stand in pairs(parts) do
				
				if Stand.lastTick <= tick() then

					local deltaSpeed = JumpSpeed * (math.pi/JumpSpeed)
					Stand.Theta += math.rad(1 + (1 * deltaTime))
					Stand.Stand.CFrame = Stand.StandPos * CFrame.new(0, math.abs(math.sin(Stand.Theta * deltaSpeed) * JumpHeight), 0)
				end
			end
		end)
		------------
	end
end

functions.DisableCheer = function() --Disable the cheeering.
	if functions.Cheer ~= nil then
		functions.Cheer:Disconnect() --Disconnect the function.
		Cheer = false
	end
end

UserInputService.WindowFocused:Connect(function()--Each time the player opens the window again,
	functions.DisableCheer() --restart the crowd
	wait()
	functions.EnableCheer()
end)

--------------------------
--START HERE:
----------------------------------------------
for nam,obj in pairs(CrowdObj.Value:GetChildren()) do --get the children of the main model
	if obj.ClassName ~= "Script" and obj.ClassName == "Model" then --if the object is not a script then
		if obj:FindFirstChild("Crowd") == nil then --if the child does not have a child named "" then
			for nam2, obj2 in pairs(obj:GetChildren()) do --get the children of that child
				if obj2.ClassName == "Part" then --if the child is a "" then
					if not table.find(parts, obj2) then --If we cannot find the model / parent of the obj2 then
						table.insert(parts, obj2) --insert the parent model.
					end
				end
			end
		elseif obj:FindFirstChild("Crowd") then
			local Crowd2 = obj:FindFirstChild("Crowd")
			for nam,obj3 in pairs(Crowd2:GetChildren()) do --get the children of that child named ""
				if obj3.ClassName == "Part" then --if the child of that child is a  "" then
					if not table.find(parts, obj3) then
						table.insert(parts, obj3) --insert the parent model.
					end
				end
			end
		end
	end
end

for nam, obj in pairs(parts) do --Get the children of the overall parts we just inserted.
	if obj.ClassName == "Part" then
		obj.BrickColor = BrickColor.random() --change all of the children to a random color.	
				
		parts[nam] = { --Replace the part with a table.
			lastTick = tick() + math.random(),
			Stand = obj,
			StandPos = obj.CFrame,
			Theta = 0
		}
	end
end


wait(1) --Breathe.
functions.EnableCheer() --Begin cheering.

--[[ https://devforum.roblox.com/t/issues-with-lag-in-game/1362282 ]]
