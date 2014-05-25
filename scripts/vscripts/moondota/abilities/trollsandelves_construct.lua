ConstructDef = class(abilityclasstable, {}, MoonAbility)

function ConstructDef:WrapRules(varname, ent)
	if varname == "caster" then return "Builder" end
	if varname == "target_entities" then return "Building" end
	return ""
end 

--callbacks take a table filled with wrapped objects
function ConstructDef:OnSpellStart(chest)
	local builder = chest.caster 

	local buildingent = CreateUnitByName("trollsandelves_building_inprogress", chest.target_points[1], false, nil, nil, builder.Ent:GetTeamNumber())
	local building = MData:For("Building", buildingent)

	builder.MostRecent = building
	builder.Buildings[buildingent] = building

	FireGameEvent("trollsandelves_started_building", {time_remaining = building.Time, pid = builder.Ent:GetPlayerOwner():GetPlayerID()})
end

function ConstructDef:OnSpellStart_Resume(chest)
	local building = MData:For("Building", chest.target_entities[1])
	local builder = chest.caster

	if building then
		builder.MostRecent = building
		FireGameEvent("trollsandelves_started_building", {time_remaining = building.Time, pid = builder.Ent:GetPlayerOwner():GetPlayerID()})
	else
		caster:RemoveModifierByName("construct_building_think") 
		chest.ability:EndChannel(false)
	end
end

function ConstructDef:OnChannelInterrupted(chest)
	local unit = chest.caster
	FireGameEvent("trollsandelves_stopped_building", {pid = unit.Ent:GetPlayerOwner():GetPlayerID()})
end

function ConstructDef:OnIntervalThink_modifier_trollsandelves_construct_think(chest)
	local builder = chest.caster
	local building = builder.MostRecent

	building.TimeSpent = building.TimeSpent + 0.1

	if building.TimeSpent >= building.Time then 
		chest.ability:EndChannel(false) 
		CreateUnitByName( "npc_trollsandelves_building_hall_1", building.Ent:GetOrigin(), false, nil, nil, builder.Ent:GetTeamNumber() )
		UTIL_RemoveImmediate(building.Ent)
		builder.Ent:RemoveModifierByName("modifier_trollsandelves_construct_think") --EndChannel doesn't call the datadriven OnChannelInterrupted, so the RemoveModifier out there doesn't call
	end
end

Construct = ConstructDef()