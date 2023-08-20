#****************************************************************************
#**
#**  File     :  /cdimage/units/MST0019/MST0019_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local SDFAireauBolterWeapon = import('/lua/seraphimweapons.lua').SDFAireauBolterWeapon02
local EffectTemplate = import('/lua/EffectTemplates.lua')

MST0019 = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(SDFAireauBolterWeapon) {
			            FxMuzzleFlashScale = 2.4, 
	},
    },
OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateRotator(self, 'Pod01', 'y', nil, 150, 0, 0))
        self.Trash:Add(CreateRotator(self, 'Pod02', 'y', nil, 250, 0, 0))
              self:CreatTheEffects()   
    end,

OnKilled = function(self,builder,layer)
        TStructureUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffects = function(self)
	local army =  self:GetArmy()
	for k, v in EffectTemplate['OthuyAmbientEmanation'] do
		CreateAttachedEmitter(self, 'eff02', army, v):ScaleEmitter(0.06)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff01', army, v):ScaleEmitter(0.28)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff011', army, v):ScaleEmitter(0.28)
	end
	for k, v in EffectTemplate['OthuyAmbientEmanation'] do
		CreateAttachedEmitter(self, 'eff03', army, v):ScaleEmitter(0.06)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff04', army, v):ScaleEmitter(0.12)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff044', army, v):ScaleEmitter(0.12)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff05', army, v):ScaleEmitter(0.12)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'eff055', army, v):ScaleEmitter(0.12)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'Muzzle01', army, v):ScaleEmitter(0.10)
	end
	for k, v in EffectTemplate['SDFSinnutheWeaponFXTrails01'] do
		CreateAttachedEmitter(self, 'Muzzle011', army, v):ScaleEmitter(0.10)
	end
end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in EffectTemplate['SZthuthaamArtilleryHit'] do
		CreateAttachedEmitter(self, 'BRPT1EXPD', army, v):ScaleEmitter(2.85)
	end
end,
}

TypeClass = MST0019