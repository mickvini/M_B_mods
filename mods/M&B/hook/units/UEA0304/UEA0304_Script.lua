#****************************************************************************
#**
#**  File     :  /units/UEA0304/UEA0304_Script.lua
#**  Summary  :  UEF Strategic Bomber Script (M&B: scripted bomb drop)
#**
#****************************************************************************
local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TIFSmallYieldNuclearBombWeapon = import('/lua/terranweapons.lua').TIFSmallYieldNuclearBombWeapon
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper
local MNB_SQUARE = import('/mods/M&B/lua/MNBBombDrop.lua').MNB_SQUARE

UEA0304 = Class(TAirUnit) {
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(TIFSmallYieldNuclearBombWeapon, MNB_SQUARE)) {},
        LinkedRailGun1 = Class(TAirToAirLinkedRailgun) {},
        LinkedRailGun2 = Class(TAirToAirLinkedRailgun) {},
    },
}

TypeClass = UEA0304
