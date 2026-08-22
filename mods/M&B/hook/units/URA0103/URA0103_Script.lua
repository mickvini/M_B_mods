#****************************************************************************
#**
#**  File     :  /units/URA0103/URA0103_Script.lua
#**  Summary  :  Cybran Bomber Unit Script (M&B: scripted bomb drop)
#**
#****************************************************************************
local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local CIFBombNeutronWeapon = import('/lua/cybranweapons.lua').CIFBombNeutronWeapon
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper

URA0103 = Class(CAirUnit) {
    DestroyNoFallRandomChance = 1.1,
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(CIFBombNeutronWeapon)) {},
        },
    ExhaustBones = {'Exhaust_L','Exhaust_R',},
    ContrailBones = {'Contrail_L','Contrail_R',},
}

TypeClass = URA0103
