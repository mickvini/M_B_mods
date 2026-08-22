--------------------------------------------------------------------------------
--  Summary  :  Aeon Bomber Script
--------------------------------------------------------------------------------
local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local AIFBombQuarkWeapon = import('/lua/aeonweapons.lua').AIFBombQuarkWeapon
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper

SAA0211 = Class(AAirUnit) {
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(AIFBombQuarkWeapon)) {},
    },
}

TypeClass = SAA0211
