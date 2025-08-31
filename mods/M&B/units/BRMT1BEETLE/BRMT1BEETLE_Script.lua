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
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon
local CDFElectronBolterWeapon = WeaponsFile.CDFElectronBolterWeapon
local TDFMachineGunWeapon = WeaponsFile2.TDFMachineGunWeapon
local CCannonMolecularWeapon = WeaponsFile.CCannonMolecularWeapon
local CDFHeavyMicrowaveLaserGeneratorCom = WeaponsFile.CDFHeavyMicrowaveLaserGeneratorCom
local TIFCommanderDeathWeapon = WeaponsFile2.TIFCommanderDeathWeapon
local TDFGaussCannonWeapon = WeaponsFile2.TDFLandGaussCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local TMEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')

BRMT1BEETLE = Class(CWalkingLandUnit) {

    Weapons = {
        HeavyBolter = Class(CCannonMolecularWeapon) {
            FxMuzzleFlash = EffectTemplate.CElectronBolterMuzzleFlash01,
            FxMuzzleFlashScale = 3.55,
	},
        HeavyBolter2 = Class(CCannonMolecularWeapon) {
            FxMuzzleFlash = EffectTemplate.CElectronBolterMuzzleFlash01,
            FxMuzzleFlashScale = 3.55,
	},
        rocket = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.45,
	},
        MainGun = Class(CDFHeavyMicrowaveLaserGeneratorCom) {
	},
        autoattack = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
    },
OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
      
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack', false)
      else
         self:SetWeaponEnabledByLabel('autoattack', true)
      end      
    end,

OnKilled = function(self,builder,layer)
        CWalkingLandUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in TMEffectTemplate['CybranT2BeetleHit01'] do
		CreateAttachedEmitter(self, 'BRMT1BEETLE', army, v):ScaleEmitter(1.25)
	end
end,
}

TypeClass = BRMT1BEETLE