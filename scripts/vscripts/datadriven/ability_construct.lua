AbilityInstance = Construct

function OnSpellStart(keys)
	AbilityInstance:EventProxy(keys.Function, keys)
end

function OnSpellStart_Resume(keys)
	AbilityInstance:EventProxy(keys.Function, keys)
end

function OnChannelInterrupted(keys) 
	AbilityInstance:EventProxy(keys.Function, keys)
end

function OnIntervalThink_modifier_trollsandelves_construct_think(keys)
	AbilityInstance:EventProxy(keys.Function, keys)
end


