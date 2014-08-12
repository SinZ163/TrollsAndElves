--[[
	Filter target, then use a hidden channel to tp
]]
local tent = Entities:FindByClassname(nil, "npc_dota_tower")

--[[function OnSpellStart(keys)
	print("oss called by" .. keys.caster:GetClassname())
	local caster = keys.caster
	local channel = caster:FindAbilityByName("troll_hidden_tp_channel")
	print(channel:GetClassname())
	if keys.target and keys.target:GetClassname() == "npc_dota_tower" then
		caster:CastAbilityOnTarget(keys.target, channel, 0)
	else keys.ability:EndCooldown()
	end
end]]

function OnSpellStart(keys)
	print("oss called baaaay" .. keys.caster:GetClassname())
	local caster = keys.caster
	local channel = keys.ability
	print(caster:GetClassname())
	print(keys.target:GetClassname())
	if caster == keys.target then
		print("Atteempting stop...")
		caster:Stop()
		channel:EndCooldown()
	elseif keys.target and keys.target:GetTeamNumber() == caster:GetTeamNumber() then
		caster.tpTarget = keys.target
	end
end

function OnSpellStart_Channel(keys)
	print("called by" .. keys.caster:GetClassname())
	if keys.target and keys.caster then keys.caster.tpTarget = keys.target end
end

function OnChannelFinish(keys)
	print("ocf called by" .. keys.caster:GetClassname())
	if keys.caster and keys.caster.tpTarget then 
		FindClearSpaceForUnit(keys.caster, keys.caster.tpTarget:GetOrigin(), true) 
	end
end

function OnChannelInterrupted(keys)
	
end

function TeleportCastFilter(target)

end