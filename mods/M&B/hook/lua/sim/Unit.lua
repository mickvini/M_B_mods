do
-- local Mark = import('/mods/M&B/hook/lua/defaultunits.lua').Mark
local oldUnit = Unit
local SetHealth = moho.entity_methods.SetHealth
local SetMesh = moho.entity_methods.SetMesh
local CreateWreckageEffects = import('/lua/defaultexplosions.lua').CreateWreckageEffects

Unit = Class(oldUnit) { 
       
    OnCreate = function(self)
        oldUnit.OnCreate(self)
        self.MarkLevel = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        self.deathHitBox = nil
        self.StopSink = false        
    end,    

    PlayAnimationThread = function(self, anim, rate)
        local bp = self:GetBlueprint().Display[anim]
        if bp then
            local animBlock = self:ChooseAnimBlock(bp)
            self.animBlock = animBlock
            --for determining wreckage offset after dying with an animation
            if anim == 'AnimationDeath' then
                self.deathHitBox = animBlock.HitBox
            end

            if animBlock.Mesh then
                self:SetMesh(animBlock.Mesh)
            end
            if animBlock.Animation and (self:ShallSink() or not EntityCategoryContains(categories.NAVAL, self)) then
                local sinkAnim = CreateAnimator(self)
                self.DeathAnimManip = sinkAnim
                sinkAnim:PlayAnim(animBlock.Animation)
                rate = rate or 1
                if animBlock.AnimationRateMax and animBlock.AnimationRateMin then
                    rate = animBlock.AnimationRateMin + Random() * (animBlock.AnimationRateMax - animBlock.AnimationRateMin)
                end
                sinkAnim:SetRate(rate)      
                --sinkAnim:SetDisableOnSignal(true)
                self.Trash:Add(sinkAnim)
                WaitFor(sinkAnim)       
                self.StopSink = true   
            end
        end
    end,

    ShallSink = function(self)
        local layer = self:GetCurrentLayer()
        LOG(layer)
        local shallSink = (
            (layer == 'Water' or layer == 'Sub') and  -- In a layer for which sinking is meaningful
            not EntityCategoryContains(categories.STRUCTURE, self)  -- Exclude structures
        )
        return shallSink
    end,    
    
    SeabedWatcher = function(self)
        local pos = self:GetPosition()
        local seafloor = GetTerrainHeight(pos[1], pos[3]) + GetTerrainTypeOffset(pos[1], pos[3])
        local watchBone = self:GetBlueprint().WatchBone or 0

        self.StopSink = false
        while not self.StopSink do
            WaitTicks(1)
            if self:GetPosition(watchBone)[2]-0.2 <= seafloor then
                self.StopSink = true
                self.DeathAnimManip:SetRate(0)                                
                --LOG('STOP')
                --LOG(self.StopSink)
            end
        end        
    end,   

    DeathThread = function(self, overkillRatio, instigator)
        local isNaval = EntityCategoryContains(categories.NAVAL, self)
        local shallSink = self:ShallSink()
        WaitSeconds(utilities.GetRandomFloat(self.DestructionExplosionWaitDelayMin, self.DestructionExplosionWaitDelayMax))


        -- Stop any motion sounds we may have
        self:StopUnitAmbientSound()

        -- BOOM!
        if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        -- Flying bits of metal and whatnot. More bits for more overkill.
        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end

        if shallSink then
            self.DisallowCollisions = true
            --LOG('SINK')
            -- Bubbles and stuff coming off the sinking wreck.
            self:ForkThread(self.SinkDestructionEffects)

            -- Avoid slightly ugly need to propagate this through callback hell...
            self.overkillRatio = overkillRatio

            if isNaval and self.DeathAnimManip then
                -- Waits for wreck to hit bottom or end of animation
                if self:GetFractionComplete() > 0.5 then
                    self:SeabedWatcher()
                else
                    self:DestroyUnit(overkillRatio)
                end  
            elseif isNaval then
                self:DestroyUnit(overkillRatio)
                return
            end            
        elseif self.DeathAnimManip then -- wait for non-sinking animations
            WaitFor(self.DeathAnimManip)
        end

        -- If we're not doing fancy sinking rubbish, just blow the damn thing up.
        
        self:DestroyUnit(overkillRatio)
        
    end,

    DestroyUnit = function(self, overkillRatio) 
        
        self:CreateWreckage(overkillRatio or self.overkillRatio)

        -- wait at least 1 tick before destroying unit
        WaitSeconds(math.max(0.1, self.DeathThreadDestructionWaitTime))

        -- do not play sound after sinking
        if not self.Sinking then 
            self:PlayUnitSound('Destroyed')
        end

        self:Destroy()
    
    end,

    CreateWreckageProp = function( self, overkillRatio, overridetime )

        local bp = self:GetBlueprint()
        local wreck = bp.Wreckage.Blueprint
        
        --LOG("*AI DEBUG UNIT "..self.EntityID.." CreateWreckageProp for "..self.BlueprintID)

        if wreck then
        
            local function LifetimeThread(prop, lifetime)
            
                WaitTicks(lifetime * 10)
                prop:Destroy()
            end
           
            
            local pos = self:GetPosition()
            
            local mass = bp.Economy.BuildCostMass * (bp.Wreckage.MassMult or 0)
            local energy = bp.Economy.BuildCostEnergy * (bp.Wreckage.EnergyMult or 0)
            local time = (bp.Wreckage.ReclaimTimeMultiplier or 1)
            -- if self:GetCurrentLayer() == 'Sea' or self:GetCurrentLayer() == 'Sub' or self:GetCurrentLayer() == 'Seabed' or EntityCategoryContains(categories.NAVAL - categories.STRUCTURE, self) then
            --     --pos[2] = GetTerrainHeight(pos[1], pos[3]) + GetTerrainTypeOffset(pos[1], pos[3])
            --     --LOG('NAVAL' .. wreck)
            -- end

            local prop = CreateProp( pos, wreck )
            local cx, cy, cz, sx, sy, sz;
            cx = bp.CollisionOffsetX
            cy = bp.CollisionOffsetY
            cz = bp.CollisionOffsetZ
            sx = bp.SizeX
            sy = bp.SizeY
            sz = bp.SizeZ

            --if a death animation is played the wreck hitbox may need some changes
            if self.deathHitBox ~= nil then
                cx = self.deathHitBox.CollisionOffsetX or cx
                cy = self.deathHitBox.CollisionOffsetY or cy
                cz = self.deathHitBox.CollisionOffsetZ or cz
                sx = self.deathHitBox.SizeX or sx
                sy = self.deathHitBox.SizeY or sy
                sz = self.deathHitBox.SizeZ or sz
            end

            -- adjust the size, these dimensions are in both directions based on the center
            sx = sx * 0.5
            sy = sy * 0.5
            sz = sz * 0.5


            prop:AddBoundedProp(mass)

            prop:SetScale(bp.Display.UniformScale)
            prop:SetOrientation(self:GetOrientation(), true)
            prop:SetPropCollision('Box', cx, cy-5, cz, sx, sy, sz)
            
            prop:SetMaxReclaimValues(time, time, mass, energy)
            
            mass = (mass - (mass * (overkillRatio or 1))) * self:GetFractionComplete()
            energy = (energy - (energy * (overkillRatio or 1))) * self:GetFractionComplete()
            time = time - (time * (overkillRatio or 1))
            
            prop:SetReclaimValues(time, time, mass, energy)
            
            prop:SetMaxHealth( bp.Defense.Health * (bp.Wreckage.HealthMult or .1) )
            
            SetHealth( prop, self, bp.Defense.Health * (bp.Wreckage.HealthMult or .1))

            if not bp.Wreckage.UseCustomMesh then
                SetMesh( prop, bp.Display.MeshBlueprintWrecked )
            end

            -- all wreckage now has a lifetime max of 900 seconds --
            -- except starting props or those with an override value

            ForkThread( LifetimeThread, prop, overridetime or bp.Wreckage.LifeTime or 1800 )

            TryCopyPose(self,prop,false)

            prop.AssociatedBP = self.BlueprintID
            prop.IsWreckage = true
            

            -- when simspeed drops too low turn off visual effects
            --if Sync.SimData.SimSpeed > -1 then
                CreateWreckageEffects(self,prop)
            --end
            
            return prop
            
        end
        
    end,

    GetReclaimCosts = function(self, target_entity)

        local buildrate = self:GetBuildRate()
        local time, energy, mass
        
        if IsUnit(target_entity) then

            local target_bp = target_entity:GetBlueprint()
            
            energy = target_bp.Economy.BuildCostEnergy
            mass = target_bp.Economy.BuildCostMass

            local etime = (energy / buildrate) * .1
            local mtime = mass / buildrate

            time = math.max( mtime, etime, .1 ) * (self.ReclaimTimeMultiplier or 1) * 5

            --if not self.Reclaiming then
              --  LOG("*AI DEBUG Unit reclaim values are -- Time "..time.." -- E "..energy.." -- M "..mass.." -- buildpower "..buildrate.." -- ReclaimTimeMultiplier is "..(self.ReclaimTimeMultiplier or 1) )          
            --end
            
            -- convert to per-tick cost -- and reflect that it's negative
            energy = (energy/time) * .1
            mass = (mass/time) * .1
        
            --self.Reclaiming = true

            return time, energy, mass
            
        elseif IsProp(target_entity) then
        
            -- this will report full time (in seconds) of the reclaim --
            time, energy, mass =  target_entity:GetReclaimCosts(self, buildrate)
            
            --LOG("*AI DEBUG Prop reclaim values are -- Time "..time.." -- E "..energy.." -- M "..mass.." -- buildpower "..buildrate )
            
            return time, energy, mass
            
        end
        
    end,

    CloakEffectControlThread = function(self)
        if not self:IsDead() then
            local bp = self:GetBlueprint()
            if not bp.Intel.CustomCloak then
                local bpDisplay = bp.Display
                while not (self == nil or self:GetHealth() <= 0 or self:IsDead()) do
                    WaitSeconds(0.2)
                    self:UpdateCloakEffect()
                    local CloakFieldIsActive = self:IsIntelEnabled('CloakField')
                    if CloakFieldIsActive then
                        local position = self:GetPosition(0)
                        -- Range must be (radius - 2) because it seems GPG did that for the actual field for some reason.
                        -- Anything beyond (radius - 2) is not cloaked by the cloak field
                        local range = bp.Intel.CloakFieldRadius - 2
                        local brain = self:GetAIBrain()
                        local UnitsInRange = brain:GetUnitsAroundPoint( categories.ALLUNITS, position, range, 'Ally' )
                        for num, unit in UnitsInRange do
                            unit:MarkUnitAsInCloakField()
                        end
                    end
                end
            end
        end
    end,

    -- Fork the thread that will deactivate the cloak effect, killing any previous threads that may be running
    MarkUnitAsInCloakField = function(self)
        self.InCloakField = true
        if self.InCloakFieldThread then
            KillThread(self.InCloakFieldThread)
            self.InCloakFieldThread = nil
        end
        self.InCloakFieldThread = self:ForkThread(self.InCloakFieldWatchThread)
    end,

    -- Will deactive the cloak effect if it is not renewed by the cloak field
    InCloakFieldWatchThread = function(self)
        WaitSeconds(0.2)
        self.InCloakField = false
    end,

    -- This is the core of the entire mod. The effect is actually applied here.
    UpdateCloakEffect = function(self)
        if not self:IsDead() then
            local bp = self:GetBlueprint()
            local bpDisplay = bp.Display
            if not bp.Intel.CustomCloak then
                local cloaked = self:IsIntelEnabled('Cloak') or self.InCloakField
                if (not cloaked and self.CloakEffectEnabled) or self:GetHealth() <= 0 then
                    self:SetMesh(bpDisplay.MeshBlueprint, true)
                elseif cloaked and not self.CloakEffectEnabled then
                    self:SetMesh(bpDisplay.CloakMeshBlueprint , true)
                    self.CloakEffectEnabled = true
                end
            end
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        oldUnit.OnStopBeingBuilt(self,builder,layer)
        self.EXPhaseShieldPercentage = 0
        self.EXPhaseEnabled = false
        self.EXTeleportCooldownCharge = false
        self.EXPhaseCharge = 0
        self:ForkThread(self.CloakEffectControlThread)
    end,

    -- Overridden Function:
    -- Overrode this so that there will be no doubt if the cloak effect is active or not
    SetMesh = function(self, meshBp, keepActor)
        oldUnit.SetMesh(self, meshBp, keepActor)
        self.CloakEffectEnabled = false
    end,

    -- Overridden Function:
    -- While the CloakEffectControlThread will activate the cloak effect eventually,
    -- this method tries to provide faster a response time to intel changes
    OnIntelEnabled = function(self)
            oldUnit.OnIntelEnabled(self)
        if not self:IsDead() then
            self:UpdateCloakEffect()
        end
    end,

    -- Overridden Function:
    -- While the CloakEffectControlThread will deactivate the cloak effect eventually,
    -- this method tries to provide faster a response time to intel changes
    OnIntelDisabled = function(self)
            oldUnit.OnIntelDisabled(self)
        if not self:IsDead() then
            self:UpdateCloakEffect()
        end
    end,

    CleanupTeleportChargeEffects = function(self)
        self.TeleportCostPaid = false
        oldUnit.CleanupTeleportChargeEffects(self)
    end,

    OnTeleportUnit = function(self, teleporter, location, orientation)
        local id = self:GetEntityId()
        -- Teleport Cooldown Charge
        -- Range Check to location
        local maxRange = self:GetBlueprint().Defense.MaxTeleRange
        local myposition = self:GetPosition()
        local destRange = VDist2(location[1], location[3], myposition[1], myposition[3])
        if maxRange and destRange > maxRange then
            FloatingEntityText(id,'<LOC tooltipui0989>Destination Out Of Range')
            return
        end
        -- Teleport Interdiction Check
        for num, brain in ArmyBrains do
            local unitList = brain:GetListOfUnits(categories.ANTITELEPORT, false)
            for i, unit in unitList do
                --  if it's an ally, then we skip.
                if not IsEnemy(self:GetArmy(), unit:GetArmy()) then 
                    continue
                end
                local noTeleDistance = unit:GetBlueprint().Defense.NoTeleDistance
                local atposition = unit:GetPosition()
                local selfpos = self:GetPosition()
                local targetdest = VDist2(location[1], location[3], atposition[1], atposition[3])
                local sourcecheck = VDist2(selfpos[1], selfpos[3], atposition[1], atposition[3])
                if noTeleDistance and noTeleDistance > targetdest then
                    FloatingEntityText(id,'<LOC tooltipui0990>Teleport Destination Scrambled')
                    return
                elseif noTeleDistance and noTeleDistance >= sourcecheck then
                    FloatingEntityText(id,'<LOC tooltipui0991>Teleport Generator Scrambled')
                    return
                end
            end
        end
        -- Economy Check and Drain
        local bp = self:GetBlueprint()
        local telecost = bp.Economy.TeleportBurstEnergyCost or 0
        local mybrain = self:GetAIBrain()
        local storedenergy = mybrain:GetEconomyStored('ENERGY')
        if telecost > 0 and not self.TeleportCostPaid then
            if storedenergy >= telecost then
                mybrain:TakeResource('ENERGY', telecost)
                self.TeleportCostPaid = true
            else
                FloatingEntityText(id,'<LOC tooltipui0992>Insufficient Energy For Teleportation')
                return
            end
        end
        oldUnit.OnTeleportUnit(self, teleporter, location, orientation) 
    end,

    PlayTeleportChargeEffects = function(self)
        oldUnit.PlayTeleportChargeEffects(self) 
        if not self:IsDead() and not self.EXPhaseEnabled == true then
            self.EXTeleportChargeEffects(self)
        end
    end,

    OnFailedTeleport = function(self)
        oldUnit.OnFailedTeleport(self) 
        if not self:IsDead() and not self.EXPhaseEnabled == false then   
            self.EXPhaseEnabled = false
            self.EXPhaseCharge = 0
            self.EXPhaseShieldPercentage = 0
            local bp = self:GetBlueprint()
            local bpDisplay = bp.Display
            if self.EXPhaseCharge == 0 then self:SetMesh(bpDisplay.MeshBlueprint, true) end
        end
    end,

    PlayTeleportInEffects = function(self)
        oldUnit.PlayTeleportInEffects(self) 
        if not self:IsDead() and not self.EXPhaseEnabled == false then   
            self.EXTeleportCooldownEffects(self)
        end
    end,
    
    EXTeleportChargeEffects = function(self)
        if not self:IsDead() then
            local bpe = self:GetBlueprint().Economy
            self.EXPhaseEnabled = true
            self.EXPhaseCharge = 1
            self.EXPhaseShieldPercentage = 0
            if bpe then
                local mass = bpe.BuildCostMass * (bpe.TeleportMassMod or 0.01)
                local energy = bpe.BuildCostEnergy * (bpe.TeleportEnergyMod or 0.01)
                energyCost = mass + energy
                EXTeleTime = energyCost * (bpe.TeleportTimeMod or 0.01)
                self.EXTeleTimeMod1 = (EXTeleTime * 10) * 0.2
                self.EXTeleTimeMod2 = self.EXTeleTimeMod1 * 2
                self.EXTeleTimeMod3 = (EXTeleTime * 10) - ((self.EXTeleTimeMod1 * 2) + self.EXTeleTimeMod2)
                self.EXTeleTimeMod4 = (self.EXTeleTimeMod3) - 7
                local bp = self:GetBlueprint()
                local bpDisplay = bp.Display
                if self.EXPhaseCharge == 1 then
                    WaitTicks(self.EXTeleTimeMod1)
                end
                if self.EXPhaseCharge == 1 then
                    self:SetMesh(bpDisplay.Phase1MeshBlueprint, true)
                    self.EXPhaseShieldPercentage = 33
                    WaitTicks(self.EXTeleTimeMod2)
                end
                if self.EXPhaseCharge == 1 then
                    self.EXPhaseShieldPercentage = 66
                    WaitTicks(self.EXTeleTimeMod1)
                end
                if self.EXPhaseCharge == 1 then
                    self.EXPhaseShieldPercentage = 100
                    if self.EXTeleTimeMod3 >= 7 then
                        WaitTicks(self.EXTeleTimeMod4)
                    end
                end
                if self.EXPhaseCharge == 1 then self:SetMesh(bpDisplay.Phase2MeshBlueprint, true) end
            end
        end
    end,

    EXTeleportCooldownEffects = function(self)
        if not self:IsDead() then
            local bp = self:GetBlueprint()
            local bpDisplay = bp.Display
            self.EXPhaseCharge = 0
            if self.EXPhaseCharge == 0 then
                self.EXPhaseShieldPercentage = 100
                WaitTicks(5)
            end
            if self.EXPhaseCharge == 0 then
                self.EXPhaseShieldPercentage = 100
                self:SetMesh(bpDisplay.Phase1MeshBlueprint, true)
                WaitTicks(8)
            end
            if self.EXPhaseCharge == 0 then
                self.EXPhaseShieldPercentage = 75
                self:SetMesh(bpDisplay.Phase1MeshBlueprint, true)
                WaitTicks(25)
            end
            if self.EXPhaseCharge == 0 then
                self.EXPhaseShieldPercentage = 50
                self:SetMesh(bpDisplay.MeshBlueprint, true)
                WaitTicks(10)
                self.EXPhaseShieldPercentage = 0
                self.EXPhaseEnabled = false
            end
        end
    end,

    OnCollisionCheck = function(self, other, firingWeapon)
        if self.DisallowCollisions then
            return false
        end
        --Run a modified CollideFriendly check first that allows for allied passthrough
        if EntityCategoryContains(categories.PROJECTILE, other) then
            if not self:GetShouldCollide( other:GetCollideFriendly(), self:GetArmy(), other:GetArmy() ) then
                return false
            end
        end
        if other.lastimpact and other.lastimpact == self:GetEntityId() then
            return false
        end 
        if not self:IsDead() and self.EXPhaseEnabled == true then
            if EntityCategoryContains(categories.PROJECTILE, other) then 
                local random = Random(1,100)
                -- Allows % of projectiles to pass
                if random <= self.EXPhaseShieldPercentage then   
                    -- Returning false allows the projectile to pass thru
                    return false       
                else
                    -- Projectile impacts normally
                    return true 
                end
            end
        end
        return oldUnit.OnCollisionCheck(self, other, firingWeapon) 
    end,  

    OnCollisionCheckWeapon = function(self, firingWeapon)
        if self.DisallowCollisions then
            return false
        end
        --Run a modified CollideFriendly check first that allows for allied passthrough
        if not self:GetShouldCollide( firingWeapon:GetBlueprint().CollideFriendly, self:GetArmy(), firingWeapon.unit:GetArmy() ) then
            return false
        end
        return oldUnit.OnCollisionCheckWeapon(self, firingWeapon)
    end,

    GetShouldCollide = function(self, collidefriendly, army1, army2)
        if not collidefriendly then
            if army1 == army2 or IsAlly(army1, army2) then
                return false
            end
        end
        return true
    end,    

 }

end