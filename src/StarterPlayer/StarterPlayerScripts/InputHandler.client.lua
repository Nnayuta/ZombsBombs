local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local dropBombRemoteEvent = game:GetService("ReplicatedStorage").DropBombEvent

-- Constants
local ACTION_KEY = Enum.KeyCode.E
local GAMEPAD_ACTION_KEY = Enum.KeyCode.ButtonR1
local CONTEXT = "DropBomb"

local function dropBomb()
	local bombLimit = player:GetAttribute("BombLimit")
	
	local bombQuantity = #workspace.SpawnedBombs:GetChildren()
	if bombQuantity > bombLimit then
		return
	end
	
	dropBombRemoteEvent:FireServer()
end

local function handleDropBombInput(actioName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		dropBomb()
	end
end

ContextActionService:BindAction(CONTEXT, handleDropBombInput, true, ACTION_KEY, GAMEPAD_ACTION_KEY)
ContextActionService:SetPosition(CONTEXT, UDim2.new(1, -70, 0, 10))
ContextActionService:SetTitle(CONTEXT, "Bomb!")