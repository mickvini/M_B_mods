local CSeaUnit = import('/lua/cybranunits.lua').CSeaUnit

local Weapon = import('/lua/sim/Weapon.lua').Weapon
local WeaponFile = import('/lua/sim/defaultweapons.lua')
local CybranWeaponsFile = import('/lua/cybranweapons.lua')

local CAAAutocannon = CybranWeaponsFile.CAAAutocannon
local CDFProtonCannonWeapon = CybranWeaponsFile.CDFProtonCannonWeapon
local CDFHvyProtonCannonWeapon = CybranWeaponsFile.CDFHvyProtonCannonWeapon
local CANNaniteTorpedoWeapon = CybranWeaponsFile.CANNaniteTorpedoWeapon

local EffectTemplate = import('/lua/EffectTemplates.lua')
local utilities = import('/lua/Utilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Entity = import('/lua/sim/Entity.lua').Entity
local explosion = import('/lua/defaultexplosions.lua')      

WRS0401 = Class(CSeaUnit) {
    Weapons = {
        FrontCannon01 = Class(CDFProtonCannonWeapon) {},
	FrontCannon02 = Class(CDFHvyProtonCannonWeapon) {},
        BackCannon01 = Class(CDFProtonCannonWeapon) {},
        Torpedo01 = Class(CANNaniteTorpedoWeapon) {},
        AAGun1 = Class(CAAAutocannon) {},
        AAGun2 = Class(CAAAutocannon) {},
	AAGun3 = Class(CAAAutocannon) {},
        AAGun4 = Class(CAAAutocannon) {},
	RightMiniTurret = Class(CDFProtonCannonWeapon) {},
	LeftMiniTurret = Class(CDFProtonCannonWeapon) {},
    },
}

TypeClass = WRS0401