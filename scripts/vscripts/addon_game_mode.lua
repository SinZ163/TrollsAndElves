print("Hello, my name is addon_game_mode, and I am a gamemode 15 initializer")
function Precache( context )
    PrecacheUnitByNameSync("npc_trollsandelves_rock_1", context)
end
function Activate()
    GameRules.TrollsAndElves = TrollsAndElvesGameMode:new()
    GameRules.TrollsAndElves.InitGameMode()
end