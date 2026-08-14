#
# Terran Land-Based Cruise Missile (T2 cluster variant)
#
local TMissileCruiseProjectile = import('/mods/M&B/lua/EXBlackOpsprojectiles.lua').UEFACUClusterMIssileProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

EXClusterMissleT2 = Class(TMissileCruiseProjectile) {
    OnCreate = function(self)
        TMissileCruiseProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2)
        self.MoveThread = self:ForkThread(self.MovementThread)
    end,

    MovementThread = function(self)
        self.WaitTime = 0.1
        self:SetTurnRate(8)
        WaitSeconds(0.1)
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = VDist3(self:GetPosition(), self:GetCurrentTargetPosition())
        -- T2 cluster: split at dist<=10, spread 1.3, 3 sub-munitions (weaker than T3)
        if dist > 0 and dist <= 10 then
            local FxFragEffect = EffectTemplate.SThunderStormCannonProjectileSplitFx
            local ChildProjectileBP = '/mods/M&B/projectiles/EXSmallYieldNuclearBomb01/EXSmallYieldNuclearBomb01_proj.bp'
            for k, v in FxFragEffect do
                CreateEmitterAtEntity( self, self:GetArmy(), v )
            end
            local vx, vy, vz = self:GetVelocity()
            local velocity = 20
            local numProjectiles = 3
            local angle = (2*math.pi) / numProjectiles
            local angleInitial = RandomFloat( 0, angle )
            local angleVariation = angle * 3
            local spreadMul = 1.3
            local xVec = 0
            local yVec = vy
            local zVec = 0
            for i = 0, (numProjectiles -1) do
                xVec = vx + (math.sin(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
                zVec = vz + (math.cos(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
                local proj = self:CreateChildProjectile(ChildProjectileBP)
                proj:SetVelocity(xVec,yVec,zVec)
                proj:SetVelocity(velocity)
                proj:PassDamageData(self.DamageData)
            end
            self:Destroy()
            return
        end
        -- steering by distance
        if dist > 50 then
            self:SetTurnRate(15)
            WaitSeconds(0.5)
            self:SetTurnRate(90)
            WaitSeconds(0.1)
            self:SetTurnRate(50)
        elseif dist > 35 and dist <= 50 then
            self:SetTurnRate(15)
            WaitSeconds(0.1)
            self:SetTurnRate(90)
            WaitSeconds(0.1)
            self:SetTurnRate(15)
        elseif dist > 25 and dist <= 35 then
            self:SetTurnRate(15)
            WaitSeconds(0.1)
            self:SetTurnRate(90)
            WaitSeconds(0.1)
            self:SetTurnRate(15)
        elseif dist > 10 and dist <= 25 then
            self:SetTurnRate(45)
            WaitSeconds(0.1)
            self:SetTurnRate(100)
        end
    end,

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,

    OnEnterWater = function(self)
        TMissileCruiseProjectile.OnEnterWater(self)
        self:SetDestroyOnWater(true)
    end,
}
TypeClass = EXClusterMissleT2
