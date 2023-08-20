#****************************************************************************
#**
#**  File     :  /data/units/XAB2307/XAB2307_script.lua
#**  Author(s):  Dru Staltman, Gordon Duclos
#**
#**  Summary  :  Aeon T3 Rapid Fire Artillery
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit
local cWeapons = import('/lua/cybranweapons.lua')
local CDFLaserHeavyWeapon = cWeapons.CDFLaserHeavyWeapon

XAB2307 = Class(AStructureUnit) {
    Weapons = {
        MainGun = Class(CDFLaserHeavyWeapon){
            
        },
    },
}
TypeClass = XAB2307