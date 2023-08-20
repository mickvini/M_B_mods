#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2304/UEB2304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Advanced AA System Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TAMPhalanxWeapon = WeaponsFile.TAMPhalanxWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Effects = import('/lua/EffectTemplates.lua')
local EffectUtils = import('/lua/effectutilities.lua')

BRNT1EXPDT2 = Class(TStructureUnit) {
    Weapons = {
        gatling1 = Class(TAMPhalanxWeapon) {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Turret_Muzzle_Right02', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TAMPhalanxWeapon.PlayFxWeaponPackSequence(self)
            end,

        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'spinner02', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TAMPhalanxWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Turret_Muzzle_Right02', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TAMPhalanxWeapon.PlayFxRackSalvoChargeSequence(self)
            end, 
                        },
        gatling2 = Class(TAMPhalanxWeapon) {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Turret_Muzzle_Left02', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TAMPhalanxWeapon.PlayFxWeaponPackSequence(self)
            end,

        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'spinner01', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TAMPhalanxWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Turret_Muzzle_Left02', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TAMPhalanxWeapon.PlayFxRackSalvoChargeSequence(self)
            end, 
                        },
            },
}

TypeClass = BRNT1EXPDT2