#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  BRN Scavenger Medium Tank
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local TIFCommanderDeathWeapon = WeaponsFile.TIFCommanderDeathWeapon
local TDFMachineGunWeapon = WeaponsFile.TDFMachineGunWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon

BRNT3BT0 = Class(TLandUnit) {

    Weapons = {
        autoattack = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
        MainGun = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 1.5,
            FxMuzzleFlash = { 
            	'/effects/emitters/proton_artillery_muzzle_01_emit.bp',
            	'/effects/emitters/proton_artillery_muzzle_03_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_smoke_01_emit.bp',                                
            }, 
	    FxGroundEffect = EffectTemplate.ConcussionRingLrg01,
	        FxVentEffect3 = EffectTemplate.CDisruptorGroundEffect,
	        FxVentEffect = EffectTemplate.CDisruptorVentEffect,
	        FxVentEffect2 = EffectTemplate.WeaponSteam01,
	        FxVentEffect4 = EffectTemplate.THeavyFragmentationGrenadeHit,
	        FxMuzzleEffect = EffectTemplate.TPlasmaGatlingCannonMuzzleFlash,
	        FxCoolDownEffect = EffectTemplate.CDisruptorCoolDownEffect,     
	        PlayFxMuzzleSequence = function(self, muzzle)
		        local army = self.unit:GetArmy()
		        
	            for k, v in self.FxVentEffect3 do
                    CreateAttachedEmitter(self.unit, 'BRNT3BT', army, v):ScaleEmitter(1.5)
                end
  	            for k, v in self.FxMuzzleEffect do
                    CreateAttachedEmitter(self.unit, 'stikkflamme', army, v):ScaleEmitter(2.25)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'vent01', army, v):ScaleEmitter(1.4)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'vent02', army, v):ScaleEmitter(1.4)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'vent03', army, v):ScaleEmitter(1.4)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'vent04', army, v):ScaleEmitter(1.4)
                end
  	            for k, v in self.FxVentEffect2 do
                    CreateAttachedEmitter(self.unit, 'stikkflamme', army, v):ScaleEmitter(1.15)
                end
  	            for k, v in self.FxVentEffect4 do
                    CreateAttachedEmitter(self.unit, 'smoke01', army, v):ScaleEmitter(0.4)
                end
  	            for k, v in self.FxVentEffect4 do
                    CreateAttachedEmitter(self.unit, 'smoke02', army, v):ScaleEmitter(0.4)
                end
            end, 
	},
        DeathWeapon = Class(TIFCommanderDeathWeapon) {
        },
        commanderw = Class(TDFMachineGunWeapon) {
	},
        rocket = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.25,
	},
        rocket2 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.25,
	},
        rocket3 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.25,
	},
        rocket4 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.25,
	},
    },
OnStopBeingBuilt = function(self,builder,layer)
        TLandUnit.OnStopBeingBuilt(self,builder,layer)
      
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack', false)
      else
         self:SetWeaponEnabledByLabel('autoattack', true)
      end      
    end,
}

TypeClass = BRNT3BT0