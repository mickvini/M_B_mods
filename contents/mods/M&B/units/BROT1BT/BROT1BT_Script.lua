#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  BRN Tiger Light Tank
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AHoverLandUnit = import('/lua/aeonunits.lua').AHoverLandUnit
local AWeapons = import('/lua/aeonweapons.lua')
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local AAASonicPulseBatteryWeapon = AWeapons.AAASonicPulseBatteryWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local TDFMachineGunWeapon = WeaponsFile.TDFMachineGunWeapon
local TDFHeavyPlasmaCannonWeapon = WeaponsFile.TDFHeavyPlasmaGatlingCannonWeapon
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon

BROT1BTT2 = Class(AHoverLandUnit) {
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
	        FxMuzzleEffect = EffectTemplate.AIFBallisticMortarFlash02,
	        FxCoolDownEffect = EffectTemplate.CDisruptorCoolDownEffect,     
	        PlayFxMuzzleSequence = function(self, muzzle)
		        local army = self.unit:GetArmy()
		        
	            for k, v in self.FxVentEffect3 do
                    CreateAttachedEmitter(self.unit, 'BROT1BT', army, v):ScaleEmitter(0.7)
                end
  	            for k, v in self.FxMuzzleEffect do
                    CreateAttachedEmitter(self.unit, 'Turret_Muzzle01', army, v):ScaleEmitter(1.4)
                end
  	            for k, v in self.FxMuzzleEffect do
                    CreateAttachedEmitter(self.unit, 'Turret_Muzzle02', army, v):ScaleEmitter(1.4)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'vent01', army, v):ScaleEmitter(0.7)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'vent02', army, v):ScaleEmitter(0.7)
                end
  	            for k, v in self.FxVentEffect2 do
                    CreateAttachedEmitter(self.unit, 'aim', army, v):ScaleEmitter(1.1)
                end
            end, 
        },
        clawgun = Class(TDFHeavyPlasmaCannonWeapon) {
            FxMuzzleFlashScale = 0.4,
        },
    },
OnStopBeingBuilt = function(self,builder,layer)
        AHoverLandUnit.OnStopBeingBuilt(self,builder,layer)
      
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack', false)
      else
         self:SetWeaponEnabledByLabel('autoattack', true)
      end      
    end,

OnKilled = function(self,builder,layer)
        AHoverLandUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in ModEffectTemplate['AeonBattleShipHit01'] do
		CreateAttachedEmitter(self, 'BROT1BT', army, v):ScaleEmitter(0.65)
	end
end,
}

TypeClass = BROT1BTT2