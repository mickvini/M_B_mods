local ResearchFactoryUnit = import('/lua/defaultunits.lua').ResearchFactoryUnit

local OldCConstructionStructureUnit = CConstructionStructureUnit

CResearchFactoryUnit = Class(ResearchFactoryUnit) {

    StartBuildFx = function(self, unitBeingBuilt)
        local bp = self:GetBlueprint()
        local EffectUtil = import('/lua/effectutilities.lua')
        local buildbots = EffectUtil.SpawnBuildBots( self, unitBeingBuilt, table.getn(bp.General.BuildBones.BuildEffectBones), self.BuildEffectsBag )
        EffectUtil.CreateCybranEngineerBuildEffects( self, bp.General.BuildBones.BuildEffectBones, buildbots, self.BuildEffectsBag )
        if ResearchFactoryUnit.StartBuildFx then
            ResearchFactoryUnit.StartBuildFx(self, unitBeingBuilt)
        end
    end,

}

CConstructionStructureUnit = Class(OldCConstructionStructureUnit) {

    OnProductionPaused = function(self)
        --self:SetMaintenanceConsumptionInactive()
        self:SetProductionActive(false)
    end,

    OnProductionUnpaused = function(self)
        --self:SetMaintenanceConsumptionActive()
        self:SetProductionActive(true)
    end,
    
}

