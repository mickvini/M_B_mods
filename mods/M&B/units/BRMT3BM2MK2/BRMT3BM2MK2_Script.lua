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
local CWeapons = import('/lua/cybranweapons.lua')
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local CDFHeavyMicrowaveLaserGeneratorCom = CWeapons.CDFHeavyMicrowaveLaserGeneratorCom
local TIFCommanderDeathWeapon = WeaponsFile.TIFCommanderDeathWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon

BRMT3BM2MK2 = Class(CWalkingLandUnit) {

    Weapons = {
        autoattack = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},

        robottalk = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0,
	},
        maingun1 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 4.1,
            FxMuzzleFlash = EffectTemplate.CElectronBolterMuzzleFlash01,
        },
        maingun2 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 4.1,
            FxMuzzleFlash = EffectTemplate.CElectronBolterMuzzleFlash01,
        },
        gatling1 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 1.1,
            FxMuzzleFlash = EffectTemplate.CElectronBolterMuzzleFlash01,
        },
        gatling2 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 1.1,
            FxMuzzleFlash = EffectTemplate.CElectronBolterMuzzleFlash01,
        },
        gatling3 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 1.1,
            FxMuzzleFlash = EffectTemplate.CElectronBolterMuzzleFlash01,
        },
        gatling4 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 1.1,
            FxMuzzleFlash = EffectTemplate.CElectronBolterMuzzleFlash01,
        },
        DeathWeapon = Class(TIFCommanderDeathWeapon) {
	},
        laserfront = Class(CDFHeavyMicrowaveLaserGeneratorCom) {
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
	for k, v in ModEffectTemplate['CybranT3BattleBotDeath'] do
		CreateAttachedEmitter(self, 'BRMT3BM2MK2', army, v):ScaleEmitter(6.0)
	end
end,
}

TypeClass = BRMT3BM2MK2