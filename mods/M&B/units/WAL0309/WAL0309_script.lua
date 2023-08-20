local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit

local AWeapons = import('/lua/aeonweapons.lua')
local ADFReactonCannon = AWeapons.ADFReactonCannon
local AAASonicPulseBatteryWeapon = AWeapons.AAASonicPulseBatteryWeapon

WAL0309 = Class(AWalkingLandUnit) {    
    Weapons = {
        ReactonCannon = Class(ADFReactonCannon) {},
        AAGun = Class(AAASonicPulseBatteryWeapon) {
            FxMuzzleScale = 2.25,
        },
    },
 }

TypeClass = WAL0309
