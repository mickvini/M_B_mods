#****************************************************************************
#**
#**  File     :  /projectiles/SIFLaanseTacticalMissile05/SIFLaanseTacticalMissile05_script.lua
#**  Author(s):  EbolaSoup, Resin Smoker, Optimus Prime
#**
#**  Summary  :  Laanse Tactical Missile Projectile script for XSL0310a
#**
#**  Copyright © 2009 4th Dimension Mod  All rights reserved.
#****************************************************************************

local SLaanseTacticalMissile = import('/lua/seraphimprojectiles.lua').SLaanseTacticalMissile

SIFLaanseTacticalMissile05 = Class(SLaanseTacticalMissile) {
    
    OnCreate = function(self)
        SLaanseTacticalMissile.OnCreate(self)    
        self:SetCollisionShape('Sphere', 0, 0, 0, 0.5)
        self.MoveThread = self:ForkThread(self.MovementThread)
    end,

    MovementThread = function(self)  
        self.WaitTime = 0.1
        self.Distance = self:GetDistanceToTarget()
        self:SetTurnRate(12.5)
        self:TrackTarget(false)        
        WaitSeconds(0.5) 
        if not self:BeenDestroyed() then
            self:TrackTarget(true)
            self:SetTurnRateByDist()                         
        end     
    end,

    SetTurnRateByDist = function(self)
        while not self:BeenDestroyed() do   
            local dist = self:GetDistanceToTarget()
            if dist > self.Distance then
                self:SetTurnRate(75)
                WaitSeconds(1)
                self.Distance = self:GetDistanceToTarget()
            end
            if dist > 50 then        
                self:SetTurnRate(12.5)
                self:ChangeMaxZigZag(25)
                self:ChangeZigZagFrequency(25)             
            elseif dist > 30 and dist <= 50 then
                self:SetTurnRate(25)
                self:ChangeMaxZigZag(25)
                self:ChangeZigZagFrequency(12.5) 
            elseif dist > 10 and dist <= 25 then
                self:SetTurnRate(50)
                self:ChangeMaxZigZag(50)
                self:ChangeZigZagFrequency(25)             
            elseif dist > 0 and dist <= 10 then           
                self:SetTurnRate(100)  
                self:ChangeMaxZigZag(100)
                self:ChangeZigZagFrequency(50)   
            end
            WaitSeconds(self.WaitTime)    
        end        
    end,        

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,
}
TypeClass = SIFLaanseTacticalMissile05