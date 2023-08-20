local UefBRNAT1ADVFIGproj = import('/mods/M&B/lua/projectiles.lua').UefBRNAT1ADVFIGproj
BRNAT1ADVFIGproj = Class(UefBRNAT1ADVFIGproj) {

    OnCreate = function(self)
        UefBRNAT1ADVFIGproj.OnCreate(self)
        self:ForkThread(self.UpdateThread)
    end,

    UpdateThread = function(self)
        WaitSeconds(1.5)
        self:SetMaxSpeed(55)
        self:SetAcceleration(10 + Random() * 8)
        self:ChangeMaxZigZag(0.5)
        self:ChangeZigZagFrequency(2)
    end,

    OnImpact = function(self, TargetType, TargetEntity)
        UefBRNAT1ADVFIGproj.OnImpact(self, TargetType, TargetEntity)
    end,
}

TypeClass = BRNAT1ADVFIGproj

