#****************************************************************************
#**
#**  File     :  /units/XSA0103/XSA0103_Script.lua
#**  Summary  :  Seraphim Bomber Unit Script (M&B: scripted bomb drop)
#**
#****************************************************************************
local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SDFBombOtheWeapon = import('/lua/seraphimweapons.lua').SDFBombOtheWeapon
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper

XSA0103 = Class(SAirUnit) {
    DestroyNoFallRandomChance = 1.1,
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(SDFBombOtheWeapon)) {},
    },
}

TypeClass = XSA0103
