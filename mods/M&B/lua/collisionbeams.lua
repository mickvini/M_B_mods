local BeamsFile = import('/lua/defaultcollisionbeams.lua')
local CollisionBeam = import('/lua/sim/CollisionBeam.lua').CollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/m&b/lua/EffectTemplates.lua')
local PhasonLaserCollisionBeam = BeamsFile.PhasonLaserCollisionBeam
local OrbitalDeathLaserCollisionBeam = BeamsFile.OrbitalDeathLaserCollisionBeam
local Util = import('/lua/utilities.lua')


LightGreenCollisionBeam = Class(CollisionBeam) {

    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 1,
    FxBeamStartPoint = {
         '/effects/emitters/flash_04_emit.bp', 
    },
    FxBeam = {
        '/mods/M&B/effects/emitters/light_green_laserbeam_01_emit.bp'
    },
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
    
    CreateBeamEffects = function(self)
        local army = self:GetArmy()
        for k, y in self.FxBeamStartPoint do
            local fx = CreateAttachedEmitter(self, 0, army, y ):ScaleEmitter(self.FxBeamStartPointScale)
            table.insert( self.BeamEffectsBag, fx)
            self.Trash:Add(fx)
        end
        local effect1 = CreateAttachedEmitter(self, 1, army, '/effects/emitters/hiro_beam_generator_hit_02_emit.bp' ):ScaleEmitter(self.FxBeamEndPointScale):OffsetEmitter(0,-0.2,0)
        local effect2 = CreateAttachedEmitter(self, 1, army, '/mods/M&B/effects/emitters/green_laserbeam_hit_02_emit.bp' ):ScaleEmitter(self.FxBeamEndPointScale):OffsetEmitter(0,-0.1,0)
        local effect3 = CreateAttachedEmitter(self, 1, army, '/mods/M&B/effects/emitters/green_laserbeam_hit_05_emit.bp' ):ScaleEmitter(self.FxBeamEndPointScale):OffsetEmitter(0,-0.2,0)
        table.insert( self.BeamEffectsBag, effect1)
        table.insert( self.BeamEffectsBag, effect2)
        table.insert( self.BeamEffectsBag, effect3)
        self.Trash:Add(effect1)
        self.Trash:Add(effect2)
        self.Trash:Add(effect3)
        if table.getn(self.FxBeam) != 0 then
            local fxBeam = CreateBeamEmitter(self.FxBeam[Random(1, table.getn(self.FxBeam))], army)
            AttachBeamToEntity(fxBeam, self, 0, army)
            
            # collide on start if it's a continuous beam
            local weaponBlueprint = self.Weapon:GetBlueprint()
            local bCollideOnStart = weaponBlueprint.BeamLifetime <= 0
            self:SetBeamFx(fxBeam, bCollideOnStart)
            
            table.insert( self.BeamEffectsBag, fxBeam )
            self.Trash:Add(fxBeam)
        else
            LOG('*ERROR: THERE IS NO BEAM EMITTER DEFINED FOR THIS COLLISION BEAM ', repr(self.FxBeam))
        end
    end,

    ScorchThread = function(self)
        local army = self:GetArmy()
        local size = 0.75 + (Random() * 0.75) 
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
        if(impactType == 'Unit') then
            local location = targetEntity:GetPosition()
            local selfPos = self:GetPosition()

            -- Вычисляем вектор направления
            local dx = location[1] - selfPos[1]
            local dy = location[2] - selfPos[2]
            local dz = location[3] - selfPos[3]

            -- Нормализуем вектор вручную
            local length = math.sqrt(dx*dx + dy*dy + dz*dz)
            if length > 0 then
                dx = dx / length
                dy = dy / length
                dz = dz / length
            end

            -- Вычисляем углы вращения
            local yaw = math.atan2(dx, dz)  -- Поворот вокруг вертикальной оси
            local pitch = -math.asin(dy)    -- Наклон вверх/вниз
            local roll = 0                  -- Обычно 0

            local rotation = {pitch, yaw, roll}

            local AssaultUnit = CreateUnitHPR('GMSB403a', self:GetArmy(), location[1], location[2], location[3], rotation[1], rotation[2], rotation[3])
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