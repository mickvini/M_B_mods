#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0303/UEA0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Supersonic Fighter Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TAAGinsuRapidPulseWeapon = import('/lua/terranweapons.lua').TAAGinsuRapidPulseWeapon

BRNAT3AIRSUP = Class(TAirUnit) {
    Weapons = {
        RightBeam = Class(TAAGinsuRapidPulseWeapon) {},
        LeftBeam = Class(TAAGinsuRapidPulseWeapon) {},
    },
}

TypeClass = BRNAT3AIRSUP