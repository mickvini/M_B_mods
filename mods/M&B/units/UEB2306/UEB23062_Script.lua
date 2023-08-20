#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2301/UEB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TerranWeaponFile = import('/lua/terranweapons.lua')
local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TDFIonizedPlasmaCannon = TerranWeaponFile.TDFIonizedPlasmaCannon

UEB2306 = Class(TStructureUnit) {
    Weapons = {
        Gauss01 = Class(TDFIonizedPlasmaCannon) {},    
    },
}

TypeClass = UEB2306