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
local aWeapons = import('/lua/aeonweapons.lua')
local AAASonicPulseBatteryWeapon = aWeapons.AAASonicPulseBatteryWeapon
local AAAZealotMissileWeapon = aWeapons.AAAZealotMissileWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local WeaponsFileAutoAttack = import('/lua/terranweapons.lua')
local AutoAttackWeapon = WeaponsFileAutoAttack.TDFLandGaussCannonWeapon

BROT2EXM2 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(AAASonicPulseBatteryWeapon) {
            FxMuzzleFlashScale = 1.7,
            FxMuzzleFlash = EffectTemplate.ASDisruptorCannonMuzzle01,
        },
        Missiles = Class(AAAZealotMissileWeapon) {
	},
        autoattack = Class(AutoAttackWeapon) {
			            FxMuzzleFlashScale = 0.0, 
	},
    },
OnStopBeingBuilt = function(self,builder,layer)
        TLandUnit.OnStopBeingBuilt(self,builder,layer)
      
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

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in ModEffectTemplate['AeonUnitDeathRing03'] do
		CreateAttachedEmitter(self, 'BROT2EXM2', army, v):ScaleEmitter(1.20)
	end
end,
}

TypeClass = BROT2EXM2