#****************************************************************************
#**
#**  File     :  /units/UEA0103/UEA0103_Script.lua
#**  Summary  :  Terran Carpet Bomber Unit Script (M&B: scripted bomb drop)
#**
#****************************************************************************
local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TIFCarpetBombWeapon = import('/lua/terranweapons.lua').TIFCarpetBombWeapon
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper
local MNB_T1_SPREAD = import('/mods/M&B/lua/MNBBombDrop.lua').MNB_T1_SPREAD

UEA0103 = Class(TAirUnit) {
    DestroyNoFallRandomChance = 1.1,
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(TIFCarpetBombWeapon, MNB_T1_SPREAD)) {
            },
        },
    DamageEffectPullback = 0.5,
}

TypeClass = UEA0103
