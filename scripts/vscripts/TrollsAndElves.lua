-- Reload support apparently
if FrotaGameMode == nil then
    FrotaGameMode = {}
    FrotaGameMode.szEntityClassName = "TrollsAndElves"
    FrotaGameMode.szNativeClassName = "dota_base_game_mode"
    FrotaGameMode.__index = FrotaGameMode
end

function FrotaGameMode:InitGameMode()
end
EntityFramework:RegisterScriptClass( TrollsAndElvesGameMode )