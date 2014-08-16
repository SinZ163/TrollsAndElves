print('\n\nLoading TrollsAndElves modules...')

--[[function Dynamic_Wrap( mt, name )
    if Convars:GetFloat( 'developer' ) == 1 then
        local function w(...) return mt[name](...) end
		return w
    else
        return mt[name]
    end
end]]--

-- Module loading system (it reports errors)
local totalErrors = 0
local function loadModule(name)
    local status, err = pcall(function()
        -- Load the module
        require(name)
    end)

    if not status then
        -- Add to the total errors
        totalErrors = totalErrors+1

        -- Tell the user about it
        print('WARNING: '..name..' failed to load!')
        print(err)
    end
end

-- Load Frota
loadModule('lib.json')         -- Json Library
loadModule('TrollsAndElves')        -- Main program
loadModule('entity_init')
require("moondota/moondota")

if totalErrors == 0 then
    -- No loading issues
    print('Loaded TrollsAndElves modules successfully!\n')
elseif totalErrors == 1 then
    -- One loading error
    print('1 TrollsAndElves module failed to load!\n')
else
    -- More than one loading error
    print(totalErrors..' TrollsAndElves modules failed to load!\n')
end

Convars:RegisterCommand("makeuni", function(cmdname, name, team)
    local me = Convars:GetCommandClient():GetAssignedHero()
    local unit = CreateUnitByName(name, me:GetOrigin(), true, nil, nil, tonumber(team))
    FindClearSpaceForUnit(unit, me:GetOrigin(), true)
end, "Fuck", 0)

Convars:RegisterCommand("creep", function(args)
    local h = Convars:GetCommandClient():GetAssignedHero()
        CreateUnitByName("npc_dota_creature_creep_melee", h:GetOrigin(), true, nil, nil, 2)
        end, "Fuck", 0)

Convars:RegisterCommand("tower", function(args)
    local h = Convars:GetCommandClient():GetAssignedHero()
        CreateUnitByName("npc_dota_goodguys_tower1_top", h:GetOrigin(), true, nil, nil, 2)
        end, "Fuck", 0)

Convars:RegisterCommand("quell", function(args)
    local h = Convars:GetCommandClient():GetAssignedHero()
        local firework = CreateItem("item_quelling_blade", h, h)
        h:AddItem(firework)
        end, "Fuck", 0)

Convars:RegisterCommand("nametest2", function(args)
    local h = Convars:GetCommandClient():GetAssignedHero()
        print(h:GetUnitName())
        end, "Fuck", 0)

Convars:RegisterCommand("showitemtest", function(args)
    print("FIRING")
    FireGameEvent("tae_new_troll", {pid=Convars:GetCommandClient():GetPlayerID()})
        end, "Fuck", 0)

Convars:RegisterCommand("showbuildtest", function(args)
    print("FIRING")
    FireGameEvent("tae_new_elf", {pid=Convars:GetCommandClient():GetPlayerID()})
        end, "Fuck", 0)

Convars:RegisterCommand("invo2", function(args)
    local h = Convars:GetCommandClient():GetAssignedHero()
        local firework = CreateHeroForPlayer( "npc_dota_hero_wisp", Convars:GetCommandClient())
        FindClearSpaceForUnit(firework, h, false)
        end, "Fuck", 0)

Convars:RegisterCommand("invo3", function(args)
    local h = Convars:GetCommandClient():GetAssignedHero()
        local firework = CreateHeroForPlayer( "npc_dota_hero_invoker", Convars:GetCommandClient())
        FindClearSpaceForUnit(firework, h, false)
        end, "Fuck", 0)

Convars:RegisterCommand("tae_buy_item", function(cmdname, item)
    local player = Convars:GetCommandClient()
    if player:GetAssignedHero():GetClassname() == "npc_dota_hero_troll_warlord" then 
        TrollsAndElvesGameMode:TrollBuyItem(player, item)
    end
        end, "Fuck", 0)

UnitsCustomKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
ItemsCustomKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")