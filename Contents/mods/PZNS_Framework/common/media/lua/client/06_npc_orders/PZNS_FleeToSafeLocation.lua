local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");
local PZNS_PresetsSpeeches = require("03_mod_core/PZNS_PresetsSpeeches");
--Okkg: Unused for now.
local function offsetTargetSquare(npcSurvivor, offset)
    --
    if (PZNS_UtilsNPCs.IsNPCSurvivorIsoPlayerValid(npcSurvivor) == false) then
        return false;
    end
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
	local currentSquare = npcIsoPlayer:getCurrentSquare();
	local X = currentSquare:getX();
	local Y = currentSquare:getY();
	local forwardVector = npcIsoPlayer:getForwardDirection();
	local forwardX = forwardVector:getX();
	local forwardY = forwardVector:getY();
	--
    if (forwardX >= 0 and forwardY >= 0) then
        currentSquare = currentSquare + offset;
    elseif (forwardX >= 0 and forwardY < 0) then
        Y = Y - offset;
		X = X + offset;
		currentSquare = npcIsoPlayer:getCell():getGridSquare(X, Y, 0)
    elseif (forwardX < 0 and forwardY >= 0) then
        X = X - offset;
		Y = Y + offset;
		currentSquare = npcIsoPlayer:getCell():getGridSquare(X, Y, 0)		
	else
		currentSquare = currentSquare - offset;
    end
    return currentSquare;
end

---Okkg: npcSurvivor will find the safest building and run to it.
---Okkg: The npcSurvivor wont flee if he is in a building already.
---@param npcSurvivor any
function PZNS_FleeToSafeLocation(npcSurvivor)
	if npcSurvivor.isFleeing == true then return end -- okkg: If npc is already fleeing return end
	
	if SandboxVars.PZNS_Framework.ShouldNpcFlee == false then return end
	
	if (npcSurvivor.jobName == "Companion" or npcSurvivor.jobName == "Undertaker" or npcSurvivor.jobName == "Guard") then return end -- okkg: companions wont run away now
	
	
    if (PZNS_UtilsNPCs.IsNPCSurvivorIsoPlayerValid(npcSurvivor) == false or square == nil) then
        return;
    end
    --
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
	--print("Fleeing");
	
	--if (npcSurvivor.jobName == "Undertaker" or npcSurvivor.jobName == "Guard") then
		-- WIP -- Okkg: figure something out that wont make the npc die...
	--end
	
	if (npcIsoPlayer:getCurrentBuilding() ~= nil) then
		-- WIP -- Okkg: I need to add something here so they stay in the building or the area around it.
	else
		-- WIP -- Okkg: Need to figure out something to get the opposite site to the zombies.
		local Rooms = PZNS_WorldUtils.PZNS_GetCellRoomsList();
		if Rooms == nil then
			print("No rooms in cell");
			return nil;
		end
		local SelectedRoom = PZNS_WorldUtils.PZNS_GetCellRandomRoom(Rooms);	
		local square = PZNS_WorldUtils.PZNS_GetRoomRandomFreeSquare(SelectedRoom);
		if (square == nil) then 
			print("No square in room");
			return;
		end
		local x1 = square:getX();
		local y1 = square:getY();
		local z1 = square:getZ();		
		npcIsoPlayer:NPCSetAttack(false);
		if (npcIsoPlayer:NPCGetAiming() == true) then
			npcIsoPlayer:NPCSetAiming(false);
		end	
		npcSurvivor.isForcedMoving = true;
		npcSurvivor.isFleeing = true;
		PZNS_RunToSquareXYZ(npcSurvivor, x1, y1, z1);
		
        if (npcSurvivor.speechTable == nil) then
            PZNS_UtilsNPCs.PZNS_UseNPCSpeechTable(
                 npcSurvivor, PZNS_PresetsSpeeches.PZNS_Flee
			);
        elseif (npcSurvivor.speechTable.PZNS_Flee) then
			PZNS_UtilsNPCs.PZNS_UseNPCSpeechTable(
				npcSurvivor, npcSurvivor.speechTable.PZNS_Flee
			);
        else
			PZNS_UtilsNPCs.PZNS_UseNPCSpeechTable(
				npcSurvivor, PZNS_PresetsSpeeches.PZNS_Flee
			);
        end			
	end
end