#****************************************************************************
#**
#**  File     :  /lua/defaultcollisionbeams.lua
#**  Author(s):  Gordon Duclos
#**
#**  Summary  :  Default definitions collision beams
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CollisionBeam = import('/lua/sim/CollisionBeam.lua').CollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Util = import('/lua/utilities.lua')
local EffectTemplate2 = import('/mods/M&B/lua/EXEffectTemplates.lua')
local EXEffectTemplate = import('/mods/M&B/lua/EXBlackOpsEffectTemplates.lua')

local EXCollisionBeam = import('/mods/M&B/lua/EXCollisionBeam.lua').CollisionBeam

#-----------------------------
#   Base class that defines supreme commander specific defaults
#-----------------------------
SCCollisionBeam = Class(CollisionBeam) {
    FxImpactUnit = EffectTemplate.DefaultProjectileLandUnitImpact,
    FxImpactLand = {},#EffectTemplate.DefaultProjectileLandImpact,
    FxImpactWater = EffectTemplate.DefaultProjectileWaterImpact,
    FxImpactUnderWater = EffectTemplate.DefaultProjectileUnderWaterImpact,
    FxImpactAirUnit = EffectTemplate.DefaultProjectileAirUnitImpact,
    FxImpactProp = {},
    FxImpactShield = {},    
    FxImpactNone = {},
}
PDLaserCollisionBeam = Class(SCCollisionBeam) {
    FxBeam = {'/mods/M&B/effects/emitters/em_pdlaser_beam_01_emit.bp'},
    FxBeamEndPoint = {
        '/effects/emitters/quantum_generator_end_01_emit.bp',
        '/effects/emitters/quantum_generator_end_03_emit.bp',
        '/effects/emitters/quantum_generator_end_04_emit.bp',
    },
    FxBeamStartPoint = {
        '/effects/emitters/quantum_generator_01_emit.bp',
        '/effects/emitters/quantum_generator_02_emit.bp',
        '/effects/emitters/quantum_generator_04_emit.bp',
    },
    FxBeamStartPointScale = 0.05,
    FxBeamEndPointScale = 0.05,
    
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.5,

    OnImpact = function(self, impactType, targetEntity)
        if impactType == 'Terrain' then
            if self.Scorching == nil then
                self.Scorching = self:ForkThread( self.ScorchThread )   
            end
        elseif not impactType == 'Unit' then
            KillThread(self.Scorching)
            self.Scorching = nil
        end
        CollisionBeam.OnImpact(self, impactType, targetEntity)
    end,

    OnEnable = function( self )
        CollisionBeam.OnEnable(self)
        if self.Scorching == nil then
            self.Scorching = self:ForkThread( self.ScorchThread )
        end
    end,
    
    OnDisable = function( self )
        CollisionBeam.OnDisable(self)
        KillThread(self.Scorching)
        self.Scorching = nil   
    end,

    ScorchThread = function(self)

    end,    
}
#-----------------------------
#   UEF Sonic Disruptor Wave
#-----------------------------
SonicDisruptorWaveCBeam = Class(EXCollisionBeam) {
	FxBeam = {},

    TerrainImpactType = 'LargeBeam02',
    
    FxBeamStartPoint = EXEffectTemplate.SonicDisruptorWaveMuzzle,
    FxBeam = EXEffectTemplate.SonicDisruptorWaveBeam01,
    FxBeamEndPoint = EXEffectTemplate.SonicDisruptorWaveHit,
	
	FxBeamStartPointScale = 0.5,
	FxBeamEndPointScale = 0.5,
	TerrainImpactScale = 0.2,
	
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,

}

CybranBeamWeapons = Class(SCCollisionBeam) {

    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 1,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeam = {'/effects/emitters/microwave_laser_beam_01_emit.bp'},
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,

    OnImpact = function(self, impactType, targetEntity)
        if impactType == 'Terrain' then
            if self.Scorching == nil then
                self.Scorching = self:ForkThread( self.ScorchThread )   
            end
        elseif not impactType == 'Unit' then
            KillThread(self.Scorching)
            self.Scorching = nil
        end
        CollisionBeam.OnImpact(self, impactType, targetEntity)
    end,

    OnDisable = function( self )
        CollisionBeam.OnDisable(self)
        KillThread(self.Scorching)
        self.Scorching = nil   
    end,

    ScorchThread = function(self)
        local army = self:GetArmy()
        local size = 0.5 + (Random() * 1.5) 
        local CurrentPosition = self:GetPosition(1)
        local LastPosition = Vector(0,0,0)
        local skipCount = 1
        while true do
            if Util.GetDistanceBetweenTwoVectors( CurrentPosition, LastPosition ) > 0.25 or skipCount > 100 then
                CreateSplat( CurrentPosition, Util.GetRandomFloat(0,2*math.pi), self.SplatTexture, size, size, 100, 100, army )
                LastPosition = CurrentPosition
                skipCount = 1
            else
                skipCount = skipCount + self.ScorchSplatDropTime
            end
                
            WaitSeconds( self.ScorchSplatDropTime )
            size = 1.2 + (Random() * 1.5)
            CurrentPosition = self:GetPosition(1)
        end
    end,
}

CybranSSBeam = Class(CybranBeamWeapons) {
    TerrainImpactScale = 0.25,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeam = {'/mods/M&B/effects/emitters/exss_beam_01_emit.bp'},
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,
    FxBeamStartPointScale = 0.5,
    FxBeamEndPointScale = 0.5,
}

CybranAriesBeam01 = Class(CybranBeamWeapons) {
    TerrainImpactScale = 0.5,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeam = {'/mods/M&B/effects/emitters/exaries_beam_01_emit.bp'},
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,
    FxBeamStartPointScale = 0.75,
    FxBeamEndPointScale = 0.75,
}
EXCEMPArrayBeam01CollisionBeam = Class(SCCollisionBeam) {
    FxBeam = {'/mods/M&B/effects/emitters/excemparraybeam01_emit.bp'},
    FxBeamEndPoint = {

    },
    FxBeamStartPoint = {

    },
    FxBeamStartPointScale = 0.05,
    FxBeamEndPointScale = 0.05,
    
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.5,
}

EXCEMPArrayBeam02CollisionBeam = Class(SCCollisionBeam) {
    FxBeam = {'/mods/M&B/effects/emitters/excemparraybeam02_emit.bp'},
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeamStartPointScale = 0.05,
    FxBeamEndPointScale = 0.05,
    
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.5,
}

EXCEMPArrayBeam03CollisionBeam = Class(SCCollisionBeam) {
    FxBeam = {'/mods/M&B/effects/emitters/excemparraybeam01_emit.bp'},
    FxBeamEndPoint = EXEffectTemplate.CybranACUEMPArrayHit01,
    FxBeamStartPoint = {

    },
    FxBeamStartPointScale = 0.05,
    FxBeamEndPointScale = 1,
    
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.5,
    
    OnImpact = function(self, targetType, targetEntity)
        local army = self:GetArmy()
        CreateLightParticle(self, -1, self:GetArmy(), 26, 5, 'sparkle_white_add_08', 'ramp_white_24' )
        self:CreateProjectile('/effects/entities/SBOZhanaseeBombEffect01/SBOZhanaseeBombEffect01_proj.bp', 0, 0, 0, 0, 10.0, 0):SetCollision(false):SetVelocity(0,10.0, 0)
        self:CreateProjectile('/effects/entities/SBOZhanaseeBombEffect02/SBOZhanaseeBombEffect02_proj.bp', 0, 0, 0, 0, 0.05, 0):SetCollision(false):SetVelocity(0,0.05, 0)        
        
        local blanketSides = 12
        local blanketAngle = (2*math.pi) / blanketSides
        local blanketStrength = 1
        local blanketVelocity = 6.25

        for i = 0, (blanketSides-1) do
            local blanketX = math.sin(i*blanketAngle)
            local blanketZ = math.cos(i*blanketAngle)
            self:CreateProjectile('/effects/entities/EffectProtonAmbient01/EffectProtonAmbient01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
                :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
        end

        SCCollisionBeam.OnImpact(self, targetType, targetEntity)
    end,

}

PDLaser2CollisionBeam = Class(CollisionBeam) {
    FxBeamStartPoint = EffectTemplate.TDFHiroGeneratorMuzzle01,
    FxBeam = EffectTemplate.TDFHiroGeneratorBeam,
    FxBeamEndPoint = EffectTemplate.TDFHiroGeneratorHitLand,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,
    FxBeamStartPointScale = 0.75,
    FxBeamEndPointScale = 0.75,

    OnImpact = function(self, impactType, targetEntity)
        if impactType == 'Terrain' then
            if self.Scorching == nil then
                self.Scorching = self:ForkThread( self.ScorchThread )   
            end
        elseif not impactType == 'Unit' then
            KillThread(self.Scorching)
            self.Scorching = nil
        end
        CollisionBeam.OnImpact(self, impactType, targetEntity)
    end,
    
    OnDisable = function( self )
        CollisionBeam.OnDisable(self)
        KillThread(self.Scorching)
        self.Scorching = nil   
    end,

    ScorchThread = function(self)

    end,
}

AeonACUPhasonLaserCollisionBeam = Class(SCCollisionBeam) {
    FxBeamStartPoint = EffectTemplate.APhasonLaserMuzzle01,
    FxBeam = {'/mods/M&B/effects/emitters/exphason_beam_01_emit.bp'},
    FxBeamEndPoint = EffectTemplate.APhasonLaserImpact01,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,
    FxBeamStartPointScale = 0.25,
    FxBeamEndPointScale = 0.5,

    OnImpact = function(self, impactType, targetEntity)
        if impactType == 'Terrain' then
            if self.Scorching == nil then
                self.Scorching = self:ForkThread( self.ScorchThread )   
            end
        elseif not impactType == 'Unit' then
            KillThread(self.Scorching)
            self.Scorching = nil
        end
        CollisionBeam.OnImpact(self, impactType, targetEntity)
    end,
    
    OnDisable = function( self )
        CollisionBeam.OnDisable(self)
        KillThread(self.Scorching)
        self.Scorching = nil   
    end,

    ScorchThread = function(self)

    end,
}