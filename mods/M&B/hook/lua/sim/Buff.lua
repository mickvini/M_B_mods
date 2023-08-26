function BuffAffectUnit(unit, buffName, instigator, afterRemove)
    
    local buffDef = Buffs[buffName]
    
    local buffAffects = buffDef.Affects
    
    if buffDef.OnBuffAffect and not afterRemove then
        buffDef:OnBuffAffect(unit, instigator)
    end
    
    for atype, vals in buffAffects do
    
        if atype == 'Health' then
        
            #Note: With health we don't actually look at the unit's table because it's an instant happening.  We don't want to overcalculate something as pliable as health.
            
            local health = unit:GetHealth()
            local val = ((buffAffects.Health.Add or 0) + health) * (buffAffects.Health.Mult or 1)
            local healthadj = val - health
            
            if healthadj < 0 then
                # fixme: DoTakeDamage shouldn't be called directly
                local data = {
                    Instigator = instigator,
                    Amount = -1 * healthadj,
                    Type = buffDef.DamageType or 'Spell',
                    Vector = VDiff(instigator:GetPosition(), unit:GetPosition()),
                }
                unit:DoTakeDamage(data)
            else
                unit:AdjustHealth(instigator, healthadj)
            
                #LOG('*BUFF: Unit ', repr(unit:GetEntityId()), ' buffed health to ', repr(val))
            end
        
        elseif atype == 'MaxHealth' then
        
            local unitbphealth = unit:GetBlueprint().Defense.MaxHealth or 1
            local val = BuffCalculate(unit, buffName, 'MaxHealth', unitbphealth)
        
            local oldmax = unit:GetMaxHealth()
        
            unit:SetMaxHealth(val)
            
            if not vals.DoNoFill then
                if val > oldmax then
                    unit:AdjustHealth(unit, val - oldmax)
                else
                    unit:SetHealth(unit, math.min(unit:GetHealth(), unit:GetMaxHealth())) 
                end
            end            
            
            #LOG('*BUFF: Unit ', repr(unit:GetEntityId()), ' buffed max health to ', repr(val))
        
        elseif atype == 'Regen' then
            
            local bpregn = unit:GetBlueprint().Defense.RegenRate or 0
            local val = BuffCalculate(unit, buffName, 'Regen', bpregn)
        
            unit:SetRegenRate(val)
        
            #LOG('*BUFF: Unit ', repr(unit:GetEntityId()), ' buffed regen rate to ', repr(val))
        elseif atype == 'RegenPercent' then
            local val = false
                
            if afterRemove then
                #Restore normal regen value plus buffs so I don't break stuff. Love, Robert
                local bpregn = unit:GetBlueprint().Defense.RegenRate or 0
                val = BuffCalculate(unit, nil, 'Regen', bpregn)
            else
                #Buff this sucka
                val = BuffCalculate(unit, buffName, 'RegenPercent', unit:GetMaxHealth())
            end
            
            unit:SetRegenRate(val)

        

        elseif atype == 'ShieldRegeneration' then            
                LOG('SHIELDREGEN')
                local val = BuffCalculate(unit, buffName, 'ShieldRegeneration', 1)                
                local regenrate = unit:GetBlueprint().Defense.Shield.ShieldRegenRate or 1                
                unit.MyShield:SetShieldRegenRate(regenrate* val)               
                LOG(val)
                --unit.MyShield:SetStat('SHIELDREGEN', val * regenrate )                       
        elseif atype == 'ShieldSize' then
            LOG('SHIELDSIZE')
            local val = BuffCalculate(unit, buffName, 'ShieldSize', 1)
            local shieldsize = unit:GetBlueprint().Defense.Shield.ShieldSize or 1

            unit.MyShield:SetSize(val * shieldsize)
                
            if unit.MyShield:IsOn() then

            unit.MyShield:RemoveShield()
                unit.MyShield:CreateShieldMesh()
                    
            end
        elseif atype == 'ShieldHealth' then            
                LOG('SHIELDHEALTH')
                local val = BuffCalculate(unit, buffName, 'ShieldHealth', 1)
                local shieldhealth = unit:GetBlueprint().Defense.Shield.ShieldMaxHealth or 1
                LOG(shieldhealth)
                local shield = unit.MyShield
                LOG(val)
                shield:SetMaxHealth(shieldhealth * val)

                --shield:SetStat('SHIELDHP', val * shieldhealth )                
                shield.Owner:SetShieldRatio(shield:GetHealth() / shield:GetMaxHealth())

                -- if unit.EntityID then
                --     ForkThread(FloatingEntityText, unit.EntityID, 'Max Health now '..math.floor( GetMaxHealth(shield) or 0 ).." Size is "..math.floor(shield.Size or 0).."  Regen is "..math.floor(shield.RegenRate or 0))
                -- end
                
                if shield.RegenThread then
                    KillThread(shield.RegenThread)
                    shield.RegenThread = nil
                end
                shield.RegenThread = ForkThread(shield.RegenStartThread, shield)                
                TrashBag.Add( shield.Owner.Trash, shield.RegenThread)            
                    
        elseif atype == 'Damage' then
        
            for i = 1, unit:GetWeaponCount() do
        
                local wep = unit:GetWeapon(i)
                if wep.Label ~= 'DeathWeapon' and wep.Label ~= 'DeathImpact' then
                    local wepbp = wep:GetBlueprint()
                    local wepdam = wepbp.Damage
                    LOG(wepdam)
                    local val = BuffCalculate(unit, buffName, 'Damage', wepdam)
                    LOG(val)
                    if val >= ( math.abs(val) + 0.5 ) then
                        val = math.ceil(val)
                    else
                        val = math.floor(val)
                    end
                    LOG(val)
                    wep.DamageMod = 0
                    wep:AddDamageMod(val - wepdam) 
                    -- wepdam = val
                    -- LOG(wepbp.Damage)                 
                    LOG('*BUFF: Unit ', repr(unit:GetEntityId()), ' buffed damage to ', (val))
                end
            end
        
        elseif atype == 'DamageRadius' then
        
            for i = 1, unit:GetWeaponCount() do
        
                local wep = unit:GetWeapon(i)
                local wepbp = wep:GetBlueprint()
                local weprad = wepbp.DamageRadius
                local val = math.ceil(BuffCalculate(unit, buffName, 'DamageRadius', weprad))                
                if weprad ~= 0 then
                    wep:ChangeDamageRadius(val)                
                end                               
                #LOG('*BUFF: Unit ', repr(unit:GetEntityId()), ' buffed damage radius to ', repr(val))
            end

        elseif atype == 'MaxRadius' then
        
            for i = 1, unit:GetWeaponCount() do
        
                local wep = unit:GetWeapon(i)
                local wepbp = wep:GetBlueprint()
                local weprad = wepbp.MaxRadius
                --local wepProj = wep:GetProjectileBlueprint()
                --local wepProjPhysics = wepProj.Physics
                --local wepProjPhysicsInitSpeed = wepProjPhysics.InitialSpeed
                --local wepmuzzlevel = wepbp.MuzzleVelocity
                --LOG(wepProjPhysicsInitSpeed)
                local val = BuffCalculate(unit, buffName, 'MaxRadius', weprad)
                --local ProjPhysicsInitSpeed = BuffCalculate(unit, buffName, 'MaxRadius', wepProjPhysicsInitSpeed)
                --LOG(wepProjPhysicsInitSpeed)
                --unit:GetWeapon(i):GetProjectileBlueprint().Physics.InitialSpeed = ProjPhysicsInitSpeed
               --LOG(unit:GetWeapon(i):GetProjectileBlueprint().Physics.InitialSpeed)
                wep:ChangeMaxRadius(val)
                
                #LOG('*BUFF: Unit ', repr(unit:GetEntityId()), ' buffed max radius to ', repr(val))
            end

        elseif atype == 'MoveMult' then

          local val = BuffCalculate(unit, buffName, 'MoveMult', 1)
          unit:SetSpeedMult(val)
          
          LOG('*BUFF: Unit ', repr(unit:GetEntityId()), ' buffed speed mult to ', repr(val))

        elseif atype == 'AccMult' then

          local val = BuffCalculate(unit, buffName, 'AccMult', 1)
          unit:SetAccMult(val)

          LOG('*BUFF: Unit ', repr(unit:GetEntityId()), ' buffed accel mult to ', repr(val))

        elseif atype == 'TurnMult' then

          local val = BuffCalculate(unit, buffName, 'TurnMult', 1)
          unit:SetTurnMult(val)

          LOG('*BUFF: Unit ', repr(unit:GetEntityId()), ' buffed turn mult to ', repr(val))
                
        elseif atype == 'Stun' and not afterRemove then
            
            unit:SetStunned(buffDef.Duration or 1, instigator)
            
            #LOG('*BUFF: Unit ', repr(unit:GetEntityId()), ' buffed stunned for ', repr(buffDef.Duration or 1))
            
            if unit.Anims then
                for k, manip in unit.Anims do
                    manip:SetRate(0)
                end
            end
                    
        elseif atype == 'WeaponsEnable' then
            
            for i = 1, unit:GetWeaponCount() do
                local wep = unit:GetWeapon(i)
                local val, bool = BuffCalculate(unit, buffName, 'WeaponsEnable', 0, true)
        
                wep:SetWeaponEnabled(bool)
            end

        elseif atype == 'VisionRadius' then
            local val = BuffCalculate(unit, buffName, 'VisionRadius', unit:GetBlueprint().Intel.VisionRadius or 0)
            unit:SetIntelRadius('Vision', val)

        elseif atype == 'RadarRadius' then
            local val = BuffCalculate(unit, buffName, 'RadarRadius', unit:GetBlueprint().Intel.RadarRadius or 0)
            if not unit:IsIntelEnabled('Radar') then
                unit:InitIntel(unit:GetArmy(),'Radar', val)
                unit:EnableIntel('Radar')
            else
                unit:SetIntelRadius('Radar', val)
                unit:EnableIntel('Radar')
            end
            
            if val <= 0 then
                unit:DisableIntel('Radar')
            end
        
        elseif atype == 'OmniRadius' then
            local val = BuffCalculate(unit, buffName, 'OmniRadius', unit:GetBlueprint().Intel.RadarRadius or 0)
            if not unit:IsIntelEnabled('Omni') then
                unit:InitIntel(unit:GetArmy(),'Omni', val)
                unit:EnableIntel('Omni')
            else
                unit:SetIntelRadius('Omni', val)
                unit:EnableIntel('Omni')
            end
            
            if val <= 0 then
                unit:DisableIntel('Omni')
            end            
            
        elseif atype == 'BuildRate' then
            local val = BuffCalculate(unit, buffName, 'BuildRate', unit:GetBlueprint().Economy.BuildRate or 1)
            unit:SetBuildRate( val )
            
        #### ADJACENCY BELOW ####
        elseif atype == 'EnergyActive' then
            local val = BuffCalculate(unit, buffName, 'EnergyActive', 1)
            unit.EnergyBuildAdjMod = val
            unit:UpdateConsumptionValues()
            #LOG('*BUFF: EnergyActive = ' ..  val)
            
        elseif atype == 'MassActive' then
            local val = BuffCalculate(unit, buffName, 'MassActive', 1)
            unit.MassBuildAdjMod = val
            unit:UpdateConsumptionValues()
            #LOG('*BUFF: MassActive = ' ..  val)
            
        elseif atype == 'EnergyMaintenance' then
            local val = BuffCalculate(unit, buffName, 'EnergyMaintenance', 1)
            unit.EnergyMaintAdjMod = val
            unit:UpdateConsumptionValues()
            LOG('*BUFF: EnergyMaintenance = ' ..  val)
            
        elseif atype == 'MassMaintenance' then
            local val = BuffCalculate(unit, buffName, 'MassMaintenance', 1)
            unit.MassMaintAdjMod = val
            unit:UpdateConsumptionValues()
            #LOG('*BUFF: MassMaintenance = ' ..  val)
            
        elseif atype == 'EnergyProduction' then
            local val = BuffCalculate(unit, buffName, 'EnergyProduction', 1)
            unit.EnergyProdAdjMod = val
            unit:UpdateProductionValues()
            LOG('*BUFF: EnergyProduction = ' .. val)

        elseif atype == 'MassProduction' then
            local val = BuffCalculate(unit, buffName, 'MassProduction', 1)
            unit.MassProdAdjMod = val
            unit:UpdateProductionValues()
            #LOG('*BUFF: MassProduction = ' .. val)
            
        elseif atype == 'EnergyWeapon' then
            local val = BuffCalculate(unit, buffName, 'EnergyWeapon', 1)
            for i = 1, unit:GetWeaponCount() do
                local wep = unit:GetWeapon(i)
                if wep:WeaponUsesEnergy() then
                    wep.AdjEnergyMod = val
                end
            end
            LOG('*BUFF: EnergyWeapon = ' ..  val)
            
        elseif atype == 'RateOfFire' then
            for i = 1, unit:GetWeaponCount() do

                

                local wep = unit:GetWeapon(i)
                local wepbp = wep:GetBlueprint()
                local weprof = wepbp.RateOfFire

                # Set new rate of fire based on blueprint rate of fire.=
                local val = BuffCalculate(unit, buffName, 'RateOfFire', 1)

                local delay = 1 / wepbp.RateOfFire
                LOG('*BUFF: Old RateOfFire = ' ..  weprof )
                
                if unit:GetBlueprint().General.Category == 'Defense' then
                    LOG(unit.BaseRateOfFire[i])
                    unit.BaseRateOfFire[i] = (1 / ( val * delay ))
                    LOG(unit.BaseRateOfFire[i])
                end
                LOG('*BUFF: New RateOfFire = ' ..  (1 / ( val * delay )) )
            end



#   CLOAKING is a can of worms.  Revisit later.
#        elseif atype == 'Cloak' then
#            
#            local val, bool = BuffCalculate(unit, buffName, 'Cloak', 0)
#            
#            if unit:IsIntelEnabled('Cloak') then
#
#                if bool then
#                    unit:InitIntel(unit:GetArmy(), 'Cloak')
#                    unit:SetRadius('Cloak')
#                    unit:EnableIntel('Cloak')
#            
#                elseif not bool then
#                    unit:DisableIntel('Cloak')
#                end
#            
#            end        
        
        end
    end
end