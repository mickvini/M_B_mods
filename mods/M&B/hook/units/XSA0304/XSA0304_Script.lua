#****************************************************************************
#**
#**  File     :  /units/XSA0304/XSA0304_Script.lua
#**  Summary  :  Seraphim Strategic Bomber Script (M&B: scripted bomb drop)
#**
#****************************************************************************
local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SIFBombZhanaseeWeapon = import('/lua/seraphimweapons.lua').SIFBombZhanaseeWeapon
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper
local MNB_SQUARE = import('/mods/M&B/lua/MNBBombDrop.lua').MNB_SQUARE

XSA0304 = Class(SAirUnit) {
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(SIFBombZhanaseeWeapon, MNB_SQUARE)) {},
    },
}

TypeClass = XSA0304
