#****************************************************************************
#**
#**  File     :  /cdimage/units/MST0018/MST0018_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Light Artillery Installation Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local SIFZthuthaamArtilleryCannon = import('/lua/seraphimweapons.lua').SIFZthuthaamArtilleryCannon

MST0018 = Class(SStructureUnit) {

    Weapons = {
        MainGun = Class(SIFZthuthaamArtilleryCannon) {},
    },
}

TypeClass = MST0018