#****************************************************************************
#**
#**  File     :  /units/XSLconcept/XSLconcept_script.lua
#**  Author(s):  Drew Staltman, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Seraphim Concept Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local SDFAireauBolterWeapon = SeraphimWeapons.SDFAireauBolterWeapon02
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon
local SDFThauCannon = SeraphimWeapons.SDFThauCannon
local SDFChronotronCannonWeapon = SeraphimWeapons.SDFChronotronCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')

BRPT2HVBOT = Class( SWalkingLandUnit ) {
    Weapons = {
            autoattack = Class(SDFAireauBolterWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
        smallgun1 = Class(SDFAireauBolterWeapon) {
			            FxMuzzleFlashScale = 2.4, 
	},
        smallgun2 = Class(SDFAireauBolterWeapon) {
			            FxMuzzleFlashScale = 2.4, 
	},
        smallgun3 = Class(SDFAireauBolterWeapon) {
			            FxMuzzleFlashScale = 2.4, 
	},
        smallgun4 = Class(SDFAireauBolterWeapon) {
			            FxMuzzleFlashScale = 2.4, 
	},
        ChronotronCannon = Class(SDFChronotronCannonWeapon) {
	},
        ChronotronCannon2 = Class(SDFChronotronCannonWeapon) {
	},
        TauCannon01 = Class(SDFThauCannon){
			FxMuzzleFlashScale = 0.9,
        },
        TauCannon02 = Class(SDFThauCannon){
			FxMuzzleFlashScale = 0.9,
        },
    },
OnStopBeingBuilt = function(self,builder,layer)
        SWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
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
		CreateAttachedEmitter(self, 'aa01', army, v):ScaleEmitter(0.1)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'aa02', army, v):ScaleEmitter(0.1)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'aa03', army, v):ScaleEmitter(0.1)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'aa04', army, v):ScaleEmitter(0.1)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff01', army, v):ScaleEmitter(0.3)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff02', army, v):ScaleEmitter(0.3)
	end
end,

OnKilled = function(self,builder,layer)
        SWalkingLandUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in EffectTemplate['SDFExperimentalPhasonProjHit01'] do
		CreateAttachedEmitter(self, 'BRPT2HVBOT', army, v):ScaleEmitter(2.3)
	end
end,
}

TypeClass = BRPT2HVBOT