local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit

local Weapon = import('/lua/sim/Weapon.lua').Weapon
local WeaponFile = import('/lua/sim/defaultweapons.lua')
local CybranWeaponsFile = import('/lua/cybranweapons.lua')

local CDFHvyProtonCannonWeapon = CybranWeaponsFile.CDFHvyProtonCannonWeapon
local CDFParticleCannonWeapon = CybranWeaponsFile.CDFParticleCannonWeapon
local CAANanoDartWeapon = CybranWeaponsFile.CAANanoDartWeapon
--local CAMZapperWeapon = CybranWeaponsFile.CAMZapperWeapon

WRL0306 = Class(CWalkingLandUnit) {
	Weapons = {
        ParticleGun = Class(CDFHvyProtonCannonWeapon) {},
		LaserGun = Class(CDFParticleCannonWeapon) {},
        AAGun = Class(CAANanoDartWeapon) {},
    },
	
    OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:HideBone('MiniTurret', false)
    end,
	
}

TypeClass = WRL0306