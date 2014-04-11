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
	
	--Event registration --
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(TrollsAndElvesGameMode, 'onEntityHurt'), self)
	-- Start thinkers
    self._scriptBind:BeginThink('TrollsAndElvesThink', Dynamic_Wrap(TrollsAndElvesGameMode, 'Think'), 0.1)
end

function TrollsAndElvesGameMode:onEntityHurt(keys)
	print("HELLO?!")
	print(JSON:encode_pretty(keys))
	attacker = EntIndexToHScript(keys.entindex_attacker)
	print(JSON:encode_pretty(attacker)) --Hrmmm
end
function TrollsAndElvesGameMode:Think()
    -- Track game time, since the dt passed in to think is actually wall-clock time not simulation time.
    local now = GameRules:GetGameTime()
    if self.t0 == nil then
        self.t0 = now
    end
    local dt = now - self.t0
    self.t0 = now
	
	
end

EntityFramework:RegisterScriptClass( TrollsAndElvesGameMode )