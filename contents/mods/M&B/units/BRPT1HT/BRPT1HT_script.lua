#****************************************************************************
#**
#**  File     :  /cdimage/units/XAL0104/XAL0104_script.lua
#**  Author(s):  Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Seraphim Mobile Anti-Air Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SHoverLandUnit = import('/lua/seraphimunits.lua').SHoverLandUnit
local SDFOhCannon = import('/lua/seraphimweapons.lua').SDFOhCannon
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')

BRPT1HT = Class(SHoverLandUnit) {
    Weapons = {
        TauCannon01 = Class(SDFOhCannon){
			FxMuzzleFlashScale = 1.5,
        },
        autoattack = Class(AutoAttackWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
    },
OnStopBeingBuilt = function(self,builder,layer)
        SHoverLandUnit.OnStopBeingBuilt(self,builder,layer)
      
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack', false)
      else
         self:SetWeaponEnabledByLabel('autoattack', true)
      end      
    end,

OnKilled = function(self,builder,layer)
        SHoverLandUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in EffectTemplate['SDFExperimentalPhasonProjHit01'] do
		CreateAttachedEmitter(self, 'BRPT1HT', army, v):ScaleEmitter(0.5)
	end
end,
}
TypeClass = BRPT1HT