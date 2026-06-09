#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0202/URL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local CWeapons = import('/lua/cybranweapons.lua')
local CDFLaserDisintegratorWeapon = CWeapons.CDFLaserDisintegratorWeapon02

CSKCL0202 = Class(CLandUnit) {

    Weapons = {
        Disintegrator = Class(CDFLaserDisintegratorWeapon) {
            OnCreate = function(self)
                CDFLaserDisintegratorWeapon.OnCreate(self)
                #Disable buff 
                self:DisableBuff('STUN')
            end,
        },
    },
	
}

TypeClass = CSKCL0202