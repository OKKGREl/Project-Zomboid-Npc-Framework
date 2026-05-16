local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");

---comment
---@param npcSurvivor any
---@param targetItem any
function PZNS_EatFood(npcSurvivor, targetItem)
    if (PZNS_UtilsNPCs.IsNPCSurvivorIsoPlayerValid(npcSurvivor) == false) then
        return;
    end
    --
    if (targetItem == nil) then
        return;
    end
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    local eatAction = ISEatFoodAction:new(npcIsoPlayer, targetItem, 1);
    PZNS_UtilsNPCs.PZNS_AddNPCActionToQueue(npcSurvivor, eatAction);
end
