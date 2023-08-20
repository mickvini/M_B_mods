local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TIFSmallYieldNuclearBombWeapon = import('/lua/terranweapons.lua').TIFSmallYieldNuclearBombWeapon

WEA0305 = Class(TAirUnit) {
    Weapons = {
        RipperMissiles = Class(TIFSmallYieldNuclearBombWeapon) {},
    },
}

TypeClass = WEA0305
