#
# UEF Over_Charge
#
local Over_ChargeProjectile = import('/mods/M&B/lua/projectiles.lua').Over_ChargeProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')

Over_Charge = Class(Over_ChargeProjectile) {
    FxTrails = EffectTemplate.TCommanderOverchargeFXTrail01,
    FxTrailScale = 0.5, 
}

TypeClass = Over_Charge
