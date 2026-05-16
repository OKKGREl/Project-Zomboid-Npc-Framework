local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");
local PZNS_GeneralAI = require("07_npc_ai/PZNS_GeneralAI");

--[[
    - WIP - Cows: "Wandering" can be unpredictable and without destination nor end goal... so my intent is to categorize the "wandering" into limited or specified areas to limit potential issues.
--]]

--- Cows: This "Job" has the NPC move around inside the current building it is in.
---@param npcSurvivor any
function PZNS_JobWanderInBuilding(npcSurvivor)
    if (PZNS_UtilsNPCs.IsNPCSurvivorIsoPlayerValid(npcSurvivor) == false) then
        return;
    end
    if (PZNS_GeneralAI.PZNS_IsNPCBusyCombat(npcSurvivor) == true) then
        return; -- Cows Stop Processing and let the NPC finish its actions.
    end
	

    --- Cows: Now we can assume the NPC is valid and not busy in combat below this line ---
    ---@type IsoPlayer
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;

	--if npcSurvivor.isDoingTask == true then
	--	return;
	--end
	
	npcSurvivor.jobTicks = npcSurvivor.jobTicks + 1;


    -- Cows: Check if npcSurvivor is not holding in place
    if (npcSurvivor.isHoldingInPlace == false  and npcSurvivor.jobTicks % 5 == 0) then
        -- Cows: Check if the npcSurvivor has a destination with jobSquare
        if (npcSurvivor.jobSquare == nil) then
            local npcPlayerSquare = npcIsoPlayer:getSquare();
            if npcPlayerSquare ~= nil then
                local targetBuilding = npcPlayerSquare:getBuilding();
                PZNS_GeneralAI.PZNS_ExploreTargetBuilding(npcSurvivor, targetBuilding);
            end
        else
            -- Cows: Else assume the NPC is moving inside the building it is in.
            local distanceFromTarget = PZNS_WorldUtils.PZNS_GetDistanceBetweenTwoObjects(
                npcIsoPlayer, npcSurvivor.jobSquare
            );
			
            if (npcSurvivor.jobTicks % 120 == 0) then
                if (PZNS_GeneralAI.PZNS_IsPathBlocked(npcSurvivor) == true) then
                    PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor);
                    npcSurvivor.jobSquare = nil;
					npcSurvivor.jobTicks = 0;
                    return;
                end
            end
            -- Cows: Check if the NPC is near its destination...
            if (distanceFromTarget < 1) then
                -- Cows: Allow the NPC to idle for a moment before restarting its routine.
                if (npcSurvivor.jobTicks >= 500) then
                    PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor);
                    npcSurvivor.jobSquare = nil;
					npcSurvivor.jobTicks = 0;
                end
                return; -- Cows: Stop processing, the NPC is already at it's destination.
            else
                PZNS_GeneralAI.PZNS_WalkToJobSquare(npcSurvivor);
            end
        end
    elseif (npcSurvivor.isHoldingInPlace == true and npcSurvivor.jobTicks % 5 == 0) then
        PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor);
        PZNS_GeneralAI.PZNS_WalkToJobSquare(npcSurvivor);
    end
end
