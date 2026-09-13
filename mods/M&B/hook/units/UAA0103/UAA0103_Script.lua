#****************************************************************************
#**
#**  File     :  /units/UAA0103/UAA0103_Script.lua
#**  Summary  :  Aeon Bomber Unit Script (M&B: scripted bomb drop)
#**
#****************************************************************************
local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local AIFBombGravitonWeapon = import('/lua/aeonweapons.lua').AIFBombGravitonWeapon
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper
local MNB_T1_SPREAD = import('/mods/M&B/lua/MNBBombDrop.lua').MNB_T1_SPREAD

UAA0103 = Class(AAirUnit) {
    DestroyNoFallRandomChance = 1.1,
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(AIFBombGravitonWeapon, MNB_T1_SPREAD)) {},
    },
}

TypeClass = UAA0103
