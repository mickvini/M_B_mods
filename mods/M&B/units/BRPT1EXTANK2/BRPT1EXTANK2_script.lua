#****************************************************************************
#**
#**  File     :  /cdimage/units/XAL0104/XAL0104_script.lua
#**  Author(s):  Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Seraphim Mobile Anti-Air Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SDFHeavyQuarnonCannon = SeraphimWeapons.SDFHeavyQuarnonCannon
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local ModEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')

BRPT1EXTANK2 = Class(SWalkingLandUnit) {
    Weapons = {
        BackTurret = Class(SDFHeavyQuarnonCannon) {
			            FxMuzzleFlashScale = 2.0, 
	},
        autoattack = Class(AutoAttackWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
    },
OnStopBeingBuilt = function(self,builder,layer)
        SWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:CreatTheEffects()
        self.Trash:Add(CreateRotator(self, 'Object05', 'y', nil, 350, 0, 0))
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack', false)
      else
         self:SetWeaponEnabledByLabel('autoattack', true)
      end      
    end,

CreatTheEffects = function(self)
	local army =  self:GetArmy()
	for k, v in EffectTemplate['SeraphimAirStagePlat01'] do
		CreateAttachedEmitter(self, 'rl01', army, v):ScaleEmitter(0.8)
	end
	for k, v in EffectTemplate['SeraphimAirStagePlat01'] do
		CreateAttachedEmitter(self, 'rl01', army, v):ScaleEmitter(0.8)
	end
	for k, v in EffectTemplate['SeraphimAirStagePlat01'] do
		CreateAttachedEmitter(self, 'rl01', army, v):ScaleEmitter(0.8)
	end
	for k, v in EffectTemplate['UpgradeUnitAmbient'] do
		CreateAttachedEmitter(self, 'rl01', army, v):ScaleEmitter(0.5)
	end
	for k, v in EffectTemplate['SeraphimAirStagePlat01'] do
		CreateAttachedEmitter(self, 'rl01', army, v):ScaleEmitter(1.3)
	end
	for k, v in EffectTemplate['SeraphimAirStagePlat01'] do
		CreateAttachedEmitter(self, 'Turret_Barrel_Muzzle01', army, v):ScaleEmitter(1.6)
	end
	for k, v in EffectTemplate['SeraphimAirStagePlat01'] do
		CreateAttachedEmitter(self, 'Turret_Barrel_Muzzle', army, v):ScaleEmitter(1.6)
	end
end,

OnKilled = function(self,builder,layer)
        SWalkingLandUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in ModEffectTemplate['SerT1AdvancedTankHit01'] do
		CreateAttachedEmitter(self, 'BRPT1EXTANK2', army, v):ScaleEmitter(2.7)
	end
end,
}
TypeClass = BRPT1EXTANK2