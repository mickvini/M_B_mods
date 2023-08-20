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
local TIFCommanderDeathWeapon = WeaponsFile2.TIFCommanderDeathWeapon
local TDFGaussCannonWeapon = WeaponsFile2.TDFLandGaussCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')

BRMT2BM = Class(CWalkingLandUnit) {

    Weapons = {
        HeavyBolter = Class(CCannonMolecularWeapon) {
            FxMuzzleFlashScale = 0.75,
	},
        rocket = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.45,
	},
        rocket2 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.45,
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
}

TypeClass = BRMT2BM