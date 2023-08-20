#****************************************************************************
#**
#**  File     :  /cdimage/units/URA0102/URA0102_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Cybran Unit Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
#
#
local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local CWeapons = import('/lua/cybranweapons.lua')
local CDFHeavyDisintegratorWeapon = CWeapons.CDFHeavyDisintegratorWeapon

BRMAT2FIG1 = Class(CAirUnit) {
    Weapons = {
        aircraft = Class(CDFHeavyDisintegratorWeapon) {
            FxMuzzleFlashScale = 0,
	},
        AutoCannon = Class(CDFHeavyDisintegratorWeapon) {
            FxMuzzleFlashScale = 0.3,
	},
        AutoCannon2 = Class(CDFHeavyDisintegratorWeapon) {
            FxMuzzleFlashScale = 0.3,
	},
    },
}

TypeClass = BRMAT2FIG1
