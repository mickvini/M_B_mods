--M&B bugfix: was MobileUnit - that base class skips the lab research buffs
--(health/speed/damage). LandUnit applies them on OnStopBeingBuilt like every
--other land combat unit.
local CLandUnit = import('/lua/defaultunits.lua').LandUnit

local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CIFMissileLoaWeapon = CybranWeaponsFile.CIFMissileLoaWeapon
local CDFProtonCannonWeapon = CybranWeaponsFile.CDFProtonCannonWeapon
local CAANanoDartWeapon = CybranWeaponsFile.CAANanoDartWeapon
local CIFSmartCharge = CybranWeaponsFile.CIFSmartCharge
CybranWeaponsFile = nil
local meshfile = 'mods/M&B/projectiles/ciftoxmissiletactical01/ciftoxmissiletactical01_mesh'

SRL0312 = Class(CLandUnit) {
    Weapons = {
        MissileRack = Class(CIFMissileLoaWeapon) {},
                
        Proton = Class(CDFProtonCannonWeapon) {},
        
        AntiTorpedo = Class(CIFSmartCharge) {},
    },
}

TypeClass = SRL0312
