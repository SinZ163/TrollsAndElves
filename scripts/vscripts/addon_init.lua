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
require("moondota/moondota")
require("lumber_store")

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



Convars:RegisterCommand("makedummy", function(args)
        local firework = CreateUnitByName( "npc_tree_dummy", Convars:GetCommandClient():GetAssignedHero():GetOrigin(), false, nil, nil, 4 )
        FindClearSpaceForUnit(firework, Convars:GetCommandClient():GetAssignedHero():GetOrigin(), false)
        end, "Fuck", 0)

Convars:RegisterCommand("sww", function(args, arg2, arg3)
        local hero = Convars:GetCommandClient():GetAssignedHero()
    --    SendToServerConsole("sm_changeteam " .. hero .. " " .. 7)
        hero:SetTeam(7)
        end, "Fuck", 0)

Convars:RegisterCommand("th", function(args)
    for i = 1, 200, 1 do 
        SendToServerConsole("hooktree " .. i)
    end
        end, "Fuck", 0)

Convars:RegisterCommand("quell", function(args)
    local h = Convars:GetCommandClient():GetAssignedHero()
        local firework = CreateItem("item_quelling_blade", h, h)
        h:AddItem(firework)
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

print("dummies.." .. #Entities:FindAllByName("npc_tree_dummy"))

Convars:RegisterCommand("trees", function(args)
        for k,v in pairs(Entities:FindAllByClassname("ent_dota_tree")) do 
    local u = CreateUnitByName( "npc_tree_dummy", v:GetOrigin(), false, nil, nil, 4)
    u:SetOrigin(v:GetOrigin())
    u:AddNewModifier(v, nil, "modifier_phased", {duration = -1}) 
end
        end, "Fuck", 0)

Convars:RegisterCommand("ttt", function(args)
    Convars:GetCommandClient():GetAssignedHero():FindAbilityByName("wisp_relocate"):OnSpellStart()
        end, "Fuck", 0)

Convars:RegisterCommand("treet22", function(args)
     local firework = SpawnEntityFromTableSynchronous("ent_dota_tree", {body = 1, base = 1, model = "models/props_foliage/tree_pine02.mdl", name = "dota_item_rune_spawner"})
        FindClearSpaceForUnit(firework, Convars:GetCommandClient():GetAssignedHero():GetOrigin(), false)
        end, "Fuck", 0)

