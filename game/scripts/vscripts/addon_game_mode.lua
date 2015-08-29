print("Hello, my name is addon_game_mode, and I am a gamemode 15 initializer")
function Precache( context )
    PrecacheUnitByNameSync("npc_trollsandelves_rock_1", context)
    PrecacheUnitByNameSync("npc_dota_creature_creep_melee", context)
    PrecacheUnitByNameSync("npc_dota_goodguys_tower1_top", context)
    PrecacheUnitByNameSync("npc_dota_hero_wisp", context)
    
    PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", context) -- Troll reveal
end
function Activate()
    GameRules.TrollsAndElves = TrollsAndElvesGameMode:new()
    GameRules.TrollsAndElves.InitGameMode()
    GameRules.ID_TO_HERO = {}
end