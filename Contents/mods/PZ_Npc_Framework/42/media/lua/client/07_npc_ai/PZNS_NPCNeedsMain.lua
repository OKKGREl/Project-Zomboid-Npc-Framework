local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_UtilsDataNPCs = require("02_mod_utils/PZNS_UtilsDataNPCs");
local PZNS_NPCFoodNeeds = require("07_npc_ai/PZNS_NPCFoodNeeds");


local PZNS_NPCNeedsMain = {};

function PZNS_NPCNeedsMain.PZNS_UpdateAllNeeds() 
	local activeNPCs = PZNS_UtilsDataNPCs.PZNS_GetCreateActiveNPCsModData();
	
    for survivorID, v in pairs(activeNPCs) do
		local npcSurvivor = activeNPCs[survivorID];
		if (npcSurvivor.isAlive == true and npcSurvivor and PZNS_UtilsNPCs.PZNS_GetIsNPCSquareLoaded(npcSurvivor)) then	
		
		
			npcSurvivor.waterTicks = npcSurvivor.waterTicks + 1	
			npcSurvivor.foodTicks = npcSurvivor.foodTicks + 1	
			--npcSurvivor.washingTicks = npcSurvivor.washingTicks + 1
			
			if (npcSurvivor.foodTicks >= 750) then
				PZNS_NPCFoodNeeds.PZNS_HandleFoodForAllNpcs(npcSurvivor);
			end
			
			if (npcSurvivor.waterTicks >= 600) then
				PZNS_NPCFoodNeeds.PZNS_HandleWaterForAllNpcs(npcSurvivor);
			end
			
			--if (npcSurvivor.washingTicks >= 2500) then
				--PZNS_NPCFoodNeeds.PZNS_HandleWaterForAllNpcs(npcSurvivor);
			--end			
		end
	end
end