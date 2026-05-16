local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_UtilsDataNPCs = require("02_mod_utils/PZNS_UtilsDataNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");
local PZNS_GeneralAI = require("07_npc_ai/PZNS_GeneralAI");

local PZNS_NPCFoodNeeds = {};
local frameworkID = "PZNS_Framework";

local function offsetTargetSquare(currentSquare, targetSquare, offset)
    --
    if (currentSquare > targetSquare) then
        targetSquare = targetSquare + offset;
    else
        targetSquare = targetSquare - offset;
    end
    return targetSquare;
end

function PZNS_NPCFoodNeeds.PZNS_FindFood(npcSurvivor)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject
    local CurrentBuilding = npcIsoPlayer:getCurrentBuilding()
    
    if not (CurrentBuilding) then
		npcSurvivor.isDoingTask = false;
        return;
    end

    local bdef = CurrentBuilding:getDef();
    local rooms = bdef:getRooms();
	local Containers = {};

    if not (rooms or rooms:size() == 0) then
		npcSurvivor.isDoingTask = false;
        return;
    end

    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i):getIsoRoom()       
        if (room) then
            local Container = room:getSquares()
            if (Container or Container:size() == 0) then
                for j = 0, Container:size() - 1 do
                    local con = Container:get(j):getObjects()
					if (con or con:size() > 0) then
						for ji = 0, con:size() - 1 do
							local container = con:get(ji):getContainer()
							if (container) then
								table.insert(Containers, container)
							end
						end
					end
                end
            end
        end
    end

    if (#Containers > 0) then
        for _, value in ipairs(Containers) do

            local ContainerItems = value:getItems();
			local FoodItems = {};

            if ContainerItems or ContainerItems:size() == 0 then
				for i = 1, ContainerItems:size() - 1 do
					local item = ContainerItems:get(i);
					if (item) then
						local success, category = pcall(function() return item:getDisplayCategory() end);
						if (success and category and category == "Food") or item:IsFood() and item:isDangerousUncooked() == false then
							table.insert(FoodItems, item);
						end
					end
				end
			end

			local ContainerSquare = value:getSourceGrid();	
            if (FoodItems and #FoodItems > 0) then		           
                if (PZNS_WorldUtils.PZNS_GetDistanceBetweenTwoObjects(npcIsoPlayer, ContainerSquare) < 2) then
				
					--PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor);
                    local FoodItem = FoodItems[ZombRand(1, #FoodItems)];
					
                    local LootAction = ISInventoryTransferAction:new(npcIsoPlayer, FoodItem, value, inv, 120);
                    PZNS_UtilsNPCs.PZNS_AddNPCActionToQueue(npcSurvivor, LootAction);
					
					npcSurvivor.isDoingTask = true;
					return;
                else		
					local squareX, squareY, squareZ = offsetTargetSquare(npcIsoPlayer:getX(), ContainerSquare:getX(), 1), offsetTargetSquare(npcIsoPlayer:getY(), ContainerSquare:getY(), 1), ContainerSquare:getZ();
					--PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor);
					
                    npcSurvivor.currentAction = "Walking";
					PZNS_WalkToSquareXYZ(npcSurvivor, squareX , squareY, squareZ);
					
					npcSurvivor.isDoingTask = true;
					print("walk");
					return;
                end
			else
				npcSurvivor.isDoingTask = false;
				npcSurvivor.GettingFood = false;
            end
        end
	else
		npcSurvivor.isDoingTask = false;
		npcSurvivor.GettingFood = false;	
    end
end

function PZNS_NPCFoodNeeds.PZNS_GetFoodItem(npcIsoPlayer) --Made by okkg
    local inv = npcIsoPlayer:getInventory()
    local FoodList = {};
    local items = inv:getItems();

    if (items) then
        for i = 1, items:size() - 1 do
            local item = items:get(i);
			local success, category = pcall(function() return item:getDisplayCategory() end);
			if success and category and string.match(category, "Food") and item:isDangerousUncooked() == false then
				table.insert(FoodList, item);	
			elseif item:IsFood() and item:isDangerousUncooked() == false then
				table.insert(FoodList, item);
            end
        end
    end
	return FoodList;
end
 
function PZNS_NPCFoodNeeds.PZNS_HandleFoodForAllNpcs(npcSurvivor) --Made by okkg
	if (PZNS_GeneralAI.PZNS_IsNPCBusyCombat(npcSurvivor) == true or npcSurvivor.GettingWater == true) then
		npcSurvivor.foodTicks = 0;
		npcSurvivor.GettingFood = false;
	else							
		local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;	
		if (npcIsoPlayer and npcIsoPlayer:getStats():getHunger() >= 0.5) then 
			local FoodItems = PZNS_NPCFoodNeeds.PZNS_GetFoodItem(npcIsoPlayer);

			--local EatableFoodList = {};
			--local CannedFoodList = {};
			--local RawFoodList = {};
			local FoodToEat = nil;

			--if (FoodItems) then --Made by okkg
			--	for i, _ in pairs(FoodItems) do
			--		local item = FoodItems[i];
									
			--		if string.match(item:getDisplayCategory(), "Food") then
						--if (item:isDangerousUncooked()) then
						--	table.insert(RawFoodList, item);	
						--else
						--	if (item:CannedFood()) then
						--		table.insert(CannedFoodList, item);						
						--	else --Madebyokkglol
						--		table.insert(EatableFoodList, item);			
						--	end
						--end
			--		end
			--	end
			--end
									
			--if (EatableFoodList == nil) then
			--	if (RawFoodList == nil) then
			--		FoodToEat = CannedFoodList;
			--	else
			--		FoodToEat = RawFoodList;
			--	end
			--else
								
			if (#FoodItems > 0) then
				FoodToEat = FoodItems[ZombRand(1, #FoodItems)];
								
				--if (FoodToEat:CannedFood()) then
					--local opencanAction = 
				--end
								
				local eatAction = ISEatFoodAction:new(npcIsoPlayer, FoodToEat, 0.5);
				PZNS_UtilsNPCs.PZNS_AddNPCActionToQueue(npcSurvivor, eatAction);	
				npcSurvivor.GettingFood = true;
				print("eat");
			else
				PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor);
				PZNS_NPCFoodNeeds.PZNS_FindFood(npcSurvivor);
			end
			npcSurvivor.foodTicks = 0;
		else
			if(npcSurvivor.GettingWater == false) then
				npcSurvivor.isDoingTask = false;
			end
			npcSurvivor.GettingFood = false;
		end
	end	
end
--Water

function PZNS_NPCFoodNeeds.PZNS_FindWater(npcSurvivor)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject
    --local inv = npcIsoPlayer:getInventory()
    local CurrentBuilding = npcIsoPlayer:getCurrentBuilding()
    
    if not CurrentBuilding then
        return
    end

    local bdef = CurrentBuilding:getDef();
    local rooms = bdef:getRooms();
	local Containers = {};

    if not (rooms or rooms:size() == 0) then
        return
    end

    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i):getIsoRoom()      
        if (room) then
            local Container = room:getSquares();        
            if (Container or Container:size() == 0) then
                for j = 0, Container:size() - 1 do
                    local con = Container:get(j):getObjects();
					for ji = 0, con:size() - 1 do
						local object = con:get(ji);
						if (object:hasWater() and object:getWaterAmount() > 0) then
							table.insert(Containers, object)
						end	
					end
                end
            end
        end
    end

    if (#Containers > 0) then
		--local items = inv:getItems();
		--local Bottles = {};
		--if (items) then
		--	for i = 1, items:size() - 1 do
		--		local item = items:get(i);
		--		if (item:canStoreWater()) then
		--			table.insert(Bottles, item);	
		--		end
		--	end
		--end	
		
        for _, value in pairs(Containers) do  

			 local targetSquare = getCell():getGridSquare(value:getX(), value:getY(), value:getZ());
				local distanceFromContainer = PZNS_WorldUtils.PZNS_GetDistanceBetweenTwoObjects(npcIsoPlayer, targetSquare);
                local squareX, squareY, squareZ = value:getX(), value:getY(), value:getZ();
				if (distanceFromContainer <= 1) then
					PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor);
					npcSurvivor.isDoingTask = true;
                    local LootAction = ISTakeWaterAction:new(npcIsoPlayer, nil, 5, value, 120)
					npcSurvivor.jobSquare = nil;	
                    PZNS_UtilsNPCs.PZNS_AddNPCActionToQueue(npcSurvivor, LootAction);
					print("drink")
					return;
                else
					PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor);
					npcSurvivor.isDoingTask = true;
                    npcSurvivor.jobSquare = nil;	
                    npcSurvivor.currentAction = "Walking";
                    PZNS_WalkToSquareXYZ(npcSurvivor, squareX, squareY, squareZ);
					print("walk")
					return;
                end			
        end
	else
		npcSurvivor.isDoingTask = false;
    end
end

function PZNS_NPCFoodNeeds.PZNS_GetWaterItem(npcIsoPlayer) --Made by okkg
    local inv = npcIsoPlayer:getInventory()
    local FoodList = {};
    local items = inv:getItems();

    if (items) then
        for i = 1, items:size() - 1 do
            local item = items:get(i);
			local success, category = pcall(function() return item:getDisplayCategory() end);			
            if success and category and string.match(category, "Drainable") and item:canStoreWater() then
				table.insert(FoodList, item);	
			elseif item:canStoreWater() then
				table.insert(FoodList, item);	
            end
        end
    end
	return FoodList;
end

function PZNS_NPCFoodNeeds.PZNS_HandleWaterForAllNpcs(npcSurvivor)
	if (PZNS_GeneralAI.PZNS_IsNPCBusyCombat(npcSurvivor) == true or npcSurvivor.GettingFood == true and npcSurvivor.GettingWater == false) then
		npcSurvivor.waterTicks = 0;
		npcSurvivor.GettingWater = false;
	else
		local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;	
		if (npcIsoPlayer and npcIsoPlayer:getStats():getThirst() >= 0.50) then 
			local WaterItems = PZNS_NPCFoodNeeds.PZNS_GetWaterItem(npcIsoPlayer);
							
			if (#WaterItems == 0) then
				PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor);
				PZNS_NPCFoodNeeds.PZNS_FindWater(npcSurvivor);
			else
				npcSurvivor.isDoingTask = true;
				local WaterToDrink = WaterItems[ZombRand(1, #WaterItems)];
				local drinkAction = ISDrinkFromBottle:new(npcIsoPlayer, WaterToDrink, 1);
				PZNS_UtilsNPCs.PZNS_AddNPCActionToQueue(npcSurvivor, drinkAction);	
			end						
			npcSurvivor.waterTicks = 0;
			npcSurvivor.GettingWater = true;
		else
			npcSurvivor.GettingWater = false;
		end
	end	
end

local function checkIsFrameWorkIsInstalled()
    local activatedMods = getActivatedMods();
    if (activatedMods:contains(frameworkID)) then
        isFrameWorkIsInstalled = true;
    else
        local function callback()
            getSpecificPlayer(0):Say("!!! PZNS_Framework IS NOT INSTALLED !!!");
        end
        Events.EveryOneMinute.Add(callback); 
    end
    return isFrameWorkIsInstalled;
end

--if checkIsFrameWorkIsInstalled() == true then
	--if SandboxVars.PZNS_Framework.IsNPCsNeedsActive == true then
		--Events.OnRenderTick.Add(PZNS_NPCFoodNeeds.PZNS_HandleFoodForAllNpcs);
		--Events.OnRenderTick.Add(PZNS_NPCFoodNeeds.PZNS_HandleWaterForAllNpcs);
		--print("added")
	--end
--end	

return PZNS_NPCFoodNeeds;