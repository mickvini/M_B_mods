local ConstructionStructureUnit = import('/lua/terranunits.lua').TConstructionStructureUnit

XEB0204 = Class(ConstructionStructureUnit) {

    OnStartBuild = function(self, unitBeingBuilt, order)

        local myArmy = self:GetArmy()
        local otherArmy = unitBeingBuilt:GetArmy()
		
        if order != 'Repair' or (IsAlly( myArmy, otherArmy) and not ArmyIsCivilian( otherArmy)) then
		
			ConstructionStructureUnit.OnStartBuild(self, unitBeingBuilt, order)
			
        else
            IssueStop( {self} )
            IssueClearCommands( {self} )
        end
    end,
    
    OnStopBuild = function(self, unitBeingBuilt)
    
        ConstructionStructureUnit.OnStopBuild(self, unitBeingBuilt)

    end,
}

TypeClass = XEB0204