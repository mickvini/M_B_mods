--------------------------------------------------------------------------------
--  Summary  :  Seraphim Strategic Bomber Script
--------------------------------------------------------------------------------
local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SIFBombZhanaseeWeapon = import('/lua/seraphimweapons.lua').SIFBombZhanaseeWeapon
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper

SSA0211 = Class(SAirUnit) {
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(SIFBombZhanaseeWeapon)) {},
    },
}

TypeClass = SSA0211
