#****************************************************************************
#**
#**  File     :  /cdimage/units/UEAconcpt1/UEAconcpt1_script.lua
#**  Author(s):  Jessica St. Croix, David Tomandl
#**
#**  Summary  :  UEF Spy Plane Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TIFSmallYieldNuclearBombWeapon = WeaponsFile.TIFSmallYieldNuclearBombWeapon
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon

BRMAT2ADVBOMBER = Class(TAirUnit) {
    Weapons = {
        aamissiles1 = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
        Bomb = Class(TIFSmallYieldNuclearBombWeapon) {
	},
        autoattack = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
        autoattack2 = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
    },

OnStopBeingBuilt = function(self,builder,layer)

        TAirUnit.OnStopBeingBuilt(self,builder,layer)
      
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack2', false)
      else
         self:SetWeaponEnabledByLabel('autoattack2', true)
        end
    end,

}

TypeClass = BRMAT2ADVBOMBER