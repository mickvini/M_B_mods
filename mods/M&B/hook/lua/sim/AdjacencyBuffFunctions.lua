ShieldRegenBuffCheck = function(buff, unit)
    -- M&B: require the RUNTIME shield to exist, not only the blueprint. Two failure modes are guarded here:
    -- (1) structures with NO shield (e.g. a plain hydrocarbon plant) -> Defense.Shield is nil;
    -- (2) a structure mid-upgrade whose blueprint already lists a shield but whose MyShield is not created
    --     yet -> indexing nil in Buff.lua (unit.MyShield:SetShieldRegenRate) crashed the sim. Gate on both.
    if not unit.MyShield then return false end
    local shield = unit:GetBlueprint().Defense.Shield
    if shield and shield.ShieldRegenRate and shield.ShieldRegenRate > 0 then
        --LOG('SRTRUE')
        return true
    else
        return false
    end
end

ShieldSizeBuffCheck = function(buff, unit)
    -- M&B: nil-safe. unit.MyShield is nil for structures without a shield and for a unit mid-upgrade before
    -- its shield is created -> `unit.MyShield.Size` crashed the sim when an energy storage applied its
    -- shield-size adjacency buff to such a unit.
    if unit.MyShield and unit.MyShield.Size and unit.MyShield.Size > 0 then
        --LOG('SZTRUE')
        return true
    else
        return false
    end
end

ShieldHealthBuffCheck = function(buff, unit)
    -- M&B: require runtime MyShield (see ShieldRegenBuffCheck): blueprint-has-shield but MyShield not yet
    -- created during an upgrade crashed Buff.lua (unit.MyShield:SetMaxHealth).
    if not unit.MyShield then return false end
    local shield = unit:GetBlueprint().Defense.Shield
    if shield and shield.ShieldMaxHealth and shield.ShieldMaxHealth > 0 then
        --LOG('HPTRUE')
        return true
    else
        return false
    end
end

