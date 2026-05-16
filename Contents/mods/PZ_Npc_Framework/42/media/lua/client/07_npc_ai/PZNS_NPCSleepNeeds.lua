local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_UtilsDataNPCs = require("02_mod_utils/PZNS_UtilsDataNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");
local PZNS_GeneralAI = require("07_npc_ai/PZNS_GeneralAI");

local PZNS_NPCSleepNeeds = {};

function PZNS_NPCSleepNeeds.PZNS_HandleSleep(npcSurvivor)
	if (PZNS_GeneralAI.PZNS_IsNPCBusyCombat(npcSurvivor) == true) then
		npcSurvivor.sleepTicks = 0;
	else							
		local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;	
		if (npcIsoPlayer and npcIsoPlayer:getStats():getFatigue() >= 0.70) then
			local CurrentBuilding = npcIsoPlayer:getCurrentBuilding()
			
			if not (CurrentBuilding) then
				npcSurvivor.isDoingTask = false;
				return;
			end

			local bdef = CurrentBuilding:getDef();
			local rooms = bdef:getRooms();


			if not (rooms or rooms:size() == 0) then
				return
			end

			for i = 0, rooms:size() - 1 do
				local room = rooms:get(i):getIsoRoom()      
				if (room) then
					local Container = room:getSquares();        
					if (Container or Container:size() == 0) then
						for j = 0, Container:size() - 1 do
							local con = Container:get(j):getBed();
							if con ~= nil then
								-- sleep
							end
						end
					end
				end
			end			
					
			local Beds = {};		
		end
	end
end

return PZNS_NPCSleepNeeds;