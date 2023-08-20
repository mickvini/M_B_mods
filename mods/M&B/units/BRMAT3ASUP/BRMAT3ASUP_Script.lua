#****************************************************************************
#**
#**  File     :  /cdimage/units/URA0303/URA0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Air Superiority Fighter Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon

BRMAT3ASUP = Class(CAirUnit) {
    ExhaustBones = { 'ex01', 'ex02' },
    ContrailBones = { 'Contrail_L', 'Contrail_R', },
    Weapons = {
        Missiles1 = Class(CAAMissileNaniteWeapon) {},
        Missiles2 = Class(CAAMissileNaniteWeapon) {},
    },
    
}

TypeClass = BRMAT3ASUP
