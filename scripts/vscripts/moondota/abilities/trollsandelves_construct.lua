ConstructDef = class(abilityclasstable, {}, MoonAbility)

function ConstructDef:WrapRules(varname, ent)
	if varname == "caster" then return "Builder" end
	if varname == "target_entities" then return "Building" end
	return ""
end 

--callbacks take a table filled with wrapped objects
function ConstructDef:OnSpellStart(chest)
	local builder = chest.caster 
    
	local intent = MData:For("PlayerIntent", builder.Ent:GetPlayerOwner())
	local buildingent = CreateUnitByName(intent.WantsToBuild, chest.target_points[1], false, nil, nil, builder.Ent:GetTeamNumber())
    
	local building = MData:For("Building", buildingent)
	building.Type = intent.WantsToBuild
	building.PlayerOwner = builder.Ent:GetPlayerOwner()
	buildingent:ModifyHealth(1, nil, true, 0)
    print("test");print("test2");
    local blockInfo = {
				alignment_grid_size=2, --This building is 2x2 on the gridnav
				squares_per_side=1, 
				building_size=128
    }
    buildingent:AddNewModifier(builder, nil, "modifier_place_building_path_blocker", blockInfo)
    
	print("Building " .. intent.WantsToBuild)

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
	unit.Ent:RemoveModifierByName("modifier_trollsandelves_construct_think")
end

function ConstructDef:OnIntervalThink_modifier_trollsandelves_construct_think(chest)
	local builder = chest.caster
	local playerowner = builder.Ent:GetPlayerOwner()
	local building = builder.MostRecent
	local maxhealth = building.Ent:GetMaxHealth()
	local pct = builder.HealthPercentPerTick * maxhealth
	print(pct)

	building.Ent:Heal(pct, nil)

	if building.Ent:GetHealthDeficit() == 0 then 
		chest.ability:EndChannel(false) 

		if building.Finished == false then 
			building.Finished = true
			building.Ent:SetControllableByPlayer(playerowner:GetPlayerID(), true)
		end
		FireGameEvent("trollsandelves_stopped_building", {pid = playerowner:GetPlayerID()})
		print(building.Type)
		TrollsAndElvesGameMode:TechAdvance(playerowner, building.Type)
		builder.Ent:RemoveModifierByName("modifier_trollsandelves_construct_think") --EndChannel doesn't call the datadriven OnChannelInterrupted, so the RemoveModifier out there doesn't call
	end
end

Construct = ConstructDef()