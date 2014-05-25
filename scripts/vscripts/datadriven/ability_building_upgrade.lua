--this is simple enough

function OnSpellStart(keys)
	local caster = keys.caster
	local unitname = caster:GetUnitName()

	local nextbuilding = UnitsCustomKV[unitname].NextUpgrade

	if nextbuilding ~= "None" and MUtil:FindByUnitName(nil, nextbuilding) and TrollsAndElvesGameMode:ModifyGold(caster:GetOwner(), -nextbuilding.LumberCost) then
		local unit = CreateUnitByName(nextbuilding, caster:GetOrigin(), false, nil, nil, caster:GetTeamNumber())
		UTIL_RemoveImmediate(caster)
	end

	--todo:presentation, channel?
end