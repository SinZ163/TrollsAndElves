function GoldIncome(keys)
    local caster = keys.caster
    local income = UnitsCustomKV[caster:GetUnitName()].Coefficient
    local digits = #tostring(income) + 1
    local pID = caster:GetPlayerOwnerID()

    PlayerResource:ModifyGold(pID, income, true, 0) 

    local particle = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_ABSORIGIN, caster )
    ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl( particle, 1, Vector(10,income,0))
    ParticleManager:SetParticleControl( particle, 2, Vector(1,digits,0))
    ParticleManager:SetParticleControl( particle, 3, Vector(255,215,0))
    local particle = ParticleManager:CreateParticle("particles/generic_gameplay/lasthit_coins.vpcf", PATTACH_ABSORIGIN, caster )
    ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl( particle, 1, caster:GetAbsOrigin())
end