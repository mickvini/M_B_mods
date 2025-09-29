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
local WeaponsFile = import('/lua/cybranweapons.lua')
local WeaponsFile2 = import('/lua/terranweapons.lua')
local TMWeaponsFile = import('/mods/M&B/lua/weapons.lua')
local CDFElectronBolterWeapon = WeaponsFile.CDFElectronBolterWeapon
local TMCSpiderLaserweapon = TMWeaponsFile.TMCSpiderLaserweapon
local TDFRiotWeapon = WeaponsFile2.TDFRiotWeapon
local CCannonMolecularWeapon = WeaponsFile.CCannonMolecularWeapon
local TIFCommanderDeathWeapon = WeaponsFile2.TIFCommanderDeathWeapon
local TDFGaussCannonWeapon = WeaponsFile2.TDFLandGaussCannonWeapon
local TMEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')

BRMT3SNAKE = Class(CWalkingLandUnit) {

    Weapons = {
        main = Class(TMCSpiderLaserweapon) {
    FxMuzzleFlash = EffectTemplate.SDFExperimentalPhasonProjChargeMuzzleFlash,
			            FxMuzzleFlashScale = 1.0, 
	},
        MainGun = Class(CDFElectronBolterWeapon) {
			            FxMuzzleFlashScale = 1.0, 
	},
		MainGun2 = Class(CDFElectronBolterWeapon) {
			            FxMuzzleFlashScale = 1.0, 
	},
        HeavyBoltera = Class(CDFElectronBolterWeapon) {
	},
        RightAntiAirMissile = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.7,
	},
        DeathWeapon = Class(TIFCommanderDeathWeapon) {
	},
    },
OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateRotator(self, 'Object04', 'z', nil, 650, 0, 0))      
        self.Trash:Add(CreateRotator(self, 'Object03', 'z', nil, -650, 0, 0))     
        self:CreatTheEffects()

      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('robottalk', false)
      else
         self:SetWeaponEnabledByLabel('robottalk', true)
      end      
    end,

CreatTheEffects = function(self)
	local army =  self:GetArmy()
	for k, v in TMEffectTemplate['BRMT3EXBMPOWEREFFECT'] do
		CreateAttachedEmitter(self, 'Object04', army, v):ScaleEmitter(3.00)
	end
	for k, v in TMEffectTemplate['BRMT3EXBMPOWEREFFECT'] do
		CreateAttachedEmitter(self, 'Object03', army, v):ScaleEmitter(3.00)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'Object04', army, v):ScaleEmitter(0.5)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'Object03', army, v):ScaleEmitter(0.5)
	end
	for k, v in EffectTemplate['OthuyAmbientEmanation'] do
		CreateAttachedEmitter(self, 'Object04', army, v):ScaleEmitter(0.1)
	end
	for k, v in EffectTemplate['OthuyAmbientEmanation'] do
		CreateAttachedEmitter(self, 'Object03', army, v):ScaleEmitter(0.1)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff01', army, v):ScaleEmitter(0.3)
	end

	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff03', army, v):ScaleEmitter(0.3)
	end

end,

OnKilled = function(self,builder,layer)
        CWalkingLandUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in TMEffectTemplate['MadCatDeath01'] do
		CreateAttachedEmitter(self, 'Turret', army, v):ScaleEmitter(1.5)
	end
end,
}

TypeClass = BRMT3SNAKE