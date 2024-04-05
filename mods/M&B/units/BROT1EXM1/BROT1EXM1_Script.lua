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
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local TDFHeavyPlasmaCannonWeapon = WeaponsFile.TDFHeavyPlasmaGatlingCannonWeapon
local TDFRiotWeapon = WeaponsFile.TDFRiotWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TMEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local TIFCommanderDeathWeapon = WeaponsFile.TIFCommanderDeathWeapon
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon

BROT1EXM1 = Class(CWalkingLandUnit) {

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
	        FxMuzzleEffect = EffectTemplate.ADisruptorCannonMuzzle01,
	        FxCoolDownEffect = EffectTemplate.CDisruptorCoolDownEffect,     
	        PlayFxMuzzleSequence = function(self, muzzle)
		        local army = self.unit:GetArmy()
		        
  	            for k, v in self.FxMuzzleEffect do
                    CreateAttachedEmitter(self.unit, 'stikkflamme', army, v):ScaleEmitter(1.45)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'vent01', army, v):ScaleEmitter(0.5)
                end
  	            for k, v in self.FxVentEffect do
                    CreateAttachedEmitter(self.unit, 'vent02', army, v):ScaleEmitter(0.5)
                end
  	            for k, v in self.FxVentEffect2 do
                    CreateAttachedEmitter(self.unit, 'stikkflamme', army, v):ScaleEmitter(1)
                end
            end,                   
        },
        Riotgun = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank,
			            FxMuzzleFlashScale = 0.75, 
        },
        rocket = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.5,
	},
        DeathWeapon = Class(TIFCommanderDeathWeapon) {
	},
        DeathWeapon2 = Class(TDFGaussCannonWeapon) {
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
	for k, v in TMEffectTemplate['AeonUnitDeathRing02'] do
		CreateAttachedEmitter(self, 'BROT1EXM1', army, v):ScaleEmitter(0.55)
	end
end,
}

TypeClass = BROT1EXM1