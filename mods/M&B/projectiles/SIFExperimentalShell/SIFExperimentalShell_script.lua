local SSuthanusArtilleryShell = import('/lua/seraphimprojectiles.lua').SSuthanusArtilleryShell
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

SIFExperimentalShell = Class(SSuthanusArtilleryShell) {

    OnImpact = function(self, TargetType, targetEntity)
	SSuthanusArtilleryShell.OnImpact( self, TargetType, targetEntity )
	local location = self:GetPosition()
	local AssaultUnit = CreateUnitHPR('GMSB403a', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
    end,
}

TypeClass = SIFExperimentalShell
