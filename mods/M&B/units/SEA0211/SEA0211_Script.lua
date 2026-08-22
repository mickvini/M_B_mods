local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TIFSmallYieldNuclearBombWeapon = import('/lua/terranweapons.lua').TIFSmallYieldNuclearBombWeapon
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper

SEA0211 = Class(TAirUnit) {
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(TIFSmallYieldNuclearBombWeapon)) {},
        LinkedRailGun = Class(TAirToAirLinkedRailgun) {},
    },
}

TypeClass = SEA0211
