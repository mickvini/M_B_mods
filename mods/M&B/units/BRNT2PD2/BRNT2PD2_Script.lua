#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  BRN Scavenger Medium Tank
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local TMEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local TMMMEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')

BRNT2PD2 = Class(TStructureUnit) {

    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
				IdleState = State (TDFGaussCannonWeapon.IdleState) {
                Main = function(self)
                    TDFGaussCannonWeapon.IdleState.Main(self)
                end,
                
                OnGotTarget = function(self)
						if not self.SpinManip01 then 
							self.SpinManip01 = CreateRotator(self.unit, 'Spinner', 'z', nil, 750, 750, 750)
							self.unit.Trash:Add(self.SpinManip01)
							self.SpinManip01:SetTargetSpeed(550)
						end	
						TDFGaussCannonWeapon.OnGotTarget(self)
                end,
					OnFire = function(self)
						TDFGaussCannonWeapon.IdleState.OnFire(self)
						if self.SpinManip01 then
						self.SpinManip01:SetTargetSpeed(550)
						end	
                end,                
            },
                  
            OnLostTarget = function(self)
                if self.SpinManip01 then
					self.SpinManip01:SetTargetSpeed(0)
				end	

                TDFGaussCannonWeapon.OnLostTarget(self)
            end,  
        },
    },

OnKilled = function(self,builder,layer)
        TStructureUnit.OnKilled(self,builder,layer)
        self:CreatTheEffectsDeath()  
    end,

CreatTheEffectsDeath = function(self)
	local army =  self:GetArmy()
	for k, v in TMEffectTemplate['UEFDeath02'] do
		CreateAttachedEmitter(self, 'Turret', army, v):ScaleEmitter(1.05)
	end
end,
}

TypeClass = BRNT2PD2