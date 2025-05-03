#
# Terran Napalm Missile
#
local NapalmMissileProjectile = import('/mods/M&B/lua/projectiles.lua').NapalmMissileProjectile

#Misc Local files
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TArtilleryProjectile = import('/lua/terranprojectiles.lua').TArtilleryProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

Napalm_Missile = Class(NapalmMissileProjectile) {

   PolyTrail = '/effects/emitters/default_polytrail_06_emit.bp',

    OnCreate = function(self)
        # Creating Global Variables 
        Army = self:GetArmy()

        NapalmMissileProjectile.OnCreate(self)
        self:ForkThread(self.UpdateThread)
        self:ForkThread(self.TargetTracking)
    end,

    UpdateThread = function(self)
        WaitSeconds(0.5)
        self:SetMesh('/mods/M&B/projectiles/uel0402NapalmMissile/napalm_missile_UnPacked01_mesh', true)
        local army = self:GetArmy()

        # Polytrails offset to wing tips
        CreateTrail(self, -1, army, self.PolyTrail ):OffsetEmitter(0.075, -0.05, 0.25)
        CreateTrail(self, -1, army, self.PolyTrail ):OffsetEmitter(-0.085, -0.055, 0.25)
        CreateTrail(self, -1, army, self.PolyTrail ):OffsetEmitter(0, 0.09, 0.25)

    end,

    TargetTracking = function(self)
        local target = self:GetTrackingTarget()   
        WaitSeconds(0.25)
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(0.25)    		
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        local ran1 = Random(100, 400)
        if dist < 35 and dist > 30 then
            self:SetTurnRate(25)

        elseif dist < 30 and dist > 25 then
            self:SetTurnRate(50)

        elseif dist < 25 and dist > 20 then
            self:SetTurnRate(75)

        elseif dist < 20 and dist > 15 then
            self:SetTurnRate(100)

        elseif dist < 15 and dist > 10 then
            self:SetTurnRate(125)
            self:ChangeMaxZigZag(125)
            self:ChangeZigZagFrequency(125)
        elseif dist < 10 and dist > 7 then
            self:SetTurnRate(ran1)
            self:ChangeMaxZigZag(ran1)
            self:ChangeZigZagFrequency(ran1)
        elseif dist < 6 then
            self:TrackTarget(false)
        end
    end,

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,

    OnImpact = function(self, TargetType, targetEntity)
        if TargetType != 'Water' then 
            local rotation = RandomFloat(0,2*math.pi)
            local size = RandomFloat(3.75,5.0)
            CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 15, self:GetArmy())
        end	 
        NapalmMissileProjectile.OnImpact( self, TargetType, targetEntity )
    end,

}

TypeClass = Napalm_Missile

