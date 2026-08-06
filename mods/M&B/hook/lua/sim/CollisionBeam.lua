--M&B hook (lua/sim/CollisionBeam.lua)
--Collision beams deal damage from the weapon's base DamageAmount and IGNORE the weapon's DamageMods.
--The buff system applies WeaponBuffLand/Air/Naval via AddDamageMod (hook/lua/sim/Buff.lua), which works
--for projectile weapons but is silently lost on beams -- so laser/beam units never gained the damage
--research (confirmed: cannon 30->36 at buff lvl2, laser stayed at base). Apply that bonus here, once
--per impact, for EVERY beam.
--unit.MarkLevel holds the per-domain weapon-buff level set in defaultunits.lua SetMarkLevel:
--land=6 (WeaponBuffLand), air=9 (WeaponBuffAir), naval=12 (WeaponBuffNaval).
--Bonus fraction = Damage Mult - 1, matching buffdefinitions.lua: L1-4 = 1+i/10, L5 = 1.6.
local OldCollisionBeam = CollisionBeam
CollisionBeam = Class(OldCollisionBeam) {
    OnImpact = function(self, impactType, targetEntity)
        OldCollisionBeam.OnImpact(self, impactType, targetEntity)
        if impactType == 'Unit' and targetEntity and not targetEntity.Dead and self.Weapon and self.Weapon.unit then
            local unit = self.Weapon.unit
            local ml = unit.MarkLevel
            if ml then
                local cats = unit:GetBlueprint().Categories
                local idx = 6  -- land WeaponBuff by default
                if cats then
                    if table.find(cats, 'AIR') then idx = 9
                    elseif table.find(cats, 'NAVAL') then idx = 12 end
                end
                local mk = ml[idx] or 0
                -- bonus fraction (Mult - 1) per level, matches buffdefinitions WeaponBuff* Damage Mult
                local bonusFrac = ({ [1]=0.1, [2]=0.2, [3]=0.3, [4]=0.4, [5]=0.6 })[mk]
                if bonusFrac then
                    local wepbp = self.Weapon:GetBlueprint()
                    local baseDam = wepbp.Damage or 0
                    local bonus = baseDam * bonusFrac
                    if bonus >= 1 then
                        Damage(unit, targetEntity:GetPosition(), targetEntity, bonus, wepbp.DamageType or 'Normal')
                    end
                end
            end
        end
    end,
}
