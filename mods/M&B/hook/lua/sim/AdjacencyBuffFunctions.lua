ShieldRegenBuffCheck = function(buff, unit)
	if unit:GetBlueprint().Defense.Shield.ShieldRegenRate > 0 then
        LOG('SRTRUE')
        return true
    else
    	return false
    end
end

ShieldSizeBuffCheck = function(buff, unit)
    if unit.MyShield.Size > 0 then
        LOG('SZTRUE')
        return true
    else
        return false
    end
end

ShieldHealthBuffCheck = function(buff, unit)
    if unit:GetBlueprint().Defense.Shield.ShieldMaxHealth > 0 then
        LOG('HPTRUE')
        return true
    else
    	return false
    end
end

