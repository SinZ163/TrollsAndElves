Constructions = {}
Constructions.AllBuildings = {}
Constructions.BuildingsFor = {}

function ConstructionInfo(building)
	return {
		Time = 5,
		TimeSpent = 0,
		Ent = building
	}
end

function OnSpellStart(keys)
	local caster = keys.caster 
	local buildingsfor = Constructions.BuildingsFor[caster]
	if not buildingsfor then 
		Constructions.BuildingsFor[caster] = {}
		buildingsfor = Constructions.BuildingsFor[caster] --is this necessary?
	end
	local construction = CreateUnitByName( "trollsandelves_building_inprogress", keys.target_points[1], false, nil, nil, caster:GetTeamNumber() )
	local info = ConstructionInfo(construction)
	buildingsfor.MostRecent = info
	buildingsfor.MyBuildings = {}
	buildingsfor.MyBuildings[construction] = info
	Constructions.AllBuildings[construction] = info
	caster:AddNewModifier(caster, nil, "construct_building_think", {})
	FireGameEvent("trollsandelves_started_building", {time_remaining = info.Time, pid = caster:GetPlayerOwner():GetPlayerID()})
end

function OnSpellStart_Resume(keys)
	local ent = keys.target_entities[1]
	local caster = keys.caster

	local buildinginfo = Constructions.AllBuildings[ent]
	if buildinginfo then
		local buildingsfor = Constructions.BuildingsFor[caster]
		if not buildingsfor then 
			Constructions.BuildingsFor[caster] = {}
			buildingsfor = Constructions.BuildingsFor[caster] --is this necessary?
		end
		local buildinginfo = Constructions.AllBuildings[ent]
		buildingsfor.MostRecent = buildinginfo
		FireGameEvent("trollsandelves_started_building", {time_remaining = buildinginfo.Time, pid = caster:GetPlayerOwner():GetPlayerID()})
	else
		caster:RemoveModifierByName("construct_building_think") 
		keys.ability:EndChannel(false)
	end
end

function OnChannelInterrupted(keys) 
	local unit = keys.unit
	print("Interrupted.." .. unit:GetClassname())
	FireGameEvent("trollsandelves_stopped_building", {pid = unit:GetPlayerOwner():GetPlayerID()})
end

function OnIntervalThink(keys)
	local builder = keys.caster
	local construction = Constructions.BuildingsFor[builder].MostRecent

	construction.TimeSpent = construction.TimeSpent + 0.1
	if construction.TimeSpent >= construction.Time then 
		keys.ability:EndChannel(false) 
		CreateUnitByName( "npc_trollsandelves_building_hall_1", construction.Ent:GetOrigin(), false, nil, nil, builder:GetTeamNumber() )
		UTIL_RemoveImmediate(construction.Ent)
		builder:RemoveModifierByName("construct_building_think") --EndChannel doesn't call the datadriven OnChannelInterrupted, so the RemoveModifier out there doesn't call
	end
end


