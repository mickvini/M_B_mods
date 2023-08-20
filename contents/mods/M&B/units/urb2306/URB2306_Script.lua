#****************************************************************************
#**
#**  File     :  /units/URB2306/URB2306_script.lua
#**  Author(s):  Optimus Prime
#**
#**  Summary  :  CYBRAN Microwave Turret
#**
#****************************************************************************

local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CDFParticleCannonWeapon = import('/lua/cybranweapons.lua').CDFParticleCannonWeapon
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CDFHeavyMicrowaveLaserGenerator = CybranWeaponsFile.CDFHeavyMicrowaveLaserGenerator

URB2306 = Class(CStructureUnit) {
    Weapons = {
        MainGun = Class(CDFHeavyMicrowaveLaserGenerator) {
        },
        Laser = Class(CDFParticleCannonWeapon) {
            FxMuzzleFlash = {'/effects/emitters/particle_cannon_muzzle_02_emit.bp'},
        },
    },
}

TypeClass = URB2306