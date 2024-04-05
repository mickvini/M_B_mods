#****************************************************************************
#**
#**  File     :  /cdimage/units/XAL0104/XAL0104_script.lua
#**  Author(s):  Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Seraphim Mobile Anti-Air Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local SDFOhCannon = import('/lua/seraphimweapons.lua').SDFOhCannon

WSL0205 = Class(SWalkingLandUnit) {
    Weapons = {
        MainGun = Class(SDFOhCannon) {},
    },
}
TypeClass = WSL0205