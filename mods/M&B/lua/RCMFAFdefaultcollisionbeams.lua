#****************************************************************************
#**
#**  File     :  /lua/BlackOpsdefaultcollisionbeams.lua
#**  Author(s):  Lt_hawkeye
#**
#**  Summary  :  Custom definitions collision beams
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CollisionBeam = import('/lua/sim/CollisionBeam.lua').CollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Util = import('/lua/utilities.lua')

HawkCollisionBeam = Class(CollisionBeam) {
    FxImpactUnit = EffectTemplate.DefaultProjectileLandUnitImpact,
    FxImpactLand = {},
    FxImpactWater = EffectTemplate.DefaultProjectileWaterImpact,
    FxImpactUnderWater = EffectTemplate.DefaultProjectileUnderWaterImpact,
    FxImpactAirUnit = EffectTemplate.DefaultProjectileAirUnitImpact,
    FxImpactProp = {},
    FxImpactShield = {},    
    FxImpactNone = {},
}

EMCHPRFDisruptorBeam = Class(HawkCollisionBeam){
	TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 0.3,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeamStartPointScale = 0.3,
    FxBeam = {'/mods/M&B/effects/emitters/manticore_microwave_laser_beam_01_emit.bp'},
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,
    FxBeamEndPointScale = 0.3,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,
    
    OnImpact = function(self, impactType, targetEntity) 
		if targetEntity then 
			if EntityCategoryContains(categories.TECH1, targetEntity) then
				targetEntity:SetStunned(0.2)
			elseif EntityCategoryContains(categories.TECH2, targetEntity) then
				targetEntity:SetStunned(0.2)
			elseif EntityCategoryContains(categories.TECH3, targetEntity) and not EntityCategoryContains(categories.SUBCOMMANDER, targetEntity) then#SUBCOMS HAVE SUMCOM ADDED IN MOD
				targetEntity:SetStunned(0.2)
			end
		end
		HawkCollisionBeam.OnImpact(self, impactType, targetEntity)
	end, 
}

xsl0310a_LightningBeam = Class(HawkCollisionBeam) {
    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 0.25,
    FxBeamStartPoint = EffectTemplate.SExperimentalUnstablePhasonLaserMuzzle01,
    FxBeam = {'/mods/M&B/effects/Emitters/xsl0310a_seraphim_othuy_beam_01_emit.bp'},
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
        HawkCollisionBeam.OnImpact(self, impactType, targetEntity)
    end,

    OnDisable = function( self )
        HawkCollisionBeam.OnDisable(self)
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

TMNovaCatGreenLaserBeam = Class(HawkCollisionBeam) {
    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 0.2,
    FxBeamStartPointScale = 1.7,
    FxBeamStartPoint = EffectTemplate.SDFExperimentalPhasonProjMuzzleFlash,
    FxBeam = {'/mods/M&B/effects/emitters/novacat_greenlaser_emit.bp'},
    FxBeamEndPoint = EffectTemplate.APhasonLaserImpact01,
    FxBeamEndPointScale = 2.0,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,
}

EXCEMPArrayBeam01CollisionBeam = Class(HawkCollisionBeam) {
    FxBeam = {'/mods/M&B/effects/emitters/excemparraybeam01_emit.bp'},
    FxBeamEndPoint = {},
    FxBeamStartPoint = {},
    FxBeamStartPointScale = 0.05,
    FxBeamEndPointScale = 0.05,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.5,
}