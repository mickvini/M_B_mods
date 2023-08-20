ShieldRegenBuffCheck = function(buff, unit)
	if unit.MyShield.ShieldRegenRate > 0 then
        return true
    else
    	return false
    end
end

ShieldSizeBuffCheck = function(buff, unit)
    if unit.MyShield.Size > 0 then
        return true
    else
    	return false
    end
end

ShieldHealthBuffCheck = function(buff, unit)
    if unit:GetBlueprint().Shield.ShieldMaxHealth > 0 then
        return true
    else
    	return false
    end
end