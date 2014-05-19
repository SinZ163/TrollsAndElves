local ResetThese = {}

local Lumber = {}
Lumber.TreeInfo = {}
Lumber.GathererInfo = {}
Lumber.PlayerInfo = {}

function DefaultTreeInfo()
	return  {
	DrainRate = 5,
	Remaining = 1000
	}
end

function InfoForDummy(dummy)
	local info = Lumber.TreeInfo[dummy]
	if not info then 
		info = DefaultTreeInfo()
		Lumber.TreeInfo[dummy] = info
	end
	return info
end


function OnSpellStart(keys)
	--redirect to real tether

	local caster = keys.caster
	local ability = keys.ability
	local tether = caster:FindAbilityByName("trollsandelves_hidden_tether")
	local dummy = Entities:FindByClassnameNearest("npc_dota_creep", keys.target:GetOrigin(), 400.0) --depends on tree dummies being the only thing of this class around, can do this samrter some other time
	caster:RemoveModifierByName("trollsandelves_tether_leech")
	tether:SetLevel(4)
	tether:SetHidden(false)
	caster:CastAbilityOnTarget(dummy, tether, 0)
	table.insert(ResetThese, tether)
	local infoForDummy = InfoForDummy(dummy)

	Lumber.GathererInfo[caster] = infoForDummy
end

function OnIntervalThink(keys) --unfortunately this has to be on the wisp, and not the dummy
	local caster = keys.caster
	local lumberinfo = Lumber.GathererInfo[caster]
	if caster:HasModifier("modifier_wisp_tether") then 
		if lumberinfo.Remaining > 0 then
			lumberinfo.Remaining = lumberinfo.Remaining - lumberinfo.DrainRate
			local playerlumber = LumberStore[caster:GetPlayerID()]
			playerlumber.Amount = playerlumber.Amount + lumberinfo.DrainRate
			FireGameEvent("trollsandelves_lumber", {pid = caster:GetPlayerID(), lumber = playerlumber.Amount})
		else 
			caster:RemoveModifierByName("trollsandelves_tether_leech")
			caster:RemoveModifierByName("modifier_wisp_tether")
		end
	else 
		caster:RemoveModifierByName("trollsandelves_tether_leech")
	end
	print(lumberinfo.Remaining)
end

function HideTethers()
	local remain = {}
	for k,v in pairs(ResetThese) do
		if v:GetOwner():HasModifier("modifier_wisp_tether") then 
			v:SetHidden(true)
		else table.insert(remain, v)
		end
	end
	ResetThese = remain
end

MoonTimers:AddTimer(0.1, 0, HideTethers, {})


