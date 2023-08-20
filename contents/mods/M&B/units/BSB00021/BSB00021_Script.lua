#****************************************************************************
#** 
#**  File     :  /cdimage/units/XSB0002/XSB0002_script.lua 
#**  Author(s):  John Comes, David Tomandl 
#** 
#**  Summary  :  UEF Wall Piece Script 
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit


BSB0002 = Class(StructureUnit) {
	OnStopBeingBuilt = function(self,builder,layer)
        
    end,

### File pathing and special paramiters called ###########################

### Setsup parent call backs between drone and parent
Parent = nil,

SetParent = function(self, parent, droneName)
    self.Parent = parent
    self.Drone = droneName
end,

##########################################################################
#	OnCreate = function(self)
#		IssueGuard({self}, parent)
#	end,
    --Make this unit invulnerable
    OnDamage = function()
    end,
}


TypeClass = BSB0002

