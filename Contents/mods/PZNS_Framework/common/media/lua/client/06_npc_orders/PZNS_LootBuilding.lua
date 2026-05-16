local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");

---Cows: npcSurvivor needs to move to square then pick up the deadBody.
---@param npcSurvivor any
---@param square IsoGridSquare
---@param deadBody IsoDeadBody
function PZNS_LootBuilding(npcSurvivor)
    if (PZNS_UtilsNPCs.IsNPCSurvivorIsoPlayerValid(npcSurvivor) == false) then
        return;
    end
    --
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    local building = npcIsoPlayer:getCurrentBuilding();
    
	
	
    npcSurvivor.currentAction = "Walking";
    PZNS_WalkToSquareXYZ(npcSurvivor, squareX, squareY, squareZ);
end
