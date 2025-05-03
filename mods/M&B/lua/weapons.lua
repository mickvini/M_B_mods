local WeaponsFile = import('/lua/sim/DefaultWeapons.lua')
local DefaultBeamWeapon = WeaponsFile.DefaultBeamWeapon
local BareBonesWeapon = WeaponsFile.BareBonesWeapon
local DefaultProjectileWeapon = WeaponsFile.DefaultProjectileWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Beams = import('/mods/M&B/lua/collisionbeams.lua')
local ModEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')

NapalmMissileProjectile = Class(DefaultProjectileWeapon) {
    #FxMuzzleFlash = EffectTemplate.TAAMissileLaunchNoBackSmoke,

    CreateProjectileForWeapon = function(self, bone)
        local projectile = self:CreateProjectile(bone)
        local damageTable = self:GetDamageTable()
        local blueprint = self:GetBlueprint()
        local data = {
            Instigator = self.unit,
            Damage = blueprint.DoTDamage,
            Duration = blueprint.DoTDuration,
            Frequency = blueprint.DoTFrequency,
            Radius = blueprint.DamageRadius,
            Type = 'Normal',
            DamageFriendly = blueprint.DamageFriendly,
        }
        if projectile and not projectile:BeenDestroyed() then
            projectile:PassData(data)
            projectile:PassDamageData(damageTable)
        end
        return projectile
    end,

}

Over_ChargeProjectile = Class(DefaultProjectileWeapon) {}

Rapid_PlasmaProjectile = Class(DefaultProjectileWeapon) {}

ADFAlchemistPhason2 = Class(DefaultBeamWeapon) {
    BeamType = Beams.AlchemistPhasonLaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}
ADFAlchemistPhasonLaser = Class(DefaultBeamWeapon) {
    BeamType = Beams.AlchemistPhasonLaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}
TDFIonizedPlasmaCannon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TIonizedPlasmaGatlingCannonMuzzleFlash, 
}

AIFMissileArrowWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = { '/effects/emitters/aeon_missile_launch_02_emit.bp', },
}

ALaserPhalanxWeapon = Class(DefaultProjectileWeapon) {
    #(4th Dimension Custom Projectile)
    FxMuzzleFlash = {
        '/effects/emitters/flash_04_emit.bp',
    },
}

xsl0310a_LightningWeapon = Class(DefaultBeamWeapon) {
    BeamType = Beams.xsl0310a_LightningBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {}, 
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 0.75,
}

EnergyStorageVariableDeathWeapon = Class(BareBonesWeapon) {
	FxDeath = EffectTemplate.ExplosionEffectsLrg02,

    OnCreate = function(self)
        BareBonesWeapon.OnCreate(self)
        self:SetWeaponEnabled(false)
    end,
    
    OnFire = function(self)
    end,

    Fire = function(self)
		local army = self.unit:GetArmy()
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,army,v)
        end
		local myBlueprint = self:GetBlueprint()
        DamageArea(self.unit, self.unit:GetPosition(), myBlueprint.DamageRadius + (self.DamageRadiusMod or 0), myBlueprint.Damage + (self.DamageMod or 0), myBlueprint.DamageType or 'Normal', myBlueprint.DamageFriendly or false)
    end,
}
BalrogMagmaCannonWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = ModEffectTemplate.TMagmaCannonMuzzleFlash,
    FxMuzzleFlashScale = 1.25,
}
TMAmizurabluelaserweapon = Class(DefaultBeamWeapon) {
    BeamType = Beams.TMMizuraBlueLaserBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 1,
}
BFGShellWeapon = Class(DefaultProjectileWeapon) {
    --(4th Dimension Custom Projectile)
    FxChargeMuzzleFlash = {  
        '/effects/emitters/aeon_sonance_muzzle_01_emit.bp',
        '/effects/emitters/aeon_sonance_muzzle_02_emit.bp',
        '/effects/emitters/aeon_sonance_muzzle_03_emit.bp',
    },
    FxMuzzleFlashScale = 2.0,
}