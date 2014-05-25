TetherProxyDef = class(abilityclasstable, {}, MoonAbility)

function TetherProxyDef:WrapRules(varname, ent)
	if varname == "caster" then return "Collector" end
	return ""
end 

function TetherProxyDef:RedirectToDummy(caster, dummy)
	local tether = caster:FindAbilityByName("trollsandelves_hidden_tether")
	tether:SetLevel(4)
	tether:SetHidden(false)
	tether:EndCooldown()
	
	caster:CastAbilityOnTarget(dummy, tether, 0)
end

function TetherProxyDef:Untether(caster)
	caster:RemoveModifierByName("trollsandelves_tether_leech")
	caster:RemoveModifierByName("modifier_wisp_tether")
end

--callbacks take a table filled with wrapped objects
function TetherProxyDef:OnSpellStart(chest)
	local caster = chest.caster
	local dummy =  MUtil:FindByUnitNameNearest("npc_tree_dummy", chest.target:GetOrigin(), 100.0) --depends on tree dummies being the only thing of this class around, can do this samrter some other time
	caster.Ent:RemoveModifierByName("trollsandelves_tether_leech") --cleanup from any previous casts

	self:RedirectToDummy(caster.Ent, dummy)
end

function TetherProxyDef:OnIntervalThink_modifier_trollsandelves_tether_leech(chest)
	local caster = chest.caster

	caster.Ent:FindAbilityByName("trollsandelves_hidden_tether"):SetHidden(true)

	if caster.Ent:HasModifier("modifier_wisp_tether") then
		local player = MData:For("PlayerLumber", PlayerResource:GetPlayer(caster.Ent:GetPlayerID()))
		player.Total = player.Total + caster.DrainRate
		FireGameEvent("trollsandelves_lumber", {pid = caster.Ent:GetPlayerID(), lumber = player.Total})
	else self:Untether(caster.Ent)
	end
end

TetherProxy = TetherProxyDef()