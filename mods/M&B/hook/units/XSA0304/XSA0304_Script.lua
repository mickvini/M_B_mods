#****************************************************************************
#**
#**  File     :  /units/XSA0304/XSA0304_Script.lua
#**  Summary  :  Seraphim Strategic Bomber Script (M&B: scripted bomb drop)
#**
#****************************************************************************
local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SIFBombZhanaseeWeapon = import('/lua/seraphimweapons.lua').SIFBombZhanaseeWeapon
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper

XSA0304 = Class(SAirUnit) {
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(SIFBombZhanaseeWeapon)) {},
    },
}

TypeClass = XSA0304
