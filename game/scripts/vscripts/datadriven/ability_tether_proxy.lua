
function OnSpellStart(keys)
	--redirect to real tether

	local caster = keys.caster
	local dummy =  MUtil:FindByUnitNameNearest("npc_tree_dummy", keys.target:GetOrigin(), 100.0) --depends on tree dummies being the only thing of this class around, can do this samrter some other time
	caster:RemoveModifierByName("trollsandelves_tether_leech") --cleanup from any previous casts

	local tether = caster:FindAbilityByName("trollsandelves_hidden_tether")
	tether:SetLevel(4)
	tether:EndCooldown()
	
	caster:SetCursorCastTarget(dummy)
	tether:OnSpellStart()
end

function OnIntervalThink_modifier_trollsandelves_tether_leech(keys) --unfortunately this has to be on the wisp, and not the dummy
	local caster = keys.caster

	if not player.LumberTotal then player.LumberTotal = 1000 end --connect to some constant
	if caster:HasModifier("modifier_wisp_tether") then
		local player = PlayerResource:GetPlayer(caster:GetPlayerID())
		player.LumberTotal = player.LumberTotal + 5 -- "+ 5" needs wireup to collection speed vars!
		FireGameEvent("trollsandelves_lumber", {pid = caster:GetPlayerID(), lumber = player.LumberTotal})
	else Untether(caster)
	end
end

function Untether(caster)
	caster:RemoveModifierByName("trollsandelves_tether_leech")
	caster:RemoveModifierByName("modifier_wisp_tether")
end