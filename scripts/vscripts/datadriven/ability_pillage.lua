function pillage(keys)
    local caster = keys.caster
    local damage = caster:GetAverageTrueAttackDamage()
    local armor = keys.target:GetPhysicalArmorValue()
    local damageReduction = ((0.02 * armor) / (1 + 0.02 * armor))
    local goldGain = damage * (1 - damageReduction)
    caster:ModifyGold(goldGain, false, 1)
end