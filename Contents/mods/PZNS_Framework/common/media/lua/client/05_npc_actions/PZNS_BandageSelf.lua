local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");

---@param npcSurvivor any
---@param bandageItem IsoObject
---@param wound any
function PZNS_BandageSelf(npcSurvivor, bandageItem, wound)
    if (PZNS_UtilsNPCs.IsNPCSurvivorIsoPlayerValid(npcSurvivor) == false) then
        return;
    end
	local actions = PZNS_UtilsNPCs.PZNS_GetNPCActionsQueue(npcSurvivor);
	if actions then
		for _, i in pairs(actions) do
			if i.Type == "ISApplyBandage" then
				return
			end	
		end
	end
	
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    local bandageAction = ISApplyBandage:new(npcIsoPlayer, npcIsoPlayer, bandageItem, wound, true);
	PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor);
	npcSurvivor.jobSquare = nil;
    PZNS_UtilsNPCs.PZNS_AddNPCActionToQueue(npcSurvivor, bandageAction);
end
