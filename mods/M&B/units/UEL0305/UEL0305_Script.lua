#****************************************************************************
#**
#**  File     :  /units/UEL0108/UEL0108_script.lua
#**  Author(s):  Optimus Prime
#**
#**  Summary  :  UEF medium Tank
#**
#****************************************************************************

local TerranWeaponFile = import('/mods/m&b/lua/weapons.lua')
local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local TDFIonizedPlasmaCannon = TerranWeaponFile.TDFIonizedPlasmaCannon

UEL0305 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFIonizedPlasmaCannon) {
        FxAirUnitHitScale = 2,
    	FxLandHitScale = 2,
    	FxNoneHitScale = 2,
    	FxPropHitScale = 2,
    	FxProjectileHitScale = 2,
    	FxShieldHitScale = 2,
    	FxUnitHitScale = 2,
    	FxWaterHitScale = 2,
    	FxOnKilledScale = 2,
    	FxMuzzleFlashScale = 2,     
    },
        HeavyPlasma01 = Class(TDFGaussCannonWeapon) {},
        HeavyPlasma02 = Class(TDFGaussCannonWeapon) {},
    },
}

TypeClass = UEL0305