#**************************************************************************** 
#** 
#** File : Ual0310_script.lua 
#** Author(s): Ebola Soup (modeler / texturing / animation), Resin_Smoker (scripter / effects / weapons)
#** 
#** Summary : Aeon Heavy Mobile Defense Unit
#** 
#** Copyright © 2008, 4th Dimension 
#**************************************************************************** 

### Misc files
local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit 
local CustomAeonWeapons = import('/mods/m&b/lua/weapons.lua')
local EffectUtils = import('/lua/EffectUtilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local AAAZealotMissileWeapon = import('/lua/aeonweapons.lua').AAAZealotMissileWeapon

### Local weapons 
local AIFMissileArrowWeapon = CustomAeonWeapons.AIFMissileArrowWeapon
local ALaserPhalanxWeapon = CustomAeonWeapons.ALaserPhalanxWeapon

ual0310 = Class(AWalkingLandUnit) { 

   Weapons = {
       HatchMissile = Class(AIFMissileArrowWeapon) {

            OnWeaponFired = function(self) 
                AIFMissileArrowWeapon.OnWeaponFired(self) 
                ### Hides the missile bones after the unit has fired 
                self.unit:HideBone('LargeSAM', false)
            end, 

            PlayFxRackSalvoReloadSequence = function(self)
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'LargeSAM', self.unit:GetArmy(), Effects.WeaponSteam01 )
                ### Unhides the missile bones so the player can see the missile reload 
                self.unit:ShowBone('LargeSAM', false)  
                AIFMissileArrowWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
       },
       MissileSideLeft = Class(AAAZealotMissileWeapon) {},
       MissileSideRight = Class(AAAZealotMissileWeapon) {},
       LaserPhalanx = Class(ALaserPhalanxWeapon) {},
   },
} 

TypeClass = ual0310