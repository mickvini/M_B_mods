#****************************************************************************
#**
#**  File     :  /units/XSL0202/XSL0202_script.lua
#**
#**  Summary  :  Seraphim Heavy Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local SDFAireauBolterWeapon = import('/lua/seraphimweapons.lua').SDFAireauBolterWeapon02
local AeonWeapons = import('/lua/aeonweapons.lua')
local AAAZealotMissileWeapon = AeonWeapons.AAAZealotMissileWeapon

CSKSL0300 = Class(SWalkingLandUnit) {
    Weapons = {
        MainGun = Class(SDFAireauBolterWeapon) {},
		MissileRack = Class(AAAZealotMissileWeapon) {
            
        },
		
    },	
	
	
	
}
TypeClass = CSKSL0300