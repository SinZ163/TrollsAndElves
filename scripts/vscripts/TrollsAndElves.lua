-- Reload support apparently
if TrollsAndElvesGameMode == nil then
    TrollsAndElvesGameMode = {}
    TrollsAndElvesGameMode.szEntityClassName = "TrollsAndElves"
    TrollsAndElvesGameMode.szNativeClassName = "dota_base_game_mode"
    TrollsAndElvesGameMode.__index = TrollsAndElvesGameMode
end
function TrollsAndElvesGameMode:new (o)
    o = o or {}
    setmetatable(o, self)
    TROLLSANDELVES_REFERENCE = o
    return o
end
function TrollsAndElvesGameMode:InitGameMode()
	Msg("Hello World, My name is TrollsAndElves!")
end
EntityFramework:RegisterScriptClass( TrollsAndElvesGameMode )