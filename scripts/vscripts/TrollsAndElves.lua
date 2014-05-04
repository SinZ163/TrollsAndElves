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
function TrollsAndElvesGameMode:InitGameMode()
	Msg("Hello World, My name is TrollsAndElves!")
	
	--Event registration --
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(TrollsAndElvesGameMode,"onEntityHurt"), self)
	ListenToGameEvent('player_chat', Dynamic_Wrap(TrollsAndElvesGameMode,"onChatMessage"), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(TrollsAndElvesGameMode,"onPlayerConnect"), self)
	-- Start thinkers
    --self._scriptBind:BeginThink('TrollsAndElvesThink', Dynamic_Wrap(TrollsAndElvesGameMode, 'Think'), 0.1)
end

function TrollsAndElvesGameMode:onEntityHurt(keys)
	print("HELLO?!")
	print(JSON:encode_pretty(keys))
	attacker = EntIndexToHScript(keys.entindex_attacker)
	print(JSON:encode_pretty(attacker)) --Hrmmm
end

function TrollsAndElvesGameMode:onChatMessage(keys)
	print(keys.message)
	print(JSON:encode_pretty(keys))
end

function TrollsAndElvesGameMode:onPlayerConnect(keys)
	print("Player connected!")
	--print(EntIndexToHScript(keys.index + 1))
	print(JSON:encode_pretty(keys))
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