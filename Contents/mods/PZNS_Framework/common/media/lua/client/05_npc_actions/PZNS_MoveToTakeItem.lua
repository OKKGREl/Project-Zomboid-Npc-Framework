local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");

---Okkg: npcSurvivor moves to square then takes the specified item
---@param npcSurvivor any
---@param foodItem InventoryItem
---@param container IsoContainer
---@param containerSquare IsoGridSquare
function PZNS_MoveToTakeItem(npcSurvivor, foodItem, container, containerSquare)
   
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    local distanceFromContainer = PZNS_WorldUtils.PZNS_GetDistanceBetweenTwoObjects(npcIsoPlayer, containerSquare);
    
    if (distanceFromContainer <= 1) then
        local inv = npcIsoPlayer:getInventory();
        local LootAction = ISInventoryTransferAction:new(npcIsoPlayer, foodItem, container, inv, 120);
        PZNS_UtilsNPCs.PZNS_AddNPCActionToQueue(npcSurvivor, LootAction);
    else
        local squareX, squareY, squareZ = containerSquare:getX(), containerSquare:getY(), containerSquare:getZ();
        PZNS_WalkToSquareXYZ(npcSurvivor, squareX, squareY, squareZ);
    end
end
