#
# Aeon Very Fast Anti-Missile Missile
#
local AIMFlareProjectile = import('/lua/aeonprojectiles.lua').AIMFlareProjectile

AIMAntiMissile01 = Class(AIMFlareProjectile) {
    OnCreate = function(self)
        AIMFlareProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)
        --M&B: decoy climbs straight up instead of chasing the incoming missile.
        --It launches at MaxSpeed already (MuzzleVelocity = MaxSpeed = 10), so it
        --holds that climb rate; TurnRate 0 and no gravity keep the vector vertical.
        self:SetVelocity(0, self:GetBlueprint().Physics.MaxSpeed or 10, 0)
    end,
}

TypeClass = AIMAntiMissile01
