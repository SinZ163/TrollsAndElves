--this is simple enough

function OnSpellStart(keys)
	local caster = keys.caster
	local building = MData:For("Building", caster)
	local playerowner = building.PlayerOwner
	local playerid = playerowner:GetPlayerID()
	local unitname = caster:GetUnitName()
	local nextbuilding = UnitsCustomKV[unitname].NextUpgrade
	local nextdata = UnitsCustomKV[nextbuilding]
	local req = nextdata.Requisite
	local lumbercost = nextdata.LumberCost or 0
	local currentgold = PlayerResource:GetGold(playerid)
	local currentlumber = MData:For("PlayerLumber",playerowner).Total
	local goldcost = nextdata.GoldCost or 0

	if nextbuilding ~= "None" and MData:For("PlayerTech", playerowner).TechBuildings[req] == true and currentgold >= goldcost and currentlumber >= lumbercost then
		currentlumber = currentlumber - lumbercost
		PlayerResource:ModifyGold(playerid, -goldcost, true, 0)
		local unit = CreateUnitByName(nextbuilding, caster:GetOrigin(), false, nil, nil, caster:GetTeamNumber()) --also set health or something
		unit:SetControllableByPlayer(playerid, true)
		local building = MData:For("Building", unit)
		building.Type = unit:GetUnitName()
		building.PlayerOwner = playerowner 
		building.MaxHealth = nextdata.StatusHealth
		building.CurrentHealth = building.StatusHealth
		UTIL_RemoveImmediate(caster)
	end

	--todo:presentation, channel?
end