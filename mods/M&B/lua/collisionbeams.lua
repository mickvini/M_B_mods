local BeamsFile = import('/lua/defaultcollisionbeams.lua')
local CollisionBeam = import('/lua/sim/CollisionBeam.lua').CollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/m&b/lua/EffectTemplates.lua')
local PhasonLaserCollisionBeam = BeamsFile.PhasonLaserCollisionBeam
local OrbitalDeathLaserCollisionBeam = BeamsFile.OrbitalDeathLaserCollisionBeam

TMCollisionBeam = Class(CollisionBeam) {
    FxImpactUnit = EffectTemplate.DefaultProjectileLandUnitImpact,
    FxImpactLand = {},#EffectTemplate.DefaultProjectileLandImpact,
    FxImpactWater = EffectTemplate.DefaultProjectileWaterImpact,
    FxImpactUnderWater = EffectTemplate.DefaultProjectileUnderWaterImpact,
    FxImpactAirUnit = EffectTemplate.DefaultProjectileAirUnitImpact,
    FxImpactProp = {},
    FxImpactShield = {},    
    FxImpactNone = {},
}

AlchemistPhasonLaserCollisionBeam = Class(PhasonLaserCollisionBeam) {
    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 0.4,
    FxBeam = ModEffectTemplate.AlchemistPhasonLaserBeam,
    SplatTexture = 'czar_mark01_albedo',
}


SCCollisionBeam = Class(CollisionBeam) {
    FxImpactUnit = EffectTemplate.DefaultProjectileLandUnitImpact,
    FxUnitHitScale = 0.3,     
    FxImpactLand = EffectTemplate.DefaultProjectileLandImpact,
    FxLandHitScale = .3,    
    FxImpactWater = EffectTemplate.DefaultProjectileWaterImpact,
    FxImpactUnderWater = EffectTemplate.DefaultProjectileUnderWaterImpact,
    FxImpactAirUnit = EffectTemplate.DefaultProjectileAirUnitImpact,
    FxImpactProp = {},
    FxImpactShield = {},    
    FxImpactNone = {},
}

xsl0310a_LightningBeam = Class(SCCollisionBeam) {

    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 0.25,
    FxBeamStartPoint = EffectTemplate.SExperimentalUnstablePhasonLaserMuzzle01,
    FxBeam = ModEffectTemplate.OthuyElectricityStrikeBeam,
    FxBeamEndPoint = EffectTemplate.OthuyElectricityStrikeHit,
    FxBeamEndPointScale = .25, 
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.1,

    OnImpact = function(self, impactType, targetEntity)
        if impactType == 'Terrain' then
            if self.Scorching == nil then
                self.Scorching = self:ForkThread( self.ScorchThread )   
            end
        elseif not impactType == 'Unit' then
            KillThread(self.Scorching)
            self.Scorching = nil
        end
        SCCollisionBeam.OnImpact(self, impactType, targetEntity)
    end,

    OnDisable = function( self )
        SCCollisionBeam.OnDisable(self)
        KillThread(self.Scorching)
        self.Scorching = nil   
    end,

    ScorchThread = function(self)
        local army = self:GetArmy()
        local size = 1.5 + (Random() * 1.5) 
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
TMMizuraBlueLaserBeam = Class(TMCollisionBeam) {
    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 0.2,
    FxBeamStartPointScale = 1.2,
    FxBeamStartPoint = EffectTemplate.ASDisruptorCannonMuzzle01,
    FxBeam = {'/mods/M&B/effects/emitters/mizura_bluelaser_emit.bp'},
    FxBeamEndPoint = ModEffectTemplate.AeonNocaCatBlueLaserHit,
    FxBeamEndPointScale = 0.07,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,
}