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
local AWeapons = import('/lua/aeonweapons.lua')
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local ADFDisruptorCannonWeapon = AWeapons.ADFDisruptorCannonWeapon
local AAASonicPulseBatteryWeapon = AWeapons.AAASonicPulseBatteryWeapon
local TIFCommanderDeathWeapon = WeaponsFile.TIFCommanderDeathWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local AIFArtillerySonanceShellWeapon = AWeapons.AIFArtillerySonanceShellWeapon
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon

BROT3BT2 = Class(TLandUnit) {

    Weapons = {
        autoattack = Class(AutoAttackWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
        MainGun = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 4.85,
            FxMuzzleFlash = { 
            	'/effects/emitters/aeon_quanticcluster_muzzle_flash_03_emit.bp',
            	'/effects/emitters/aeon_quanticcluster_muzzle_flash_06_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_smoke_01_emit.bp',                                
            }, 
	    FxGroundEffect = EffectTemplate.ConcussionRingLrg01,
	        FxVentEffect3 = EffectTemplate.CDisruptorGroundEffect,
	        FxVentEffect = EffectTemplate.CDisruptorVentEffect,
	        FxVentEffect2 = EffectTemplate.WeaponSteam01,
	        FxVentEffect4 = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
	        FxMuzzleEffect = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
	        FxCoolDownEffect = EffectTemplate.CDisruptorCoolDownEffect,     
	        PlayFxMuzzleSequence = function(self, muzzle)
		        local army = self.unit:GetArmy()
		        
	            for k, v in self.FxGroundEffect do
                    CreateAttachedEmitter(self.unit, 'BROT3BT2', army, v):ScaleEmitter(2.55)
                end
	            for k, v in self.FxVentEffect3 do
                    CreateAttachedEmitter(self.unit, 'BROT3BT2', army, v):ScaleEmitter(2.1)
                end
  	            for k, v in self.FxMuzzleEffect do
                    CreateAttachedEmitter(self.unit, 'stikkflamme', army, v):ScaleEmitter(1.55)
                end
  	            for k, v in self.FxVentEffect2 do
                    CreateAttachedEmitter(self.unit, 'stikkflamme', army, v):ScaleEmitter(1.65)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'vent02', army, v):ScaleEmitter(1.35)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'vent03', army, v):ScaleEmitter(1.35)
                end
  	            for k, v in self.FxVentEffect4 do
                    CreateAttachedEmitter(self.unit, 'vent01', army, v):ScaleEmitter(0.6)
                end
            end,    
	},
        DeathWeapon = Class(TIFCommanderDeathWeapon) {
        },
        DeathWeapon2 = Class(TIFCommanderDeathWeapon) {
        },
        mgweapon = Class(ADFDisruptorCannonWeapon) {
			            FxMuzzleFlashScale = 1.15,
	},
        rocket = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.45, },
        rocket2 = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.45, },
        mgweapon2 = Class(AAASonicPulseBatteryWeapon) {
			FxMuzzleFlashScale = 1.4,
			FxMuzzleFlash = {'/effects/emitters/sonic_pulse_muzzle_flash_02_emit.bp',},
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
	for k, v in ModEffectTemplate['AeonUnitDeathRing01'] do
		CreateAttachedEmitter(self, 'BROT3BT2', army, v):ScaleEmitter(1.20)
	end
end,
}

TypeClass = BROT3BT2