local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit
local ADFLaserHighIntensityWeapon = import('/lua/aeonweapons.lua').ADFLaserHighIntensityWeapon

WAL0305 = Class(AWalkingLandUnit) {
    Weapons = {
        MainGun = Class(ADFLaserHighIntensityWeapon) {}
    },

}


TypeClass = WAL0305