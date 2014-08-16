AbilityInstance = Construct

function OnSpellStart(keys)
	local builder = keys.caster 
    
	local intent = builder:GetPlayerOwner().WantsToBuild
	print(intent)
	if not intent then
		print("New elf!") --need to redo initialization stuff lost in rewrite
		intent = "npc_trollsandelves_rock_1"
	end
	local building = CreateUnitByName(intent, keys.target_points[1], false, nil, nil, builder:GetTeamNumber())
    
	building.Type = intent
	building.PlayerOwner = builder:GetPlayerOwner()
	building:ModifyHealth(1, nil, true, 0)

    local blockInfo = {
				alignment_grid_size=2, --This building is 2x2 on the gridnav
				squares_per_side=1, 
				building_size=128
    }
    building:AddNewModifier(builder, nil, "modifier_place_building_path_blocker", blockInfo)
    
	print("Building " .. intent)

	if not builder.Buildings then builder.Buildings = {} end --need to move custom field initialization out of these files and someplace central and descriptive

	builder.MostRecent = building
	builder.Buildings[building] = building

	FireGameEvent("trollsandelves_started_building", {time_remaining = 10, pid = builder:GetPlayerOwner():GetPlayerID()}) --do something with time_remaining?
end

function OnSpellStart_Resume(keys)
	local building = keys.target_entities[1]
	local builder = keys.caster

	if building then
		builder.MostRecent = building
		FireGameEvent("trollsandelves_started_building", {time_remaining = 10, pid = builder:GetPlayerOwner():GetPlayerID()})
	else
		caster:RemoveModifierByName("construct_building_think") 
		keys.ability:EndChannel(false)
	end
end

function OnChannelInterrupted(keys) 
	local unit = keys.caster
	FireGameEvent("trollsandelves_stopped_building", {pid = unit:GetPlayerOwner():GetPlayerID()})
	unit:RemoveModifierByName("modifier_trollsandelves_construct_think")
end

function OnIntervalThink_modifier_trollsandelves_construct_think(keys)
	local builder = keys.caster
	local playerowner = builder:GetPlayerOwner()
	local building = builder.MostRecent
	local maxhealth = building:GetMaxHealth()
	local pct = .1 * maxhealth --wire pct up to actual values?
	print(pct)

	building:Heal(pct, nil)

	if building:GetHealthDeficit() == 0 then 
		keys.ability:EndChannel(false) 

		if building.Finished == false then 
			building.Finished = true
			building:SetControllableByPlayer(playerowner:GetPlayerID(), true)
		end
		FireGameEvent("trollsandelves_stopped_building", {pid = playerowner:GetPlayerID()})
		print(building.Type)
		TrollsAndElvesGameMode:TechAdvance(playerowner, building.Type)
		builder:RemoveModifierByName("modifier_trollsandelves_construct_think") --EndChannel doesn't call the datadriven OnChannelInterrupted, so the RemoveModifier out there doesn't call
	end
end