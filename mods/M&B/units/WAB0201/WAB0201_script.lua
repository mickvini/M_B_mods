local AConstructionStructureUnit = import('/lua/cybranunits.lua').CConstructionStructureUnit

local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')

WAB0201 = Class(AConstructionStructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        AConstructionStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateRotator(self, 'Ring01', 'x', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Ring01', 'y', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Ring01', 'z', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Ring02', 'x', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Ring02', 'y', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Ring02', 'z', nil, 0, 15, 80 + Random(0, 20)))
	end,

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateAeonCommanderBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,  

    OnStartBuild = function(self, unitBeingBuilt, order)

        local myArmy = self:GetArmy()
        local otherArmy = unitBeingBuilt:GetArmy()
        
        if order != 'Repair' or (IsAlly( myArmy, otherArmy) and not ArmyIsCivilian( otherArmy)) then
        
            AConstructionStructureUnit.OnStartBuild(self, unitBeingBuilt, order)
            
        else
            IssueStop( {self} )
            IssueClearCommands( {self} )
        end
    end,
    
    OnStopBuild = function(self, unitBeingBuilt)
    
        AConstructionStructureUnit.OnStopBuild(self, unitBeingBuilt)

    end,
}

TypeClass = WAB0201
