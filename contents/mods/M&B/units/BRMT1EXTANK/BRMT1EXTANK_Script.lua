#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  BRN Tiger Light Tank
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local CWeapons = import('/lua/cybranweapons.lua')
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local TDFMachineGunWeapon = WeaponsFile.TDFMachineGunWeapon
local CDFHeavyDisintegratorWeapon = CWeapons.CDFHeavyDisintegratorWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon
local TIFCommanderDeathWeapon = WeaponsFile.TIFCommanderDeathWeapon

BRMT1EXTANK = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(CDFHeavyDisintegratorWeapon) {
        },
        autoattack = Class(TDFGaussCannonWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
        DeathWeapon = Class(TIFCommanderDeathWeapon) {
	},
        rocket = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.4,                 
	},
    },
OnStopBeingBuilt = function(self,builder,layer)
        TLandUnit.OnStopBeingBuilt(self,builder,layer)
              self:CreatTheEffects()
      
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

CreatTheEffects = function(self)
	local army =  self:GetArmy()
	for k, v in ModEffectTemplate['BRMT3EXBMPOWEREFFECT'] do
		CreateAttachedEmitter(self, 'eff01', army, v):ScaleEmitter(2.10)
	end
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in ModEffectTemplate['BRMT1EXTANKDEATH'] do
		CreateAttachedEmitter(self, 'BRMT1EXTANK', army, v):ScaleEmitter(4.7)
	end
end,
}

TypeClass = BRMT1EXTANK