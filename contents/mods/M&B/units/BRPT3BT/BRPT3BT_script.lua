#****************************************************************************
#**
#**  File     :  /cdimage/units/XAL0104/XAL0104_script.lua
#**  Author(s):  Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Seraphim Mobile Anti-Air Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SLandUnit = import('/lua/seraphimunits.lua').SLandUnit
local SDFOhCannon = import('/lua/seraphimweapons.lua').SDFOhCannon
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon
local SDFHeavyQuarnonCannon = SeraphimWeapons.SDFHeavyQuarnonCannon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')

BRPT3BT = Class(SLandUnit) {
    Weapons = {
        TauCannon01 = Class(SDFOhCannon){
			FxMuzzleFlashScale = 1.5,
        },
        FrontTurret = Class(SDFHeavyQuarnonCannon) {
			FxMuzzleFlashScale = 0.5,
	},
        autoattack = Class(AutoAttackWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
    },
OnStopBeingBuilt = function(self,builder,layer)
        SLandUnit.OnStopBeingBuilt(self,builder,layer)
              self:CreatTheEffects()   
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack', false)
      else
         self:SetWeaponEnabledByLabel('autoattack', true)
      end      
    end,

CreatTheEffects = function(self)
	local army =  self:GetArmy()
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'muzzle', army, v):ScaleEmitter(0.15)
	end
	for k, v in EffectTemplate['OthuyAmbientEmanation'] do
		CreateAttachedEmitter(self, 'Turret', army, v):ScaleEmitter(0.08)
	end
end,

OnKilled = function(self,builder,layer)
        SLandUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in EffectTemplate['SDFExperimentalPhasonProjHit01'] do
		CreateAttachedEmitter(self, 'BRPT3BT', army, v):ScaleEmitter(0.7)
	end
end,
}
TypeClass = BRPT3BT