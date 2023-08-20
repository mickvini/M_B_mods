#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0203/UAA0203_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Gunship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local AeonWeapons = import('/lua/aeonweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local AAAZealotMissileWeapon = AeonWeapons.AAAZealotMissileWeapon
local TMEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')

BRNAT1EXGS = Class(AAirUnit) {
    Weapons = {
        autoattack = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
        mediumgauss1 = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 1.0, 
	},
        mediumgauss2 = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 1.0, 
	},
        biggauss1 = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 6.0, 
            FxMuzzleFlash = EffectTemplate.TFlakCannonMuzzleFlash01,
	},
        smallerguns1 = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 1, 
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank,
	},
        smallerguns2 = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 1, 
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank,
	},
        rockets = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.25,
	},
    },





    MovementAmbientExhaustBones = {
                            'ex01',
                            'ex02',
                            'ex03',
                            'ex04',
    },

    DestructionPartsChassisToss = {'BRNAT1EXGS',},
    DestroyNoFallRandomChance = 1.1,





OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)









        self.Trash:Add(CreateRotator(self, 'Object13', 'y', nil, -750, 0, 0))

              self:CreatTheEffects()


      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack', false)
      else
         self:SetWeaponEnabledByLabel('autoattack', true)
      end      
    end,




    OnMotionHorzEventChange = function(self, new, old )
		AAirUnit.OnMotionHorzEventChange(self, new, old)
	
		if self.ThrustExhaustTT1 == nil then 
			if self.MovementAmbientExhaustEffectsBag then
				fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
			else
				self.MovementAmbientExhaustEffectsBag = {}
			end
			self.ThrustExhaustTT1 = self:ForkThread(self.MovementAmbientExhaustThread)
		end
		
        if new == 'Stopped' and self.ThrustExhaustTT1 != nil then
			KillThread(self.ThrustExhaustTT1)
			fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
			self.ThrustExhaustTT1 = nil
        end		 
    end,
    
    MovementAmbientExhaustThread = function(self)
		while not self:IsDead() do
			local ExhaustEffects = {
				'/effects/emitters/dirty_exhaust_smoke_01_emit.bp',
				'/effects/emitters/dirty_exhaust_sparks_01_emit.bp',			
			}
			local ExhaustBeam = '/effects/emitters/missile_exhaust_fire_beam_03_emit.bp'
			local army = self:GetArmy()			
			
			for kE, vE in ExhaustEffects do
				for kB, vB in self.MovementAmbientExhaustBones do
					table.insert( self.MovementAmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE ))
					table.insert( self.MovementAmbientExhaustEffectsBag, CreateBeamEmitterOnEntity( self, vB, army, ExhaustBeam ))
				end
			end
			
			WaitSeconds(2)
			fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
							
			WaitSeconds(util.GetRandomFloat(1,7))
		end	
    end,








CreatTheEffects = function(self)
	local army =  self:GetArmy()
	for k, v in EffectTemplate['SeraphimAirStagePlat01'] do
		CreateAttachedEmitter(self, 'eff03', army, v):ScaleEmitter(1.5)
	end
	for k, v in EffectTemplate['SeraphimAirStagePlat01'] do
		CreateAttachedEmitter(self, 'eff01', army, v):ScaleEmitter(1.3)
	end
	for k, v in EffectTemplate['SeraphimAirStagePlat01'] do
		CreateAttachedEmitter(self, 'eff02', army, v):ScaleEmitter(1.3)
	end
end,


OnKilled = function(self,builder,layer)
        AAirUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in TMEffectTemplate['UEFDeath02'] do
		CreateAttachedEmitter(self, 'BRNAT1EXGS', army, v):ScaleEmitter(1.25)
	end
end,
}

TypeClass = BRNAT1EXGS