#
# Aeon "Annihilator" BFG Projectile
# Author Resin_Smoker
# Projectile based off ideas and scripts from Seiya's lobber mod
#

local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local ADisruptorShellProjectile = import('/mods/M&B/lua/projectiles.lua').ADisruptorShellProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local utilities = import('/lua/utilities.lua')

BFGShell = Class(EmitterProjectile) {
    
    FxTrails = EffectTemplate.SDFExperimentalPhasonProjFXTrails01,
    FxTrailScale = 0.6,
    FxImpactUnit =  EffectTemplate.SDFExperimentalPhasonProjHit01,
    FxUnitHitScale = 0.4,
    FxImpactProp =  EffectTemplate.SDFExperimentalPhasonProjHit01,
    FxLandHitScale = 0.4,
    FxImpactLand =  EffectTemplate.SDFExperimentalPhasonProjHit01,
    FxPropHitScale = 0.4,


    OnCreate = function(self)
	EmitterProjectile.OnCreate(self)
    end,
    
    OnImpact = function(self, TargetType, targetEntity)
        local rotation = RandomFloat(0,2*math.pi)        
        CreateDecal(self:GetPosition(), rotation, 'crater_radial01_normals', '', 'Alpha Normals', 5, 5, 300, 0, self:GetArmy())
        CreateDecal(self:GetPosition(), rotation, 'crater_radial01_albedo', '', 'Albedo', 5, 5, 300, 0, self:GetArmy())
        ADisruptorShellProjectile.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = BFGShell