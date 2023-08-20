#****************************************************************************
#**
#**  File     :  /cdimage/units/URA0102/URA0102_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Cybran Unit Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
#
#
local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local CWeapons = import('/lua/cybranweapons.lua')
local SDFAireauBolterWeapon = import('/lua/seraphimweapons.lua').SDFAireauBolterWeapon02
local CDFHeavyDisintegratorWeapon = CWeapons.CDFHeavyDisintegratorWeapon

BRPAT2FIGBO = Class(CAirUnit) {
    Weapons = {
        aircraft = Class(CDFHeavyDisintegratorWeapon) {
            FxMuzzleFlashScale = 0,
	},
        MainGun = Class(SDFAireauBolterWeapon) {
			            FxMuzzleFlashScale = 2.4, 
	},
        autoattack = Class(SDFAireauBolterWeapon) {
            FxMuzzleFlashScale = 0,
	},
    },

OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack', false)
      else
         self:SetWeaponEnabledByLabel('autoattack', true)
      end      
    end,
}

TypeClass = BRPAT2FIGBO
