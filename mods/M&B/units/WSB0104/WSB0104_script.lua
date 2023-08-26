local SConstructionStructureUnit = import('/lua/cybranunits.lua').CConstructionStructureUnit

local EffectUtil = import('/lua/EffectUtilities.lua')

WSB0104 = Class(SConstructionStructureUnit) {

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateSeraphimUnitEngineerBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)

        local myArmy = self:GetArmy()
        local otherArmy = unitBeingBuilt:GetArmy()
        
        if order != 'Repair' or (IsAlly( myArmy, otherArmy) and not ArmyIsCivilian( otherArmy)) then
        
            SConstructionStructureUnit.OnStartBuild(self, unitBeingBuilt, order)
            
        else
            IssueStop( {self} )
            IssueClearCommands( {self} )
        end
    end,
    
    OnStopBuild = function(self, unitBeingBuilt)
    
        SConstructionStructureUnit.OnStopBuild(self, unitBeingBuilt)

    end,
}

TypeClass = WSB0104

