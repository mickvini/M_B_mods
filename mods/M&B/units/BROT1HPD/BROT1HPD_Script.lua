#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2301/UEB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local AWeapons = import('/lua/aeonweapons.lua')
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local WeaponsFile = import('/lua/terranweapons.lua')
local TIFCommanderDeathWeapon = WeaponsFile.TIFCommanderDeathWeapon
local AAAZealotMissileWeapon = AWeapons.AAAZealotMissileWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')

BROT1HPD = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 1.2,
            FxMuzzleFlash = EffectTemplate.ASDisruptorCannonMuzzle01,
        },
        DeathWeapon = Class(TIFCommanderDeathWeapon) {
        },
        AntiAirMissiles = Class(AAAZealotMissileWeapon) {
	},
    },
}

TypeClass = BROT1HPD