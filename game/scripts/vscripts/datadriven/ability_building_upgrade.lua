--this is simple enough

function OnSpellStart(keys)
	local oldbuilding = keys.caster
	local playerowner = oldbuilding.PlayerOwner
	local playerid = playerowner:GetPlayerID()
	local unitname = oldbuilding:GetUnitName()
	local nextbuilding = UnitsCustomKV[unitname].NextUpgrade
	local nextdata = UnitsCustomKV[nextbuilding]
	local req = nextdata.Requisite
	local lumbercost = nextdata.LumberCost or 0
	local currentgold = PlayerResource:GetGold(playerid)
	local currentlumber = playerowner.LumberTotal
	local goldcost = nextdata.GoldCost or 0
	if nextbuilding ~= "None" then
        if playerowner.TechBuildings[req] == true then
            if currentgold >= goldcost then
                if currentlumber >= lumbercost then
                    currentlumber = currentlumber - lumbercost
                    PlayerResource:ModifyGold(playerid, -goldcost, true, 0)
                    local newbuilding = CreateUnitByName(nextbuilding, oldbuilding:GetOrigin(), false, nil, nil, oldbuilding:GetTeamNumber()) --also set health or something
                    newbuilding:SetControllableByPlayer(playerid, true)
                    newbuilding.Type = newbuilding:GetUnitName()
                    newbuilding.PlayerOwner = playerowner 
                    newbuilding.MaxHealth = nextdata.StatusHealth
                    newbuilding.CurrentHealth = newbuilding.StatusHealth
                    UTIL_RemoveImmediate(oldbuilding)
                else
                    ShowGenericPopupToPlayer(playerowner, "#trollsandelves_error_upgrade", "#trollsandelves_error_lumber", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN)
                end
            else
                ShowGenericPopupToPlayer(playerowner, "#trollsandelves_error_upgrade", "#trollsandelves_error_gold", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN)
            end
        else
            ShowGenericPopupToPlayer(playerowner, "#trollsandelves_error_upgrade", "#trollsandelves_error_missing-tech", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN)
        end
    else
        ShowGenericPopupToPlayer(playerowner, "#trollsandelves_error_upgrade", "#trollsandelves_error_upgrade_none", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN)
	end
	--todo:presentation, channel?
end