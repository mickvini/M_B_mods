#****************************************************************************
#**
#**  File     :  /cdimage/units/UEAconcpt1/UEAconcpt1_script.lua
#**  Author(s):  Jessica St. Croix, David Tomandl
#**
#**  Summary  :  UEF Spy Plane Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TANTorpedoAngler = import('/lua/terranweapons.lua').TANTorpedoAngler
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon

BRNAT1ADVFIG = Class(TAirUnit) {
    Weapons = {
        aamissiles1 = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},       
        autoattack = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
    },

}

TypeClass = BRNAT1ADVFIG