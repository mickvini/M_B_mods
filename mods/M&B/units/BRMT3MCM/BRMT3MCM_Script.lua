#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  BRN Scavenger Medium Tank
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local WeaponsFile = import('/lua/cybranweapons.lua')
local WeaponsFile2 = import('/lua/terranweapons.lua')
local CDFElectronBolterWeapon = WeaponsFile.CDFElectronBolterWeapon
local TDFRiotWeapon = WeaponsFile2.TDFRiotWeapon
local CCannonMolecularWeapon = WeaponsFile.CCannonMolecularWeapon
local TIFCommanderDeathWeapon = WeaponsFile2.TIFCommanderDeathWeapon
local TDFGaussCannonWeapon = WeaponsFile2.TDFLandGaussCannonWeapon
local TMEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')

BRMT3MCM = Class(CWalkingLandUnit) {

    Weapons = {
        HeavyBolter = Class(CDFElectronBolterWeapon) {
	},
        HeavyBoltera = Class(CDFElectronBolterWeapon) {
	},
        HeavyBolterb = Class(CDFElectronBolterWeapon) {
	},
        robottalk = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0,
	},
        HeavyBolter2 = Class(CDFElectronBolterWeapon) {
	},
        HeavyBolter2a = Class(CDFElectronBolterWeapon) {
	},
        HeavyBolter2b = Class(CDFElectronBolterWeapon) {
	},
        mgweapon = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank,
			            FxMuzzleFlashScale = 0.75, 
        },
        lefthandweapon = Class(CCannonMolecularWeapon) {
            FxMuzzleFlashScale = 1.4,
	},
        righthandweapon = Class(CCannonMolecularWeapon) {
            FxMuzzleFlashScale = 1.4,
	},
        rocket1 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.7,
	},
        rocket2 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.7,
	},
        rocket3 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.7,
	},
        rocket4 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.7,
	},
        DeathWeapon = Class(TIFCommanderDeathWeapon) {
	},
    },
OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
      
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('robottalk', false)
      else
         self:SetWeaponEnabledByLabel('robottalk', true)
      end      
    end,

OnKilled = function(self,builder,layer)
        CWalkingLandUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in TMEffectTemplate['MadCatDeath01'] do
		CreateAttachedEmitter(self, 'Turret', army, v):ScaleEmitter(1.5)
	end
end,
}

TypeClass = BRMT3MCM