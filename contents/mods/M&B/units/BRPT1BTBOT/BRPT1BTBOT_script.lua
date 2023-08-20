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
local SAAOlarisCannonWeapon = SeraphimWeapons.SAAOlarisCannonWeapon
local SDFThauCannon = SeraphimWeapons.SDFThauCannon
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local SAAOlarisCannonWeapon = import('/lua/seraphimweapons.lua').SAAOlarisCannonWeapon
local SDFChronotronCannonWeapon = SeraphimWeapons.SDFChronotronCannonWeapon

BRPT1BTBOT = Class( SWalkingLandUnit ) {
    Weapons = {
            autoattack = Class(SAAOlarisCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
        AAGun = Class(SAAOlarisCannonWeapon) {},
        MainTurret = Class(SDFThauCannon) {},
        ChronotronCannon = Class(SDFChronotronCannonWeapon) {},
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
	for k, v in EffectTemplate['OthuyAmbientEmanation'] do
		CreateAttachedEmitter(self, 'eff02', army, v):ScaleEmitter(0.08)
	end
	for k, v in EffectTemplate['OthuyAmbientEmanation'] do
		CreateAttachedEmitter(self, 'eff01', army, v):ScaleEmitter(0.08)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff03', army, v):ScaleEmitter(0.28)
	end
end,

OnKilled = function(self,builder,layer)
        SWalkingLandUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in EffectTemplate['SDFExperimentalPhasonProjHit01'] do
		CreateAttachedEmitter(self, 'BRPT1BTBOT', army, v):ScaleEmitter(2.3)
	end
end,
}

TypeClass = BRPT1BTBOT