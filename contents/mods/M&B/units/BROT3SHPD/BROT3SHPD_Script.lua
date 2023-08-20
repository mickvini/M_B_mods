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
local SWeapons = import ('/lua/seraphimweapons.lua')
local AWeapons = import('/lua/aeonweapons.lua')
local WeaponsFile = import('/lua/terranweapons.lua')
local TIFCommanderDeathWeapon = WeaponsFile.TIFCommanderDeathWeapon
local TIFCommanderDeathWeapon2 = WeaponsFile.TIFCommanderDeathWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local AAAZealotMissileWeapon = AWeapons.AAAZealotMissileWeapon
local SDFChronotronCannonWeapon = SWeapons.SDFChronotronCannonWeapon

BROT3SHPD = Class(TStructureUnit) {

    Weapons = {
        cannonweapon = Class(SDFChronotronCannonWeapon) {
            FxMuzzleFlashScale = 4.85,
            FxMuzzleFlash = EffectTemplate.ASDisruptorCannonMuzzle01,
	},
        DeathWeapon = Class(TIFCommanderDeathWeapon) {
        },
        DeathWeapon2 = Class(TIFCommanderDeathWeapon2) {
        },
        AntiAirMissiles = Class(AAAZealotMissileWeapon) {
	},
    },
}

TypeClass = BROT3SHPD