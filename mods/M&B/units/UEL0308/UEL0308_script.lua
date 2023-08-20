#****************************************************************************
#**
#**  File     :  /units/UEL0308/UEL0308_script.lua
#**  Author(s):  Optimus Prime
#**
#**  Summary  :  UEF mobile SAM Launcher
#**
#****************************************************************************

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon

UEL0308 = Class(TLandUnit) {
    Weapons = {
        MissileRack01 = Class(TSAMLauncher) {},
        MissileRack02 = Class(TSAMLauncher) {},
        MissileRack03 = Class(TSAMLauncher) {},
        MissileRack04 = Class(TSAMLauncher) {},
        MissileRack05 = Class(TSAMLauncher) {},
        MissileRack06 = Class(TSAMLauncher) {},
        MainGun = Class(TDFGaussCannonWeapon) {}
    },
}

TypeClass = UEL0308