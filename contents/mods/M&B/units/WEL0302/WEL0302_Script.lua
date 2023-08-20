local TWalkingLandUnit = import('/lua/terranunits.lua').TWalkingLandUnit
local TWeapons = import('/lua/terranweapons.lua')
local TDFHeavyPlasmaCannonWeapon = TWeapons.TDFHeavyPlasmaCannonWeapon
local TIFFragLauncherWeapon = TWeapons.TDFFragmentationGrenadeLauncherWeapon
local TDFLightPlasmaCannonWeapon = import('/lua/terranweapons.lua').TDFLightPlasmaCannonWeapon

local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

WEL0302 = Class(TWalkingLandUnit) 
{
    Weapons = {
        GatlingCannon = Class(TDFHeavyPlasmaCannonWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
				if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Right_Arm_Barrel_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
		self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Left_Arm_Barrel_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFHeavyPlasmaCannonWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'RightArmBarrel', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                if not self.SpinManip2 then 
                    self.SpinManip2 = CreateRotator(self.unit, 'LeftArmBarrel', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip2)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(800)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(800)
                end
                TDFHeavyPlasmaCannonWeapon.PlayFxWeaponUnpackSequence(self)
            end,  
			
        },
        MainGun = Class(TDFLightPlasmaCannonWeapon)
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Right_Arm_Barrel_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFLightPlasmaCannonWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'AABarrel', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(800)
                end
                TDFLightPlasmaCannonWeapon.PlayFxWeaponUnpackSequence(self)
            end,  
			
        },
        
    },
}

TypeClass = WEL0302