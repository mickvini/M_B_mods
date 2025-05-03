#
# UEF Rapid Plasma
#

local Rapid_PlasmaProjectile = import('/mods/M&B/lua/projectiles.lua').Rapid_PlasmaProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')

Rapid_Plasma = Class(Rapid_PlasmaProjectile) {
    FxImpactLand = EffectTemplate.ALightMortarHit01,
    FxImpactProp = EffectTemplate.ALightMortarHit01,
    FxImpactUnit = EffectTemplate.ALightMortarHit01,
}

TypeClass = Rapid_Plasma

