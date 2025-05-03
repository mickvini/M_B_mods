#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  BRN Scavenger Medium Tank
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TWalkingLandUnit = import('/lua/terranunits.lua').TWalkingLandUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local WeaponsFile2 = import('/lua/cybranweapons.lua')
local TOrbitalDeathLaserBeamWeapon = WeaponsFile.TOrbitalDeathLaserBeamWeapon
local TDFIonizedPlasmaCannon = WeaponsFile.TDFIonizedPlasmaCannon
local TDFMachineGunWeapon = WeaponsFile.TDFMachineGunWeapon
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local TDFGaussCannonWeapon2 = WeaponsFile.TDFLandGaussCannonWeapon
local TDFGaussCannonWeapon3 = WeaponsFile.TDFLandGaussCannonWeapon
local TIFCommanderDeathWeapon = WeaponsFile.TIFCommanderDeathWeapon
local TDFRiotWeapon = WeaponsFile.TDFRiotWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')

BRNT3BLASP = Class(TWalkingLandUnit) {

    Weapons = {
        Riotgun = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank,
			            FxMuzzleFlashScale = 0.75, 
        },
        Riotgun2 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank,
			            FxMuzzleFlashScale = 0.75, 
        },
        rocket = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.45, 
	},
        robottalk = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
        DeathWeapon = Class(TIFCommanderDeathWeapon) {
        },
        laser = Class(TOrbitalDeathLaserBeamWeapon) {
            FxMuzzleFlashScale = 0.02,
	},  
        laser2 = Class(TOrbitalDeathLaserBeamWeapon) {
            FxMuzzleFlashScale = 0.02,
	}, 
        gauss1 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 1.2,
	}, 
        gauss2 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 1.2,
	}, 
    },
OnStopBeingBuilt = function(self,builder,layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
      
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('robottalk', false)
      else
         self:SetWeaponEnabledByLabel('robottalk', true)
      end      
    end,
}

TypeClass = BRNT3BLASP