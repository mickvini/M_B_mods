#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0102/UEA0102_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Terran Interceptor Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

BRNAT1INTC = Class(TAirUnit) {
    PlayDestructionEffects = true,
    DamageEffectPullback = 0.25,
    DestroySeconds = 7.5,

    Weapons = {
        MissileRack01 = Class(TSAMLauncher) {},
        aircraft = Class(TSAMLauncher) {
            FxMuzzleFlashScale = 0,
	},
    },
}

TypeClass = BRNAT1INTC