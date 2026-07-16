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
        --LOG(layer)
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
-- === M28AI hook merged (was separate M28AI mod; paths rewritten in Phase 2) ===
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by maudlin27.
--- DateTime: 02/12/2022 09:13
---
local M28Events = import('/mods/M&B/lua/AI/M28Events.lua')

do --Per Balthazaar - encasing the code in do .... end means that you dont have to worry about using unique variables
        --ORIG FAF HOOKS FROM V102 BEFORE LOUD COMPATIBILITY
        --[[local M28OldUnit = Unit
        Unit = Class(M28OldUnit) {
            OnKilled = function(self, instigator, type, overkillRatio) --NOTE: For some reason this doesnt run a lot of the time; onkilledunit is more reliable
                M28Events.OnKilled(self, instigator, type, overkillRatio)
                M28OldUnit.OnKilled(self, instigator, type, overkillRatio)
            end,
            OnReclaimed = function(self, reclaimer)
                M28Events.OnKilled(self, reclaimer)
                M28OldUnit.OnReclaimed(self, reclaimer)
            end,
            OnDecayed = function(self)
                --LOG('OnDecayed: Time='..GetGameTimeSeconds()..'; self.UnitId='..(self.UnitId or 'nil'))
                M28Events.OnUnitDeath(self)
                M28OldUnit.OnDecayed(self)
            end,
            OnKilledUnit = function(self, unitKilled, massKilled)
                M28Events.OnKilled(unitKilled, self)
                M28OldUnit.OnKilledUnit(self, unitKilled, massKilled)
            end,
            OnDestroy = function(self)
                M28Events.OnUnitDeath(self) --Any custom code we want to run
                M28OldUnit.OnDestroy(self) --Normal code
            end,
            OnDamage = function(self, instigator, amount, vector, damageType)
                M28OldUnit.OnDamage(self, instigator, amount, vector, damageType)
                M28Events.OnDamaged(self, instigator) --Want this after just incase our code messes things up
            end,
            OnSiloBuildEnd = function(self, weapon)
                --LOG('OnSiloBuildEnd triggered')
                M28OldUnit.OnSiloBuildEnd(self, weapon)
                M28Events.OnMissileBuilt(self, weapon)
            end,
            OnStartBuild = function(self, built, order, ...)
                ForkThread(M28Events.OnConstructionStarted, self, built, order)
                return M28OldUnit.OnStartBuild(self, built, order, unpack(arg))
            end,
            OnStartReclaim = function(self, target)
                ForkThread(M28Events.OnReclaimStarted, self, target)
                return M28OldUnit.OnStartReclaim(self, target)
            end,
            OnStopReclaim = function(self, target)
                ForkThread(M28Events.OnReclaimFinished, self, target)
                return M28OldUnit.OnStopReclaim(self, target)
            end,

            OnStopBuild = function(self, unit)
                if unit and not(unit.Dead) and unit.GetFractionComplete and unit:GetFractionComplete() == 1 then
                    ForkThread(M28Events.OnConstructed, self, unit)
                end
                return M28OldUnit.OnStopBuild(self, unit)
            end,

            OnAttachedToTransport = function(self, transport, bone)
                ForkThread(M28Events.OnTransportLoad, self, transport, bone)
                return M28OldUnit.OnAttachedToTransport(self, transport, bone)
            end,
            OnDetachedFromTransport = function(self, transport, bone)
                ForkThread(M28Events.OnTransportUnload, self, transport, bone)
                return M28OldUnit.OnDetachedFromTransport(self, transport, bone)
            end,
            OnDetectedBy = function(self, index)

                ForkThread(M28Events.OnDetectedBy, self, index)
                return M28OldUnit.OnDetectedBy(self, index)
            end,
            OnCreate = function(self)
                M28OldUnit.OnCreate(self)
                ForkThread(M28Events.OnCreate, self)
            end,
            CreateEnhancement = function(self, enh)
                ForkThread(M28Events.OnEnhancementComplete, self, enh)
                return M28OldUnit.CreateEnhancement(self, enh)
            end,
            OnMissileImpactTerrain = function(self, target, position)
                ForkThread(M28Events.OnMissileImpactTerrain, self, target, position)
                return M28OldUnit.OnMissileImpactTerrain(self, target, position)
            end,
            OnMissileIntercepted = function(self, target, defense, position)
                ForkThread(M28Events.OnMissileIntercepted, self, target, defense, position)
                return M28OldUnit.OnMissileIntercepted(self, target, defense, position)
            end,
            OnTeleportUnit = function(self, teleporter, location, orientation)
                ForkThread(M28Events.OnTeleportComplete, self, teleporter, location, orientation)
                return M28OldUnit.OnTeleportUnit(self, teleporter, location, orientation)
            end,
            InitiateTeleportThread = function(self, teleporter, location, orientation)
                ForkThread(M28Events.OnStartTeleport, self, teleporter, location, orientation)
                return M28OldUnit.InitiateTeleportThread(self, teleporter, location, orientation)
            end,
        }--]]

        --ORIG HOOKS THAT APPEARED TO WORK IN v103 FOR LOUD AND FAF, BUT WHICH CAUSED ISSUES WITH SKIRMISH
        --[[local M28OldUnit = Unit
        Unit = Class(M28OldUnit) {
            OnCreate = function(self)
                --LOG('M28OnCreate triggering from unit.lua')
                ForkThread(M28Events.OnCreate, self)
                if M28OldUnit.OnCreate then M28OldUnit.OnCreate(self) end
            end,
            OnKilled = function(self, instigator, type, overkillRatio) --NOTE: For some reason this doesnt run a lot of the time; onkilledunit is more reliable
                --LOG('M28OnKilled triggering from unit.lua, self='..(self.UnitId or 'nil'))
                if M28OldUnit.OnKilled then M28OldUnit.OnKilled(self, instigator, type, overkillRatio) end
                --LOG('M28OnKilled about to call M28Events.OnKilled now')
                M28Events.OnKilled(self, instigator, type, overkillRatio)
            end,
            OnReclaimed = function(self, reclaimer)
                --LOG('M28OnReclaimed triggering from unit.lua')
                M28Events.OnKilled(self, reclaimer)
                if M28OldUnit.OnReclaimed then M28OldUnit.OnReclaimed(self, reclaimer) end
            end,
            OnDecayed = function(self)
                --LOG('M28OnDecayed triggering from unit.lua, Time='..GetGameTimeSeconds()..'; self.UnitId='..(self.UnitId or 'nil'))
                M28Events.OnUnitDeath(self)
                if M28OldUnit.OnDecayed then M28OldUnit.OnDecayed(self) end
            end,
            OnKilledUnit = function(self, unitKilled, massKilled)
                --LOG('M28OnKilledUnit triggering from unit.lua, self.UnitId='..(self.UnitId or 'nil'))
                M28Events.OnKilled(unitKilled, self)
                if M28OldUnit.OnKilled then M28OldUnit.OnKilledUnit(self, unitKilled, massKilled) end
            end,
            OnDestroy = function(self)
                --LOG('M28OnDestroy triggering from unit.lua')
                M28Events.OnUnitDeath(self) --Any custom code we want to run
                if M28OldUnit.OnUnitDeath then M28OldUnit.OnDestroy(self) end --Normal code
            end,
            OnDamage = function(self, instigator, amount, vector, damageType)
                --LOG('M28OnDamage triggering from unit.lua')
                if M28OldUnit.OnDamage then M28OldUnit.OnDamage(self, instigator, amount, vector, damageType) end
                M28Events.OnDamaged(self, instigator) --Want this after just incase our code messes things up
            end,
            OnSiloBuildEnd = function(self, weapon)
                LOG('M28OnSiloBuildEnd triggering from unit.lua')
                if M28OldUnit.OnSiloBuildEnd then M28OldUnit.OnSiloBuildEnd(self, weapon) end
                M28Events.OnMissileBuilt(self, weapon)
            end,
            OnStartBuild = function(self, built, order, ...)
                --LOG('M28OnStartBuild triggering from unit.lua')
                ForkThread(M28Events.OnConstructionStarted, self, built, order)
                if M28OldUnit.OnStartBuild then return M28OldUnit.OnStartBuild(self, built, order, unpack(arg)) end
            end,

            OnStopBuild = function(self, unit)
                --LOG('M28OnStopBuild triggering from unit.lua')
                if unit and not(unit.Dead) and unit.GetFractionComplete and unit:GetFractionComplete() == 1 then
                    ForkThread(M28Events.OnConstructed, self, unit)
                end
                if M28OldUnit.OnStopBuild then return M28OldUnit.OnStopBuild(self, unit) end
            end,

            OnTransportAttach = function(self, attachBone, unit) --LOUD specific function
                --LOG('M28OnTransportAttach triggering from unit.lua')
                ForkThread(M28Events.OnTransportLoad, self, unit, attachBone)
                if M28OldUnit.OnTransportAttach then
                    return M28OldUnit.OnTransportAttach(self, attachBone, unit)
                end
            end,
            OnTransportDetach = function(self, attachBone, unit) --LOUD specific function
                --LOG('M28OOnTransportDetach triggering from unit.lua')
                ForkThread(M28Events.OnTransportUnload, self, unit, attachBone)
                if M28OldUnit.OnTransportDetach then
                    return M28OldUnit.OnTransportDetach(self, attachBone, unit)
                end
            end,

            OnDetectedBy = function(self, index) --cant see this in FAF or LOUD :s
                --LOG('M28OnDetectedBy triggering from unit.lua')
                ForkThread(M28Events.OnDetectedBy, self, index)
                if M28OldUnit.OnDetectedBy then
                    return M28OldUnit.OnDetectedBy(self, index)
                end
            end,
            CreateEnhancement = function(self, enh)
                --LOG('M28OnCreateEnhancement triggering from unit.lua')
                ForkThread(M28Events.OnEnhancementComplete, self, enh)
                if M28OldUnit.CreateEnhancement then
                    return M28OldUnit.CreateEnhancement(self, enh)
                end
            end,

            OnTeleportUnit = function(self, teleporter, location, orientation)
                --LOG('M28OnTeleportUnit triggering from unit.lua')
                ForkThread(M28Events.OnTeleportComplete, self, teleporter, location, orientation)
                if M28OldUnit.OnTeleportUnit then
                    return M28OldUnit.OnTeleportUnit(self, teleporter, location, orientation)
                end
            end,
            InitiateTeleportThread = function(self, teleporter, location, orientation)
                --LOG('M28InitiateTeleportThread triggering from unit.lua')
                ForkThread(M28Events.OnStartTeleport, self, teleporter, location, orientation)
                if M28OldUnit.InitiateTeleportThread then
                    return M28OldUnit.InitiateTeleportThread(self, teleporter, location, orientation)
                end
            end,


            --The following arent in LOUD's unit.lua:
            OnStartReclaim = function(self, target)
                --LOG('M28OnStartReclaim triggering from unit.lua')
                ForkThread(M28Events.OnReclaimStarted, self, target)
                if M28OldUnit.OnStartReclaim then return M28OldUnit.OnStartReclaim(self, target) end
            end,
            OnStopReclaim = function(self, target)
                --LOG('M28OnStopReclaim triggering from unit.lua')
                ForkThread(M28Events.OnReclaimFinished, self, target)
                if M28OldUnit.OnStopReclaim then return M28OldUnit.OnStopReclaim(self, target) end
            end,
            OnAttachedToTransport = function(self, transport, bone)
                --LOG('M28OnAttachedToTransport triggering from unit.lua')
                ForkThread(M28Events.OnTransportLoad, self, transport, bone)
                if M28OldUnit.OnAttachedToTransport then
                    if M28OldUnit.OnAttachedToTransport then return M28OldUnit.OnAttachedToTransport(self, transport, bone) end
                end
            end,
            OnDetachedFromTransport = function(self, transport, bone)
                --LOG('M28OnDetachedFromTransport triggering from unit.lua')
                ForkThread(M28Events.OnTransportUnload, self, transport, bone)
                if M28OldUnit.OnDetachedFromTransport then return M28OldUnit.OnDetachedFromTransport(self, transport, bone) end
            end,
            OnMissileImpactTerrain = function(self, target, position)
                --LOG('M28OnMissileImpactTerrain triggering from unit.lua')
                ForkThread(M28Events.OnMissileImpactTerrain, self, target, position)
                if M28OldUnit.OnMissileImpactTerrain then return M28OldUnit.OnMissileImpactTerrain(self, target, position) end
            end,
            OnMissileIntercepted = function(self, target, defense, position)
                --LOG('M28OnMissileIntercepted triggering from unit.lua')
                ForkThread(M28Events.OnMissileIntercepted, self, target, defense, position)
                if M28OldUnit.OnMissileIntercepted then return M28OldUnit.OnMissileIntercepted(self, target, defense, position) end
            end,
        }--]]

    --REVISED HOOKS FOR v104 WHICH APPEAR TO WORK FOR BOTH FAF AND LOUD:
    local M28OldUnit = Unit
    Unit = Class(M28OldUnit) {
        OnKilled = function(self, instigator, type, overkillRatio) --NOTE: For some reason this doesnt run a lot of the time; onkilledunit is more reliable
            M28Events.OnKilled(self, instigator, type, overkillRatio)
            if M28OldUnit.OnKilled then M28OldUnit.OnKilled(self, instigator, type, overkillRatio) end
        end,
        OnReclaimed = function(self, reclaimer)
            M28Events.OnKilled(self, reclaimer)
            if M28OldUnit.OnReclaimed then M28OldUnit.OnReclaimed(self, reclaimer) end
        end,
        OnDecayed = function(self)
            --LOG('OnDecayed: Time='..GetGameTimeSeconds()..'; self.UnitId='..(self.UnitId or 'nil'))
            M28Events.OnUnitDeath(self)
            if M28OldUnit.OnDecayed then M28OldUnit.OnDecayed(self) end
        end,
        OnKilledUnit = function(self, unitKilled, massKilled)
            M28Events.OnKilled(unitKilled, self)
            if M28OldUnit.OnKilledUnit then M28OldUnit.OnKilledUnit(self, unitKilled, massKilled) end
        end,
        --[[OnFailedToBeBuilt = function(self)
            LOG('OnFailedToBeBuilt: Time='..GetGameTimeSeconds()..'; self.UnitId='..(self.UnitId or 'nil'))
            M28OldUnit.OnFailedToBeBuilt(self)
        end,--]]
        OnDestroy = function(self)
            M28Events.OnUnitDeath(self) --Any custom code we want to run
            if M28OldUnit.OnDestroy then M28OldUnit.OnDestroy(self) end --Normal code end
        end,
        --[[OnWorkEnd = function(self, work)
            M28Events.OnWorkEnd(self, work)
            M28OldUnit.OnWorkEnd(self, work)
        end,--]]
        OnDamage = function(self, instigator, amount, vector, damageType)
            if M28OldUnit.OnDamage then M28OldUnit.OnDamage(self, instigator, amount, vector, damageType) end
            M28Events.OnDamaged(self, instigator) --Want this after just incase our code messes things up
        end,
        OnSiloBuildEnd = function(self, weapon)
            --LOG('OnSiloBuildEnd triggered')
            if M28OldUnit.OnMissileBuilt then M28OldUnit.OnSiloBuildEnd(self, weapon) end
            M28Events.OnMissileBuilt(self, weapon)
        end,
        OnStartBuild = function(self, built, order, ...)
            ForkThread(M28Events.OnConstructionStarted, self, built, order)
            if M28OldUnit.OnStartBuild then return M28OldUnit.OnStartBuild(self, built, order, unpack(arg)) end
        end,
        OnStartReclaim = function(self, target)
            ForkThread(M28Events.OnReclaimStarted, self, target)
            if M28OldUnit.OnStartReclaim then return M28OldUnit.OnStartReclaim(self, target) end
        end,
        OnStopReclaim = function(self, target)
            ForkThread(M28Events.OnReclaimFinished, self, target)
            if M28OldUnit.OnStopReclaim then return M28OldUnit.OnStopReclaim(self, target) end
        end,

        OnStopBuild = function(self, unit)
            if unit and not(unit.Dead) and unit.GetFractionComplete and unit:GetFractionComplete() == 1 then
                ForkThread(M28Events.OnConstructed, self, unit)
            end
            if M28OldUnit.OnStopBuild then return M28OldUnit.OnStopBuild(self, unit) end
        end,

        OnAttachedToTransport = function(self, transport, bone)
            ForkThread(M28Events.OnTransportLoad, self, transport, bone)
            if M28OldUnit.OnAttachedToTransport then return M28OldUnit.OnAttachedToTransport(self, transport, bone) end
        end,
        OnDetachedFromTransport = function(self, transport, bone)
            ForkThread(M28Events.OnTransportUnload, self, transport, bone)
            if M28OldUnit.OnDetachedFromTransport then return M28OldUnit.OnDetachedFromTransport(self, transport, bone) end
        end,


        OnTransportDetach = function(self, attachBone, detachedUnit)
            M28OldUnit.OnTransportDetach(self, attachBone, detachedUnit)
            if not(M28OldUnit.OnDetachedFromTransport) then
                ForkThread(M28Events.OnTransportUnload, detachedUnit, self, attachBone)
            end
        end,

        OnDetectedBy = function(self, index)

            ForkThread(M28Events.OnDetectedBy, self, index)
            if M28OldUnit.OnDetectedBy then return M28OldUnit.OnDetectedBy(self, index) end
        end,
        OnCreate = function(self)
            M28OldUnit.OnCreate(self)
            if M28OldUnit.OnCreate then ForkThread(M28Events.OnCreate, self) end
        end,
        CreateEnhancement = function(self, enh)
            ForkThread(M28Events.OnEnhancementComplete, self, enh)
            if M28OldUnit.CreateEnhancement then return M28OldUnit.CreateEnhancement(self, enh) end
        end,
        OnMissileImpactTerrain = function(self, target, position)
            ForkThread(M28Events.OnMissileImpactTerrain, self, target, position)
            if M28OldUnit.OnMissileImpactTerrain then return M28OldUnit.OnMissileImpactTerrain(self, target, position) end
        end,
        OnMissileIntercepted = function(self, target, defense, position, projectile)
            --LOG('OnMissileIntercepted triggered')
            if M28OldUnit.OnMissileIntercepted then M28OldUnit.OnMissileIntercepted(self, target, defense, position, projectile) end
            M28Events.OnMissileIntercepted(self, target, defense, position, projectile) --Cant do via forked thread if want to reference projectile values, so wont do as return, and wont do as forked thread
        end,
        OnTeleportUnit = function(self, teleporter, location, orientation)
            ForkThread(M28Events.OnTeleportComplete, self, teleporter, location, orientation)
            if M28OldUnit.OnTeleportUnit then return M28OldUnit.OnTeleportUnit(self, teleporter, location, orientation) end
        end,
                                    --function(self, teleporter, bp, location, teledistance, teleRange, orientation, telecostpaid)
        InitiateTeleportThread = function(self, teleporter, ...) --LOUD uses different variables
            ForkThread(M28Events.OnStartTeleport, self, teleporter, unpack(arg))
            if M28OldUnit.InitiateTeleportThread then return M28OldUnit.InitiateTeleportThread(self, teleporter, unpack(arg)) end
        end,
        --LOUD specific
        OnShieldIsCharging = function(self)
            ForkThread(M28Events.ShieldRechargeStarted, self)
            if M28OldUnit.OnShieldIsCharging then return M28OldUnit.OnShieldIsCharging(self) end
        end,
        OnShieldEnabled = function(self)
            ForkThread(M28Events.ShieldEnabled, self)
            if M28OldUnit.OnShieldEnabled then return M28OldUnit.OnShieldEnabled(self) end
        end,
        OnShieldDisabled = function(self)
            ForkThread(M28Events.ShieldDisabled, self)
            if M28OldUnit.OnShieldDisabled then return M28OldUnit.OnShieldDisabled(self) end
        end,

        UpdateStat = function(self, key, value)
            --LOG('Running UpdateStat, is M28OldUnit.UpdateStat nil='..tostring(M28OldUnit.UpdateStat == nil))
            if M28OldUnit.UpdateStat then M28OldUnit.UpdateStat(self, key, value)
            else
                --Copied from FAF unit.lua as at 2024-08-26; copyright at top of file at that time is reproduced below:
                -----------------------------------------------------------------
                -- File      : /lua/unit.lua
                -- Authors   : John Comes, David Tomandl, Gordon Duclos
                -- Summary   : The Unit lua module
                -- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
                -----------------------------------------------------------------

                -- With thanks to 4z0t the `SetStat` function no longer hard-crashes when the value doesn't exist. Instead, it returns 'true'
                -- when the stat doesn't exist. If it doesn't exist then we can use `GetStat` to initialize it. This makes no sense, therefore
                -- we have this new function to hide the magic
                local cUnit = moho.unit_methods
                --M28 note - will always run GetStat to be safe due to crashes in LOUD presumably as the 4z0t reference above means a change was made elsewhere to what SetStat does
                --local needsSetup = cUnit.SetStat(self, key, value)
                --if needsSetup then
                    cUnit.GetStat(self, key, value)
                    cUnit.SetStat(self, key, value)
                --end
                --LOG('Finished setstat, key='..key..'; value='..value..'; self.UnitId='..(self.UnitId or 'nil'))
            end
        end,
    }

end


--Hooks not used:
--[[CreateEnhancementEffects = function(self, enhancement)
            local bp = self:GetBlueprint().Enhancements[enhancement]
            local effects = TrashBag()
            local bpTime = bp.BuildTime
            local bpBuildCostEnergy = bp.BuildCostEnergy
            if bpTime == nil then LOG('ERROR: CreateEnhancementEffects: bp.bpTime is nil; bp='..self:GetBlueprint().BlueprintId)
                bpTime = 1 end --Avoid infinite loop
            if bpBuildCostEnergy == nil then
                --LOG('ERROR: CreateEnhancementEffects: bp.BuildCostEnergy is nil; bp='..self:GetBlueprint().BlueprintId)
                bpBuildCostEnergy = 1 end
            local scale = math.min(4, math.max(1, (bpBuildCostEnergy / bpTime or 1) / 50))

            if bp.UpgradeEffectBones then
                for _, v in bp.UpgradeEffectBones do
                    if self:IsValidBone(v) then
                        EffectUtilities.CreateEnhancementEffectAtBone(self, v, self.UpgradeEffectsBag)
                    end
                end
            end

            if bp.UpgradeUnitAmbientBones then
                for _, v in bp.UpgradeUnitAmbientBones do
                    if self:IsValidBone(v) then
                        EffectUtilities.CreateEnhancementUnitAmbient(self, v, self.UpgradeEffectsBag)
                    end
                end
            end

            for _, e in effects do
                e:ScaleEmitter(scale)
                self.UpgradeEffectsBag:Add(e)
            end
        end, ]]--