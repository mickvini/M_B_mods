local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TAAGinsuRapidPulseWeapon = import('/lua/terranweapons.lua').TAAGinsuRapidPulseWeapon
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

UEAF0301 = Class(TAirUnit) {
	
	Weapons = {
        MissileWeapon = Class(TSAMLauncher) {},
		AABeam = Class(TAAGinsuRapidPulseWeapon) {},
		AABeam2 = Class(TAAGinsuRapidPulseWeapon) {},
    },
	
}

TypeClass = UEAF0301
