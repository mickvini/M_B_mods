#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  BRN Scavenger Medium Tank
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CAAAutocannon = CybranWeaponsFile.CAAAutocannon

BRMT1PD = Class(TStructureUnit) {

    Weapons = {
        MainGun = Class(CAAAutocannon) {
	},
    },
}

TypeClass = BRMT1PD