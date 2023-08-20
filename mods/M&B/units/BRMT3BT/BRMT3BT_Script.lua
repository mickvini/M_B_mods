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
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon

BRMT3BT = Class(TLandUnit) {

    Weapons = {
        autoattack = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
        MainGun = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 2.1,
            FxMuzzleFlash = { 
            	'/effects/emitters/proton_artillery_muzzle_01_emit.bp',
            	'/effects/emitters/proton_artillery_muzzle_03_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_smoke_01_emit.bp',                                
            }, 
	    FxGroundEffect = EffectTemplate.ConcussionRingLrg01,
	        FxVentEffect3 = EffectTemplate.CDisruptorGroundEffect,
	        FxVentEffect = EffectTemplate.CDisruptorVentEffect,
	        FxVentEffect2 = EffectTemplate.WeaponSteam01,
	        FxVentEffect4 = EffectTemplate.CHvyProtonCannonHitUnit01,
	        FxVentEffect5 = EffectTemplate.CElectronBolterMuzzleFlash01,
	        FxMuzzleEffect = EffectTemplate.CElectronBolterMuzzleFlash01,
	        FxCoolDownEffect = EffectTemplate.CDisruptorCoolDownEffect,     
	        PlayFxMuzzleSequence = function(self, muzzle)
		        local army = self.unit:GetArmy()
		        
	            for k, v in self.FxVentEffect3 do
                    CreateAttachedEmitter(self.unit, 'BRMT3BT', army, v):ScaleEmitter(1.5)
                end
  	            for k, v in self.FxMuzzleEffect do
                    CreateAttachedEmitter(self.unit, 'stikkflamme', army, v):ScaleEmitter(3.45)
                end
  	            for k, v in self.FxVentEffect5 do
                    CreateAttachedEmitter(self.unit, 'stikkflamme01', army, v):ScaleEmitter(2.0)
                end
  	            for k, v in self.FxVentEffect5 do
                    CreateAttachedEmitter(self.unit, 'stikkflamme02', army, v):ScaleEmitter(2.0)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'vent01', army, v):ScaleEmitter(1.0)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'vent02', army, v):ScaleEmitter(1.0)
                end
  	            for k, v in self.FxVentEffect2 do
                    CreateAttachedEmitter(self.unit, 'stikkflamme', army, v):ScaleEmitter(1)
                end
            end,                   
        },
        DeathWeapon = Class(TIFCommanderDeathWeapon) {
	},
        rocket = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.4,                 
	},
        rocket2 = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.4,
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

OnKilled = function(self,builder,layer)
        TLandUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in ModEffectTemplate['CybranT3BattleTankDeath'] do
		CreateAttachedEmitter(self, 'BRMT3BT', army, v):ScaleEmitter(6.0)
	end
end,
}

TypeClass = BRMT3BT