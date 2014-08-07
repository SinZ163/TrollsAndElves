TechBuilding = {
	npc_trollsandelves_rock_1 = true
}


if TrollsAndElvesGameMode == nil then
    TrollsAndElvesGameMode = {}
    TrollsAndElvesGameMode.__index = TrollsAndElvesGameMode
end

function TrollsAndElvesGameMode:new (o)
    o = o or {}
    setmetatable(o, self)
    TROLLSANDELVES_REFERENCE = o
    return o
end

function TrollsAndElvesGameMode:TechAdvance(player, building)
	print("Upgrading " .. building)
	local tech = MData:For("PlayerTech", player)
	tech.TechBuildings[building] = true
	if building == "npc_trollsandelves_rock_1" then player:GetAssignedHero():FindAbilityByName("trollsandelves_build_menu"):SetHidden(false) end
end

function TrollsAndElvesGameMode:InitGameMode()

	Msg("Hello World, My name is TrollsAndElves!")
	
	--CEntities:FindByClassname(nil, "dota_base_game_mode"):SetFogOfWarDisabled(true)
	
    --Event registration --
	ListenToGameEvent('player_chat', Dynamic_Wrap(TrollsAndElvesGameMode,"onChatMessage"), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(TrollsAndElvesGameMode,"onPlayerConnect"), self)
	ListenToGameEvent("dota_item_purchased", Dynamic_Wrap(TrollsAndElvesGameMode, "OnItemPurchased"), self)
    
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(TrollsAndElvesGameMode, "onNPCSpawned"), self)
	-- Start thinkers
    --self._scriptBind:BeginThink('TrollsAndElvesThink', Dynamic_Wrap(TrollsAndElvesGameMode, 'Think'), 0.1)
end

function TrollsAndElvesGameMode:onNPCSpawned(keys)
    local spawnedUnit = EntIndexToHScript(self.entindex)
    if spawnedUnit:GetClassname() == "npc_dota_hero_troll_warlord" or spawnedUnit:GetClassname() == "npc_dota_hero_lycan" then
        print("Troll detected!")
        local ability_1 = spawnedUnit:FindAbilityByName("trollsandelves_troll_invis")
        local ability_2 = spawnedUnit:FindAbilityByName("trollsandelves_troll_pillage")
        
        ability_1:SetLevel(1)
        ability_2:SetLevel(1)
    end
end

function TrollsAndElvesGameMode:TrollBuyItem(player, item)

	local lumber = MData:For("PlayerLumber", player)
	local itemdata = ItemsCustomKV[item]
	local playergold = PlayerResource:GetGold(player:GetPlayerID())
	local lumbercost = itemdata.LumberCost or 0
	local itemcost = itemdata.ItemCost or 0
	local playerid = player:GetPlayerID()
	local hero = player:GetAssignedHero()

	print(itemdata)
	print(playergold)
	print(lumber.Total)
	print(itemdata.LumberCost)
	print(itemdata.ItemCost)

	if lumber.Total >= lumbercost and playergold >= itemcost then 
		PlayerResource:ModifyGold(playerid, -itemcost, false, 0)
		lumber.Total = lumber.Total - lumbercost
		FireGameEvent("trollsandelves_lumber", {pid=playerid, lumber=lumber.Total})
		local item = CreateItem( item, hero, hero )
		hero:AddItem(item)
	else --ERROR PLEASE
	end
end

function TrollsAndElvesGameMode:onChatMessage(keys)

end

local treesinit = false
function TrollsAndElvesGameMode:onPlayerConnect(keys)
	if treesinit == false then 
		for k,v in pairs(Entities:FindAllByClassname("ent_dota_tree")) do 
		    local u = CreateUnitByName( "npc_tree_dummy", Vector(0,0,0), true, nil, nil, 2)
		    u:SetOrigin(v:GetOrigin())
		    u:AddNewModifier(v, nil, "modifier_phased", {duration = -1}) 
		end
		treesinit = true
	end

	player = EntIndexToHScript(self.index + 1)

	FireGameEvent("tae_new_troll",{pid=player:GetPlayerID()})

	player:SetTeam(DOTA_TEAM_GOODGUYS)
end

function TrollsAndElvesGameMode:ModifyLumber(player, sum) --negative to reduce
	local lumber = MData:For("PlayerLumber", player)
	if sum > lumber.Amount then 
		lumber.Amount = lumber.Amount + sum
		return true
	else return false
	end
end

function TrollsAndElvesGameMode:OnItemPurchased(keys)
	local item = ItemsCustomKV[item]
	local player = EntIndexToHScript(PlayerResource:GetPlayer(keys.PlayerID))
	if item.LumberCost and item.LumberCost > 0 then self:ModifyLumber(player, item.LumberCost) end
end

--TODO: actually get this thing online
function TrollsAndElvesGameMode:Think()
    -- Track game time, since the dt passed in to think is actually wall-clock time not simulation time.
    local now = GameRules:GetGameTime()
    if self.t0 == nil then
        self.t0 = now
    end
    local dt = now - self.t0
    self.t0 = now
end

function TrollsAndElvesGameMode.PlayerWantsToBuild(cmdname, building) --maybe add some stuff to do stuff here
	print(building)
	local player = Convars:GetCommandClient()
	player:GetAssignedHero():FindAbilityByName("trollsandelves_construct_building"):SetHidden(false)
	local intent = MData:For("PlayerIntent", player)
	if UnitsCustomKV[building] then
        intent.WantsToBuild = building
    else
        print("This doesn't seem right")
        FireGameEvent("dota_hud_error_message", {reason=0,message="Hello World!"})
    end
end

function TrollsAndElvesGameMode.BuildingQueueUnit(cmdname, building, unit)
	local unitdata = UnitsCustomKV[unit]
	local lumbercost = unitdata.LumberCost
	local goldcost = unitdata.GoldCost
	local playerowner = Convars:GetCommandClient()
	local playerlumber = MData:For("PlayerLumber", playerowner)
	local currentlumber = playerlumber.Total
	local currentgold = PlayerResource:GetGold(playerowner:GetPlayerID())
	local team = playerowner:GetTeam()

	--findclearspace won't work, need to generate an emission point when the building is created
	if currentlumber >= lumbercost and currentgold >= goldcost then 
		playerowner:ModifyGold(-goldcost, true, 0)	
		playerlumber.Total = currentlumber - lumbercost
		local unit = CreateUnitByName(unit, Vector(0,0,0), true, nil, nil, keys.caster:GetTeamNumber())
		FindClearSpaceForUnit(unit, keys.caster:GetOrigin(), true)
	end
end

function TrollsAndElvesGameMode.UnitSelected(keys)
	
end

Convars:RegisterCommand("tae_building_queue_unit", TrollsAndElvesGameMode.BuildingQueueUnit, "Build thing", 0)
Convars:RegisterCommand("tae_wants_to_build", TrollsAndElvesGameMode.PlayerWantsToBuild, "Build thing", 0)