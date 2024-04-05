#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  BRN Scavenger Medium Tank
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TWalkingLandUnit = import('/lua/terranunits.lua').TWalkingLandUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local SWeapons = import ('/lua/seraphimweapons.lua')
local TAAGinsuRapidPulseWeapon = WeaponsFile.TAAGinsuRapidPulseWeapon
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local TIFCommanderDeathWeapon = WeaponsFile.TIFCommanderDeathWeapon
local SDFSinnuntheWeapon = SWeapons.SDFSinnuntheWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local TMEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')

BRNT1ADVBOT = Class(TWalkingLandUnit) {

    Weapons = {        
        rocket = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 0.2,                 
	    },
        autoattack = Class(TDFGaussCannonWeapon) {
			FxMuzzleFlashScale = 0.0, 
	    },        
        DeathWeapon = Class(TIFCommanderDeathWeapon) {
            FxScale = 0.5,
        },        
        BigGun1 = Class(TDFGaussCannonWeapon) {
			FxMuzzleFlashScale = 2.2, 
            FxMuzzleFlash = EffectTemplate.OhCannonMuzzleFlash02,
	   },
    },
OnStopBeingBuilt = function(self,builder,layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
      
      if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
         self:SetWeaponEnabledByLabel('autoattack', false)
      else
         self:SetWeaponEnabledByLabel('autoattack', true)
      end      
    end,
}

TypeClass = BRNT1ADVBOT