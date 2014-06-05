
function OnSpellStart(keys) --try to move this to as3
	FireGameEvent("tae_build_menu",{pid = keys.caster:GetPlayerID()})
end