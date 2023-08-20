local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit

local Weapon = import('/lua/sim/Weapon.lua').Weapon
local WeaponFile = import('/lua/sim/defaultweapons.lua')
local CybranWeaponsFile = import('/lua/cybranweapons.lua')

local CDFLaserDisintegratorWeapon = CybranWeaponsFile.CDFLaserDisintegratorWeapon01
local CDFElectronBolterWeapon = CybranWeaponsFile.CDFElectronBolterWeapon
local MissileRedirect = import('/lua/defaultantiprojectile.lua').MissileRedirect

GMRL305 = Class(CWalkingLandUnit) {

    PlayEndAnimDestructionEffects = false,

    Weapons = {
        Disintigrator = Class(CDFLaserDisintegratorWeapon) {},
        RightDisintigrator = Class(CDFLaserDisintegratorWeapon) {},
        LeftHeavyBolter = Class(CDFElectronBolterWeapon) {},
        RightHeavyBolter = Class(CDFElectronBolterWeapon) {},
        TorsoTarget = Class(CDFLaserDisintegratorWeapon) {},
    },
}

TypeClass = GMRL305