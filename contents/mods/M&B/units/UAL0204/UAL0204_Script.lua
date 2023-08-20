#****************************************************************************
#**
#**  File     :  /units/UAL0204/UAL0204_script.lua
#**  Author(s):  Optimus Prime
#**
#**  Summary  :  Aeon Sniper Bot
#**
#****************************************************************************

local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit
local SniperWeapon = import('/lua/aeonweapons.lua').ADFDisruptorCannonWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')
local Effects = import('/lua/effecttemplates.lua')

UAL0204 = Class(AWalkingLandUnit) {
    
    Weapons = {
        Sniper_Rifle = Class(SniperWeapon) {
            #FxMuzzleScale = 1.0,

            #PlayFxRackSalvoChargeSequence = function(self)
            #    CreateAttachedEmitter( self.unit, 'sniper_muzzle', self.unit:GetArmy(), '/effects/emitters/temporal_fizz_muzzle_charge_02_emit.bp')
            #    SniperWeapon.PlayFxRackSalvoChargeSequence(self)
            #end, 

            PlayFxRackSalvoReloadSequence = function(self)
                local exhaustEffects = EffectUtil.CreateBoneEffects( self.unit, 'sniper_rifle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                SniperWeapon.PlayFxRackSalvoReloadSequence(self)
            end,
        },
    },    
}

TypeClass = UAL0204