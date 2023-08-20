local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local TIFCommanderDeathWeapon = import('/lua/terranweapons.lua').TIFCommanderDeathWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')


UEB2310 = Class(TStructureUnit) {

    FxAirUnitHitScale = 1.5,
    FxLandHitScale = 1.5,
    FxNoneHitScale = 1.5,
    FxPropHitScale = 1.5,
    FxProjectileHitScale = 1.5,
    FxProjectileUnderWaterHitScale = 1.5,
    FxShieldHitScale = 1.5,
    FxUnderWaterHitScale = 1.5,
    FxUnitHitScale = 1.5,
    FxWaterHitScale = 1.5,
    FxOnKilledScale = 1.5,

    Weapons = {
        DeathWeapon = Class(TIFCommanderDeathWeapon) {},
        MainGun = Class(TDFGaussCannonWeapon) {
            FxMuzzleFlashScale = 3,
        }
    },
}

TypeClass = UEB2310