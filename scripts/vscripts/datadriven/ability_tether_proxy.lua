local AbilityInstance = TetherProxy

function OnSpellStart(keys)
	--redirect to real tether
	AbilityInstance:EventProxy(keys.Function, keys)
end

function OnIntervalThink_modifier_trollsandelves_tether_leech(keys) --unfortunately this has to be on the wisp, and not the dummy
	AbilityInstance:EventProxy(keys.Function, keys)
end



