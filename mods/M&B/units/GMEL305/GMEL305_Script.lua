local TerranWeaponFile = import('/lua/terranweapons.lua')
local TWalkingLandUnit = import('/lua/terranunits.lua').TWalkingLandUnit
local TSAMLauncher = TerranWeaponFile.TSAMLauncher
local TDFHeavyPlasmaCannonWeapon = TerranWeaponFile.TDFHeavyPlasmaCannonWeapon

GMEL305 = Class(TWalkingLandUnit) {

    Weapons = {
        MissileRack = Class(TSAMLauncher) {},
	PlasmaCannon = Class(TDFHeavyPlasmaCannonWeapon) {
		FxMuzzleFlashScale = 2,
	},
    },
    
}

TypeClass = GMEL305