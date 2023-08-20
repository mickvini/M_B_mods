#
# Aeon Artillery Projectile
#
local GLaserProjectile = import('/mods/M&B/lua/BlackOpsprojectiles.lua').GLaserProjectile

GLaser01 = Class(GLaserProjectile) {
	OnImpact = function(self, TargetType, TargetEntity)
        self:CreateProjectile('/mods/M&B/effects/entities/GoldLaserBombEffectController01/GoldLaserBombEffectController01_proj.bp', 0, 0, 0, 0, 0, 0):SetCollision(false)
        GLaserProjectile.OnImpact(self, TargetType, TargetEntity) 
    end,
}

TypeClass = GLaser01