#****************************************************************************
#**
#**  File     :  /cdimage/lua/modules/BlackOpsweapons.lua
#**  Author(s):  Lt_hawkeye
#**
#**  Summary  :  
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local WeaponFile = import('/lua/sim/defaultweapons.lua')
local RCMFAFBeamFile = import('/mods/M&B/lua/RCMFAFdefaultcollisionbeams.lua')
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local BareBonesWeapon = WeaponFile.BareBonesWeapon

StunZapperWeapon = Class(DefaultBeamWeapon) {
    BeamType = RCMFAFBeamFile.EMCHPRFDisruptorBeam,
    FxMuzzleFlash = {'/effects/emitters/cannon_muzzle_flash_01_emit.bp',},
    FxMuzzleFlashScale = 2,
}

xsl0310a_LightningWeapon = Class(DefaultBeamWeapon) {
    BeamType = RCMFAFBeamFile.xsl0310a_LightningBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {}, 
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 0.75,
}

TMAnovacatgreenlaserweapon = Class(DefaultBeamWeapon) {
    BeamType = RCMFAFBeamFile.TMNovaCatGreenLaserBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = EffectTemplate.SDFExperimentalPhasonProjChargeMuzzleFlash,
    FxUpackingChargeEffects = EffectTemplate.SDFExperimentalPhasonProjChargeMuzzleFlash,
    FxUpackingChargeEffectScale = 1,
}

EXCEMPArrayBeam01 = Class(DefaultBeamWeapon) {
    BeamType = RCMFAFBeamFile.EXCEMPArrayBeam01CollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
}
DeathWeapon = Class(BareBonesWeapon) {
    OnCreate = function(self)
        BareBonesWeapon.OnCreate(self)

        local myBlueprint = self:GetBlueprint()
        # The "or x" is supplying default values in case the blueprint doesn't have an overriding value
        self.Data = {
            NukeOuterRingDamage = myBlueprint.NukeOuterRingDamage or 10,
            NukeOuterRingRadius = myBlueprint.NukeOuterRingRadius or 40,
            NukeOuterRingTicks = myBlueprint.NukeOuterRingTicks or 20,
            NukeOuterRingTotalTime = myBlueprint.NukeOuterRingTotalTime or 10,

            NukeInnerRingDamage = myBlueprint.NukeInnerRingDamage or 2000,
            NukeInnerRingRadius = myBlueprint.NukeInnerRingRadius or 30,
            NukeInnerRingTicks = myBlueprint.NukeInnerRingTicks or 24,
            NukeInnerRingTotalTime = myBlueprint.NukeInnerRingTotalTime or 24,
        }
    end,


    OnFire = function(self)
    end,

    Fire = function(self)
        local myBlueprint = self:GetBlueprint()
        local myProjectile = self.unit:CreateProjectile( myBlueprint.ProjectileId, 0, 0, 0, nil, nil, nil):SetCollision(false)
        myProjectile:PassDamageData(self:GetDamageTable())
        if self.Data then
            myProjectile:PassData(self.Data)
        end
    end,
}