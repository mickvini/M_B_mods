local DefaultUnitsFile = import('/lua/defaultunits.lua')

local ResearchFactoryUnit = DefaultUnitsFile.ResearchFactoryUnit

TResearchFactoryUnit = Class(ResearchFactoryUnit) {

    StartBuildFx = function(self, unitBeingBuilt)
        local bp = self:GetBlueprint()
        local EffectUtil = import('/lua/effectutilities.lua')
        WaitTicks(1)
        for k, v in bp.General.BuildBones.BuildEffectBones do
            self.BuildEffectsBag:Add( CreateAttachedEmitter( self, v, self:GetArmy(), '/effects/emitters/flashing_blue_glow_01_emit.bp' ) )
            self.BuildEffectsBag:Add( self:ForkThread( EffectUtil.CreateDefaultBuildBeams, unitBeingBuilt, {v}, self.BuildEffectsBag ) )
        end
        if ResearchFactoryUnit.StartBuildFx then
            ResearchFactoryUnit.StartBuildFx(self, unitBeingBuilt)
        end
    end,
}

local ConstructionStructureUnit = DefaultUnitsFile.ConstructionStructureUnit

TConstructionStructureUnit = Class(ConstructionStructureUnit) {
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        local UpgradesFrom = unitBeingBuilt:GetBlueprint().General.UpgradesFrom
        --If we are assisting an upgrading unit, or repairing a unit, play seperate effects
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) or (UpgradesFrom and UpgradesFrom ~= 'none' and self:IsUnitState('Guarding'))then
            EffectUtil.CreateDefaultBuildBeams( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag )
        else
            EffectUtil.CreateUEFBuildSliceBeams( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag )
        end
    end,
    
    OnProductionPaused = function(self)
        --self:SetMaintenanceConsumptionInactive()
        self:SetProductionActive(false)
    end,

    OnProductionUnpaused = function(self)
        --self:SetMaintenanceConsumptionActive()
        self:SetProductionActive(true)
    end,
}

TEngineeringResourceStructureUnit = Class(TConstructionStructureUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        TConstructionStructureUnit.OnStopBeingBuilt(self,builder,layer)
        if __blueprints[self.BpId].Economy.NaturalProducer
        and __blueprints[self.BpId].Economy.MaintenanceConsumptionPerSecondEnergy
        and __blueprints[self.BpId].Economy.MaintenanceConsumptionPerSecondEnergy > 0 then
            self:ForkThread(self.WatchProductionThread)
        end
        ChangeState(self, self.ActiveState)
    end,

    WatchProductionThread = function(self)
        --This fixes the issue NaturalProducer causes; which is that it stops paying attention to the maintenance
        local massProduction = __blueprints[self.BpId].Economy.ProductionPerSecondMass or 0
        --local energyProduction = __blueprints[self.BpId].Economy.ProductionPerSecondEnergy or 0
        while not self.Dead do
            coroutine.yield(11)
            local r = self:GetResourceConsumed()
            self:SetProductionPerSecondMass(massProduction * (self.MassProdAdjMod or 1) * r)
            --self:SetProductionPerSecondEnergy(energyProduction * (self.EnergyProdAdjMod or 1) * r)
        end
    end,

    OnDamage = function(self, instigator, amount, vector, damageType)
        TConstructionStructureUnit.OnDamage(self, instigator, amount, vector, damageType)

        self:PlaySound(self:GetBlueprint().Audio.PanicLoop)
        if instigator then
            if instigator and IsUnit(instigator) then
                local layer = instigator:GetCurrentLayer()
                local bp = self:GetBlueprint()
                local distance = util.GetDistanceBetweenTwoEntities(self, instigator)
                if distance > bp.Intel.VisionRadius * 3 then
                    --LOG("Shit that's far: ".. distance)
                    return
                elseif layer == 'Land' or self.AlternateWater  then
                    self.BuildThis = bp.Economy.BuildWhenAttackedByLand or 'ueb2101'
                elseif layer == 'Air' then
                    self.BuildThis = bp.Economy.BuildWhenAttackedByAir or 'ueb2104'
                elseif layer == 'Seabed' or layer == 'Sub' or layer == 'Water' then
                    self.BuildThis = bp.Economy.BuildWhenAttackedBySub or 'ueb2109'
                    if layer == 'Water' and not self.AlternateWater then
                        self.AlternateWater = true
                    elseif layer == 'Water' then
                        self.AlternateWater = false
                    end
                else
                    return --what are we fighting here I dont even.
                end
                --LOG("Instigator layer: ".. layer)
                ChangeState(self, self.PanicState)
            end
        end
    end,

    PanicState = State {
        Main = function(self)
            local pos = self:GetPosition()
            local aiBrain = self:GetAIBrain()

            local bp = self:GetBlueprint()
            local x = bp.Physics.SkirtSizeX / 2 + 1
            local z = bp.Physics.SkirtSizeZ / 2 + 1
            local sign = -1 + 2 * math.random(0, 1)

            if math.random(0, 1) > 0 then
                self.BuildGoalX = sign * x
                self.BuildGoalZ = math.random(-z, z)
            else
                self.BuildGoalX = math.random(-x, x)
                self.BuildGoalZ = sign * z
            end

            LOG( "Help, help, I'm being repressed!" )
            aiBrain:BuildStructure(self, self.BuildThis or 'ueb2101', {pos[1]+self.BuildGoalX, pos[3]+self.BuildGoalZ, 0})
        end,

        OnStopBuild = function(self, unitBuilding)
            TConstructionStructureUnit.OnStopBuild(self, unitBuilding)
            ChangeState(self, self.ActiveState)
        end,

        OnFailedToBuild = function(self)
            TConstructionStructureUnit.OnFailedToBuild(self)
            ChangeState(self, self.ActiveState)
        end,
    },

    ActiveState = State {
        Main = function(self)
        end,

        OnInActive = function(self)
            ChangeState(self, self.InActiveState)
        end,
    },

    InActiveState = State {
        Main = function(self)
        end,

        OnActive = function(self)
            ChangeState(self, self.ActiveState)
        end,
    },
}