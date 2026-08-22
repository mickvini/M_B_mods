#****************************************************************************
#**
#**  File     :  /units/UAA0103/UAA0103_Script.lua
#**  Summary  :  Aeon Bomber Unit Script (M&B: scripted bomb drop)
#**
#****************************************************************************
local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local AIFBombGravitonWeapon = import('/lua/aeonweapons.lua').AIFBombGravitonWeapon
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper

UAA0103 = Class(AAirUnit) {
    DestroyNoFallRandomChance = 1.1,
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(AIFBombGravitonWeapon)) {},
    },
}

TypeClass = UAA0103
