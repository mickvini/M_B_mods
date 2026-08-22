#****************************************************************************
#**
#**  File     :  /units/URA0304/URA0304_Script.lua
#**  Summary  :  Cybran Strategic Bomber Script (M&B: scripted bomb drop)
#**
#****************************************************************************
local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local CIFBombNeutronWeapon = import('/lua/cybranweapons.lua').CIFBombNeutronWeapon
local CAAAutocannon = import('/lua/cybranweapons.lua').CAAAutocannon
local MNBMakeBombDropper = import('/mods/M&B/lua/MNBBombDrop.lua').MNBMakeBombDropper

URA0304 = Class(CAirUnit) {
    Weapons = {
        Bomb = Class(MNBMakeBombDropper(CIFBombNeutronWeapon)) {},
        AAGun1 = Class(CAAAutocannon) {},
        AAGun2 = Class(CAAAutocannon) {},
    },
    ContrailBones = {'Left_Exhaust','Center_Exhaust','Right_Exhaust'},
    ExhaustBones = {'Left_Exhaust','Center_Exhaust','Right_Exhaust'},

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetScriptBit('RULEUTC_StealthToggle', true)
    end,
}
TypeClass = URA0304
