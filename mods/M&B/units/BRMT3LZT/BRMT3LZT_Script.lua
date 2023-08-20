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
local CWeapons = import('/lua/cybranweapons.lua')
local CDFHeavyDisintegratorWeapon = CWeapons.CDFHeavyDisintegratorWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon
local ModEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')

BRMT3LZT = Class(TLandUnit) {

    Weapons = {
        autoattack = Class(AutoAttackWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
        MainGun = Class(CDFHeavyDisintegratorWeapon) {},
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
CreatTheEffects = function(self)
	local army =  self:GetArmy()
	for k, v in ModEffectTemplate['BRMT3EXBMPOWEREFFECT'] do
		CreateAttachedEmitter(self, 'effect01', army, v):ScaleEmitter(1.10)
	end
    end,
}

TypeClass = BRMT3LZT