#****************************************************************************
#**
#**  File     :  /units/UAA0304/UAA0304_Script.lua
#**  Summary  :  Aeon Strategic Bomber Script (M&B: scripted bomb drop)
#**
#****************************************************************************
local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local AIFBombQuarkWeapon = import('/lua/aeonweapons.lua').AIFBombQuarkWeapon
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper
local MNB_SQUARE = import('/mods/M&B/lua/MNBBombDrop.lua').MNB_SQUARE

UAA0304 = Class(AAirUnit) {
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(AIFBombQuarkWeapon, MNB_SQUARE)) {},
    },
}

TypeClass = UAA0304
