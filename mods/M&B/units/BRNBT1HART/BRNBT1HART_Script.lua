#****************************************************************************
#**
#**  File     :  /units/UEB2110/UEB2110_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Light Arty
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon

BRNBT1HART = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(TIFArtilleryWeapon) {
        },
	},
}

TypeClass = BRNBT1HART