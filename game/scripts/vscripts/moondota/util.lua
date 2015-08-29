MUtil = {}

function MUtil:TableHasValue(table, value)
	for _,v in pairs(table) do
		if v == value then return true end
	end
	return false
end

function MUtil:FindByUnitNameNearest(name, point, radius)
    local loop = Entities:FindAllInSphere(point, radius)
    for _,v in pairs(loop) do 
        if v.GetUnitName and v:GetUnitName() == name then return v end
    end
end

function MUtil:FindByUnitName(iter, name)
    local ent = Entities:First() --but what if worldspawn
    while ent do 
        ent = Entities:Next(ent)
        if ent.GetUnitName and ent:GetUnitName() == name then return ent end
    end
    return nil
end

function MUtil:LoopOverPlayers(callback)
    for k, v in pairs(Entities:FindAllByClassname("player")) do
        -- Validate the player
        if IsValidEntity(v) then
            -- Run the callback
            if callback(v, v:GetPlayerID()) then
                break
            end
        end
    end
end

function MUtil:IsValidPlayerID(checkPlayerID)
    local isValid = false
    self:LoopOverPlayers(function(ply, playerID)
        if playerID == checkPlayerID then
            isValid = true
            return true
        end
    end)

    return isValid
end

function MUtil:GetPlayerList()
    local plyList = {}

    self:LoopOverPlayers(function(ply, playerID)
        table.insert(plyList, ply)
    end)

    return plyList
end

-- Auto assigns a player when they connect
function MUtil:AutoAssignPlayer(ply)
    -- Grab the entity index of this player

    -- Find the team with the least players
    local teamSize = {
        [DOTA_TEAM_GOODGUYS] = 0,
        [DOTA_TEAM_BADGUYS] = 0
    }

    self:LoopOverPlayers(function(ply, playerID)
        -- Grab the players team
        local team = ply:GetTeam()

        -- Increase the number of players on this player's team
        teamSize[team] = (teamSize[team] or 0) + 1
    end)

    if teamSize[DOTA_TEAM_GOODGUYS] > teamSize[DOTA_TEAM_BADGUYS] then
        ply:SetTeam(DOTA_TEAM_BADGUYS)
        ply:__KeyValueFromInt('teamnumber', DOTA_TEAM_BADGUYS)
    else
        ply:SetTeam(DOTA_TEAM_GOODGUYS)
        ply:__KeyValueFromInt('teamnumber', DOTA_TEAM_GOODGUYS)
    end

    local playerID = ply:GetPlayerID()
    local hero = ply:GetAssignedHero()
    if IsValidEntity(hero) then
        hero:Remove()
    end
end

function MUtil:LastIndexOf(str, sym)
    return string.find(s, string.format("%s[^%s]*$", sym, sym))
end