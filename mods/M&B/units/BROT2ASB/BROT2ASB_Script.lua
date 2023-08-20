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
local RCMFAFweapons = import('/mods/M&B/lua/RCMFAFweapons.lua')
local ModEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')

local TMAnovacatgreenlaserweapon = RCMFAFweapons.TMAnovacatgreenlaserweapon
local DeathWeapon = RCMFAFweapons.DeathWeapon

BROT2ASB = Class(CWalkingLandUnit) {

    Weapons = {
        DeathWeapon = Class(DeathWeapon) {
	},
        laser = Class(TMAnovacatgreenlaserweapon) {
            FxMuzzleFlashScale = 0.1,
	},  
    },
OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
      
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack', false)
      else
         self:SetWeaponEnabledByLabel('autoattack', true)
      end      
    end,

OnKilled = function(self,builder,layer)
        CWalkingLandUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in ModEffectTemplate['UEFHEAVYROCKET02'] do
		CreateAttachedEmitter(self, 'BROT2ASB', army, v):ScaleEmitter(2.0)
	end
end,
}

TypeClass = BROT2ASB