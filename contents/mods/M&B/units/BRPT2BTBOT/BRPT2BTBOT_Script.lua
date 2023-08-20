#****************************************************************************
#**
#**  File     :  /units/XSL0202/XSL0202_script.lua
#**
#**  Summary  :  Seraphim Heavy Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local SDFAireauBolterWeapon = import('/lua/seraphimweapons.lua').SDFAireauBolterWeapon02
local SAAOlarisCannonWeapon = import('/lua/seraphimweapons.lua').SAAOlarisCannonWeapon

BRPT2BTBOT = Class(SWalkingLandUnit) {
    Weapons = {
        MainGun = Class(SDFAireauBolterWeapon) {},
		UpgradeGun = Class(SDFAireauBolterWeapon) {},
		AAGun01 = Class(SAAOlarisCannonWeapon) {},	
		AAGun02 = Class(SAAOlarisCannonWeapon) {},	
    },
	
    OnCreate = function(self)
		SWalkingLandUnit.OnCreate(self)
    end,
}
TypeClass = BRPT2BTBOT