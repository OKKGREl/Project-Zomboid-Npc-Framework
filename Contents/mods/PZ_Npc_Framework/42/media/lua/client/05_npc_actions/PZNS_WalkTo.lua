require "TimedActions/ISBaseTimedAction";
local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");
local PZNS_NPCsManager = require("04_data_management/PZNS_NPCsManager");
local PZNS_GeneralAI = require("07_npc_ai/PZNS_GeneralAI");

--- Cows: Have the specified NPC move to the square specified by xyz coordinates.
---@param npcSurvivor any
---@param squareX any
---@param squareY any
---@param squareZ any
function PZNS_WalkToSquareXYZ(npcSurvivor, squareX, squareY, squareZ)
    if (PZNS_UtilsNPCs.IsNPCSurvivorIsoPlayerValid(npcSurvivor) == false) then
        return;
    end
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    local targetSquare = getCell():getGridSquare(
        squareX, -- GridSquareX
        squareY, -- GridSquareY
        squareZ  -- Floor level
    );

	if targetSquare ~= nil then
		npcIsoPlayer:NpcSetRunning(false);
		local walkAction = ISWalkToTimedAction:new(npcIsoPlayer, targetSquare);

		PZNS_UtilsNPCs.PZNS_AddNPCActionToQueue(npcSurvivor, walkAction);
	end
end
