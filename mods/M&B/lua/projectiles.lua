#****************************************************************************
#**
#**  File     : /cdimage/lua/modules/BlackOpsARprojectiles.lua
#**  Author(s): 
#**
#**  Summary  :
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
#------------------------------------------------------------------------
#					
#------------------------------------------------------------------------
local Projectile = import('/lua/sim/projectile.lua').Projectile
local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local OnWaterEntryEmitterProjectile = DefaultProjectileFile.OnWaterEntryEmitterProjectile
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local MultiPolyTrailProjectile = DefaultProjectileFile.MultiPolyTrailProjectile
local SingleCompositeEmitterProjectile = DefaultProjectileFile.SingleCompositeEmitterProjectile
local Explosion = import('/lua/defaultexplosions.lua')
local NullShell = DefaultProjectileFile.NullShell
local EffectTemplate = import('/lua/EffectTemplates.lua')
local DefaultExplosion = import('/lua/defaultexplosions.lua')
local DepthCharge = import('/lua/defaultantiprojectile.lua').DepthCharge
local util = import('/lua/utilities.lua')
--local EffectTemplate = import('/lua/EffectTemplates.lua')

local ModEffectTemplate = import('/mods/M&B/lua/EffectTemplates.lua')
local DepthCharge = import('/lua/defaultantiprojectile.lua').DepthCharge
local util = import('/lua/utilities.lua')

#----------------
# Null Shell
#----------------
EXNullShell = Class(Projectile) {}


#----------------
# M&B
#----------------
ALaserPhalanxProjectile = Class(MultiPolyTrailProjectile) {
    #PolyTrails = {
    #    '/mods/m&b/effects/Emitters/aeon_laser_phalanx_01_emit.bp',
    #},
    #offset is needed for proj to hit the missiles
 
	PolyTrails = {
  	'/effects/emitters/disintegrator_polytrail_04_emit.bp',
  	'/effects/emitters/disintegrator_polytrail_05_emit.bp',
  	'/effects/emitters/default_polytrail_03_emit.bp',
 	},
 
    PolyTrailOffset = EffectTemplate.TPhalanxGunPolyTrailsOffsets,
    FxTrailScale = 0.25,
    FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactNone = {},
    FxImpactLand = {},
    FxImpactUnderWater = {},
    FxImpactProjectile = EffectTemplate.TMissileHit02,
    FxProjectileHitScale = 0.5,
}

AMissileArrowProjectile = Class(SingleCompositeEmitterProjectile) {
    PolyTrail = '/effects/emitters/serpentine_missile_trail_emit.bp',
    BeamName = '/effects/emitters/serpentine_missle_exhaust_beam_01_emit.bp',
    PolyTrailOffset = -0.05,

    FxUnitHitScale = 3.0,
    FxLandHitScale = 3.0,
    FxWaterHitScale = 3.0,
    FxUnderWaterHitScale = 2.5,
    FxAirUnitHitScale = 3.0,
    FxNoneHitScale = 3.0,    
    FxImpactUnit = EffectTemplate.AMissileHit01,
    FxImpactProp = EffectTemplate.AMissileHit01,
    FxImpactLand = EffectTemplate.AMissileHit01,
    FxImpactUnderWater = {},
    OnCreate = function(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)
        SingleCompositeEmitterProjectile.OnCreate(self)
    end,
}

AMissileSerpentineProjectile2 = Class(SingleCompositeEmitterProjectile) {
    PolyTrail = '/effects/emitters/serpentine_missile_trail_emit.bp',
    BeamName = '/effects/emitters/serpentine_missle_exhaust_beam_01_emit.bp',
    PolyTrailOffset = -0.05,

    FxUnitHitScale = 2.0,
    FxLandHitScale = 2.0,
    FxWaterHitScale = 2.0,
    FxUnderWaterHitScale = 1.5,
    FxAirUnitHitScale = 2.0,
    FxNoneHitScale = 2.0,    
    FxImpactUnit = EffectTemplate.AMissileHit01,
    FxImpactProp = EffectTemplate.AMissileHit01,
    FxImpactLand = EffectTemplate.AMissileHit01,
    FxImpactUnderWater = {},
    OnCreate = function(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)
        SingleCompositeEmitterProjectile.OnCreate(self)
    end,
    OnImpact = function(self, TargetType, targetEntity)
        DefaultExplosion.CreateScorchMarkSplat( self, 1.0 )
        EmitterProjectile.OnImpact( self, TargetType, targetEntity )
    end,     
}

CDisintegratorLaserProjectile2 = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
		'/mods/m&b/effects/Emitters/disintegrator_polytrail_06_emit.bp',
		
	},
	PolyTrailOffset = {0,0},    
    FxTrailScale = 2,
    FxUnitHitScale = 1.0,
    FxLandHitScale = 1.0,
    FxWaterHitScale = 1.0,
    FxUnderWaterHitScale = 1.0,
    FxAirUnitHitScale = 1.0,
    FxNoneHitScale = 1.0,	
	
    # Hit Effects
	FxImpactUnit = EffectTemplate.CHvyDisintegratorHitUnit01,
    FxImpactProp = EffectTemplate.CHvyDisintegratorHitUnit01,
    FxImpactLand = EffectTemplate.CHvyDisintegratorHitLand01,
    FxImpactUnderWater = {},
}

--[[CDisintegratorLaserProjectile31 = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
		'/Mods/M&B/hook/effects/Emitters/disintegrator_polytrail_07_emit.bp',
		
	},
	PolyTrailOffset = {0,0},    
    FxTrailScale = 2,
    FxUnitHitScale = 0.8,
    FxLandHitScale = 0.8,
    FxWaterHitScale = 0.8,
    FxUnderWaterHitScale = 0.8,
    FxAirUnitHitScale = 0.8,
    FxNoneHitScale = 0.8,	
	
    # Hit Effects
    FxImpactUnit = EffectTemplate.CCorsairMissileUnitHit01,
    FxImpactProp = EffectTemplate.CCorsairMissileHit01,
    FxImpactLand = EffectTemplate.CCorsairMissileLandHit01,
    FxImpactAirUnit = EffectTemplate.CCorsairMissileUnitHit01,
    FxImpactUnderWater = {},
}
]]

CybBRMAT2ADVBOMBERproj = Class(EmitterProjectile) {

    FxImpactUnit = ModEffectTemplate.AvalancheRocketHit,
    FxUnitHitScale = 0.45,
    FxImpactProp = ModEffectTemplate.AvalancheRocketHit,
    FxPropHitScale = 0.45,
    FxImpactLand = ModEffectTemplate.AvalancheRocketHit,
    FxLandHitScale = 0.45,
    FxImpactUnderWater = ModEffectTemplate.AvalancheRocketHit,
    FxImpactWater = ModEffectTemplate.AvalancheRocketHit,
    FxWaterHitScale = 0.45,
    FxTrailOffset = -0.5,

    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_008_albedo', 5, 5, 250, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        EmitterProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

UefBRNAT1ADVFIGproj = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -0.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = EffectTemplate.TShipGaussCannonHit02,
    FxUnitHitScale = 0.55,
    FxImpactProp = EffectTemplate.TShipGaussCannonHit02,
    FxPropHitScale = 0.55,
    FxImpactLand = EffectTemplate.TShipGaussCannonHit02,
    FxLandHitScale = 0.55,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

UefBRNAT2FIGHTERproj = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -0.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = EffectTemplate.TShipGaussCannonHit02,
    FxUnitHitScale = 0.55,
    FxImpactProp = EffectTemplate.TShipGaussCannonHit02,
    FxPropHitScale = 0.55,
    FxImpactLand = EffectTemplate.TShipGaussCannonHit02,
    FxLandHitScale = 0.55,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------------------------------------------------------
# 			AEON PROJECTILES
#----------------------------------------------------------------


AeonBROAT1FIGproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
    PolyTrailOffset = EffectTemplate.TPlasmaGatlingCannonPolyTrailsOffsets,

    FxImpactNone = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonHit,
    FxImpactWater= EffectTemplate.TPlasmaGatlingCannonHit,
    RandomPolyTrails = 1,
    PolyTrails = ModEffectTemplate.AeonT1FighterPolyTrails,

}

AeonBROAT1FIGproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
    PolyTrailOffset = EffectTemplate.TPlasmaGatlingCannonPolyTrailsOffsets,

    FxImpactNone = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonHit,
    FxImpactWater= EffectTemplate.TPlasmaGatlingCannonHit,
    RandomPolyTrails = 1,
    PolyTrails = ModEffectTemplate.AeonT1FighterPolyTrails,

}

#----------------
# UEF T1 Advanced Battle Bot Weapon
#----------------
UefBRNT1ADVBOTproj = Class(EmitterProjectile) {
    FxTrails = ModEffectTemplate.BRNT1ADVBOTFXTrails01,
    FxImpactUnit = ModEffectTemplate.UEFT1ADVBOThit1,
    FxUnitHitScale = 0.5,
    FxImpactProp = ModEffectTemplate.UEFT1ADVBOThit1,
    FxPropHitScale = 0.5,
    FxImpactLand = ModEffectTemplate.UEFT1ADVBOThit1,
    FxLandHitScale = 0.5,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Seraphim Experimental Mega Bot Projectile
#----------------
SerBRPT3SHBMproj = Class(EmitterProjectile) {
    FxTrails = EffectTemplate.SDFSinnutheWeaponFXTrails01,
    FxImpactUnit = ModEffectTemplate.SerT3SHBMHit01,
    FxUnitHitScale = 1.6,
    FxImpactProp = ModEffectTemplate.SerT3SHBMHit01,
    FxPropHitScale = 1.6,
    FxImpactLand = ModEffectTemplate.SerT3SHBMHit01,
    FxLandHitScale = 1.6,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Seraphim Tech 1 Advanced Assault Tank
#----------------
SerBRPT1EXTANK2proj = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SChronotronCannonProjectileFxTrails,
    PolyTrails = EffectTemplate.SChronotronCannonProjectileTrails,
    PolyTrailOffset = {0,0,0},
    FxImpactUnit = ModEffectTemplate.SerT1AdvancedTankHit01,
    FxUnitHitScale = 1.6,
    FxImpactProp = ModEffectTemplate.SerT1AdvancedTankHit01,
    FxPropHitScale = 1.6,
    FxImpactLand = ModEffectTemplate.SerT1AdvancedTankHit01,
    FxLandHitScale = 1.6,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon NovaCat Blue laser
#----------------

AeonBROT3NCNlaserproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        '/mods/M&B/effects/emitters/novacat_bluelaser_emit.bp',
	},
	PolyTrailOffset = {0,0}, 

    # Hit Effects
    FxImpactUnit = EffectTemplate.CLaserHitUnit01,
    FxImpactProp = EffectTemplate.CLaserHitUnit01,
    FxImpactLand = EffectTemplate.CLaserHitLand01,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 Super Heavy Point Defense
#----------------
AeonT3SHPDproj = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.TIonizedPlasmaGatlingCannonFxTrails,
    PolyTrails = {},
    PolyTrailOffset = {0,0},
    FxImpactUnit = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxUnitHitScale = 7,
    FxImpactProp = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxPropHitScale = 7,
    FxImpactLand = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxLandHitScale = 7,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}


#----------------
# Aeon Tech 1 Experimental Mobile Artillery Main projectile
#----------------
AeonBROT1EXMOBARTproj = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.TIonizedPlasmaGatlingCannonFxTrails,
    PolyTrails = {},
    PolyTrailOffset = {0,0},
    FxImpactUnit = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxUnitHitScale = 7,
    FxImpactProp = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxPropHitScale = 7,
    FxImpactLand = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxLandHitScale = 7,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 1 Experimental Mobile Artillery Child projectile
#----------------
AeonBROT1EXMOBART2proj = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.TIonizedPlasmaGatlingCannonFxTrails,
    PolyTrails = {},
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.AeonExpT1ArtilleryHit,
    FxUnitHitScale = 1,
    FxImpactProp = ModEffectTemplate.AeonExpT1ArtilleryHit,
    FxPropHitScale = 1,
    FxImpactLand = ModEffectTemplate.AeonExpT1ArtilleryHit,
    FxLandHitScale = 1,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 NovaCat Quantum Charge
#----------------
AeonBROT3NCMproj = Class(SinglePolyTrailProjectile) {
    FxTrails = {
        '/effects/emitters/quantum_cannon_munition_03_emit.bp',
        '/effects/emitters/quantum_cannon_munition_04_emit.bp',
    },
    PolyTrail = '/effects/emitters/quantum_cannon_polytrail_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.AeonQuantumChargeHit01,
    FxUnitHitScale = 2,
    FxImpactProp = ModEffectTemplate.AeonQuantumChargeHit01,
    FxPropHitScale = 2,
    FxImpactLand = ModEffectTemplate.AeonQuantumChargeHit01,
    FxLandHitScale = 2,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 NovaCat Rapid Pulsegun
#----------------
AeonBROT3NCMPproj = Class(SinglePolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.TIonizedPlasmaGatlingCannonFxTrails,
    PolyTrails = {},
    PolyTrailOffset = {0,0},
    FxImpactUnit = EffectTemplate.AMercyGuidedMissileSplitMissileHitUnit,
    FxUnitHitScale = 1,
    FxImpactProp = EffectTemplate.AMercyGuidedMissileSplitMissileHitUnit,
    FxPropHitScale = 1,
    FxImpactLand = EffectTemplate.AMercyGuidedMissileSplitMissileHitUnit,
    FxLandHitScale = 1,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 Rocket Defense
#----------------
AeonBROT3PDROproj = Class(EmitterProjectile) {

    FxTrails = EffectTemplate.AOblivionCannonFXTrails02,
    FxImpactUnit = ModEffectTemplate.AeonBattleShipHit01,
    FxUnitHitScale = 2.4,
    FxImpactProp = ModEffectTemplate.AeonBattleShipHit01,
    FxPropHitScale = 2.4,
    FxImpactLand = ModEffectTemplate.AeonBattleShipHit01,
    FxLandHitScale = 2.4,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 2 Advanced Battleship main cannons
#----------------
AeonBROST2ADVBATTLESHIPproj = Class(EmitterProjectile) {

    FxTrails = ModEffectTemplate.BROST2ADVBATTLESHIPTRAILS,
    FxImpactUnit = ModEffectTemplate.BROST2ADVBATTLESHIPHIT,
    FxUnitHitScale = 2,
    FxImpactProp = ModEffectTemplate.BROST2ADVBATTLESHIPHIT,
    FxPropHitScale = 2,
    FxImpactLand = ModEffectTemplate.BROST2ADVBATTLESHIPHIT,
    FxLandHitScale = 2,
    FxTrailOffset = 0,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
    FxWaterHitScale = 2,
    FxImpactUnderWater = {},
    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_004_albedo', 11, 11, 250, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        MultiPolyTrailProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}
ADisruptorShellProjectile = Class(EmitterProjectile) {
    FxTrails = EffectTemplate.AQuarkBomb01,
    FxTrailScale = 0.5,

    # Hit Effects
    FxImpactUnit =  EffectTemplate.AQuarkBombHitUnit01,
    FxImpactProp =  EffectTemplate.AQuarkBombHitUnit01,
    FxImpactLand =  EffectTemplate.AQuarkBombHitLand01,
    FxImpactAirUnit =  EffectTemplate.AQuarkBombHitAirUnit01,
    FxImpactUnderWater = {},
    FxUnitHitScale = 0.4,
    FxLandHitScale = 0.4,
    FxWaterHitScale = 0.4,
    FxUnderWaterHitScale = 0.4,
    FxAirUnitHitScale = 0.4,
    FxNoneHitScale = 0.4,   
}

#----------------
# UEF Tech 2 Advanced Battleship main cannons
#----------------
UefBRNST2ADVBATTLESHIPproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.BRNST2ADVBATTLESHIPHIT,
    FxUnitHitScale = 1.4,
    FxImpactProp = ModEffectTemplate.BRNST2ADVBATTLESHIPHIT,
    FxPropHitScale = 1.4,
    FxImpactLand = ModEffectTemplate.BRNST2ADVBATTLESHIPHIT,
    FxLandHitScale = 1.4,
    FxTrailOffset = 0,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
    FxWaterHitScale = 2,
    FxImpactUnderWater = {},
    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_004_albedo', 7, 7, 250, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        MultiPolyTrailProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

#----------------
# Aeon Tech 1 Experimental Quadrobot maingun
#----------------
AeonBROT1EXM1proj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
		'/effects/emitters/aeon_laser_trail_02_emit.bp',
		'/effects/emitters/default_polytrail_03_emit.bp',
	},
	PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.AeonT1EXM1MainHit01,
    FxUnitHitScale = 2,
    FxImpactProp = ModEffectTemplate.AeonT1EXM1MainHit01,
    FxPropHitScale = 2,
    FxImpactLand = ModEffectTemplate.AeonT1EXM1MainHit01,
    FxLandHitScale = 2,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 Tank Hunter
#----------------
AeonBROT3THproj = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.TIonizedPlasmaGatlingCannonFxTrails,
    PolyTrails = {},
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.AeonT3HeavyRocketHit01,
    FxUnitHitScale = 1,
    FxImpactProp = ModEffectTemplate.AeonT3HeavyRocketHit01,
    FxPropHitScale = 1,
    FxImpactLand = ModEffectTemplate.AeonT3HeavyRocketHit01,
    FxLandHitScale = 1,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 1 Battle Tank Clawgun
#----------------
AeonBROT1BTCLAWproj = Class(SinglePolyTrailProjectile) {

    PolyTrail = '/effects/emitters/aeon_laser_trail_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.AeonClawHit01,
    FxUnitHitScale = 0.35,
    FxImpactProp = ModEffectTemplate.AeonClawHit01,
    FxPropHitScale = 0.35,
    FxImpactLand = ModEffectTemplate.AeonClawHit01,
    FxLandHitScale = 0.35,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Heavy Clawgun
#----------------
AeonHvyClawproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {'/effects/emitters/oblivion_cannon_munition_01_emit.bp'},
    FxImpactUnit = ModEffectTemplate.AeonHvyClawHit01,
    FxUnitHitScale = 1.35,
    FxImpactProp = ModEffectTemplate.AeonHvyClawHit01,
    FxPropHitScale = 1.35,
    FxImpactLand = ModEffectTemplate.AeonHvyClawHit01,
    FxLandHitScale = 1.35,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Anti-Air Missile
#----------------

AeonAAmissile01 = Class(EmitterProjectile) {
    FxTrails = EffectTemplate.AAntiMissileFlare,
    FxTrailScale = 1.0,
    FxImpactUnit = {},
    FxImpactAirUnit = {},
    FxImpactNone = EffectTemplate.AAntiMissileFlareHit,
    FxImpactProjectile = EffectTemplate.AAntiMissileFlareHit,
    FxOnKilled = EffectTemplate.AAntiMissileFlareHit,
    FxUnitHitScale = 1.4,
    FxLandHitScale = 1.4,
    FxWaterHitScale = 1.4,
    FxUnderWaterHitScale = 1.4,
    FxAirUnitHitScale = 1.4,
    FxNoneHitScale = 1.4,
    FxImpactLand = {},
    FxImpactUnderWater = {},
    DestroyOnImpact = false,

    OnImpact = function(self, TargetType, targetEntity)
        EmitterProjectile.OnImpact(self, TargetType, targetEntity)
        if TargetType == 'Terrain' or TargetType == 'Water' or TargetType == 'Prop' then
            if self.Trash then
                self.Trash:Destroy()
            end
            self:Destroy()
        end
    end,
}

#----------------
# Aeon T1 Rocket PD
#----------------
AeonBROT1PDROproj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.AAntiMissileFlare,
    FxTrailScale = 1.0,
    FxImpactUnit = EffectTemplate.AMercyGuidedMissileSplitMissileHitLand,
    FxUnitHitScale = 1.0,
    FxImpactProp = EffectTemplate.AMercyGuidedMissileSplitMissileHitLand,
    FxPropHitScale = 1.0,
    FxImpactLand = EffectTemplate.AMercyGuidedMissileSplitMissileHitLand,
    FxLandHitScale = 1.0,
    FxImpactUnderWater = EffectTemplate.AMercyGuidedMissileSplitMissileHitLand,
    FxImpactWater = EffectTemplate.AMercyGuidedMissileSplitMissileHitLand,
}

#----------------
# Aeon T2 Medium Tank rockets
#----------------
AeonBROT2MTRLproj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.AAntiMissileFlare,
    FxTrailScale = 1.0,
    FxImpactUnit = EffectTemplate.ABombHit01,
    FxUnitHitScale = 1.0,
    FxImpactProp = EffectTemplate.ABombHit01,
    FxPropHitScale = 1.0,
    FxImpactLand = EffectTemplate.ABombHit01,
    FxLandHitScale = 1.0,
    FxImpactUnderWater = EffectTemplate.ABombHit01,
    FxImpactWater = EffectTemplate.ABombHit01,
}

#----------------
# Aeon Tech 2 Medium Tank main gun
#----------------
AeonBROT2MTproj = Class(MultiPolyTrailProjectile) {

    PolyTrails = {
		'/effects/emitters/aeon_laser_trail_02_emit.bp',
		'/effects/emitters/default_polytrail_03_emit.bp',
	},
	PolyTrailOffset = {0,0},

    # Hit Effects
    FxImpactUnit = EffectTemplate.ACommanderOverchargeHit01,
    FxImpactProp = EffectTemplate.ACommanderOverchargeHit01,
    FxImpactLand = EffectTemplate.ACommanderOverchargeHit01,
    FxUnitHitScale = 2,
    FxLandHitScale = 2,
    FxPropHitScale = 2,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 Advanced Support Tank main gun
#----------------
AeonBROT3EXM1proj = Class(MultiPolyTrailProjectile) {
    FxTrails = {
        '/effects/emitters/quantum_cannon_munition_03_emit.bp',
        '/effects/emitters/quantum_cannon_munition_04_emit.bp',
    },
    PolyTrail = '/effects/emitters/quantum_cannon_polytrail_01_emit.bp',
	PolyTrailOffset = {0,0},

    # Hit Effects
    FxImpactUnit = ModEffectTemplate.AeonGraniteHit01,
    FxImpactProp = ModEffectTemplate.AeonGraniteHit01,
    FxImpactLand = ModEffectTemplate.AeonGraniteHit01,
    FxUnitHitScale = 1,
    FxLandHitScale = 1,
    FxPropHitScale = 1,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 1 Battle Tank main gun
#----------------
AeonBROT1BTproj = Class(MultiPolyTrailProjectile) {

    PolyTrails = {
		'/effects/emitters/aeon_laser_trail_02_emit.bp',
		'/effects/emitters/default_polytrail_03_emit.bp',
	},
	PolyTrailOffset = {0,0},

    # Hit Effects
    FxImpactUnit = EffectTemplate.ADisruptorHit01,
    FxImpactProp = EffectTemplate.ADisruptorHit01,
    FxImpactLand = EffectTemplate.ADisruptorHit01,
    FxUnitHitScale = 4,
    FxLandHitScale = 4,
    FxPropHitScale = 4,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 1 Experimental Assault Tank main gun
#----------------
AeonBROT1EXM2proj = Class(SinglePolyTrailProjectile) {

    PolyTrail = '/effects/emitters/aeon_laser_trail_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.AeonT1ExperimentalLaserHit,
    FxImpactProp = ModEffectTemplate.AeonT1ExperimentalLaserHit,
    FxImpactLand = ModEffectTemplate.AeonT1ExperimentalLaserHit,
    FxUnitHitScale = 1,
    FxLandHitScale = 1,
    FxPropHitScale = 1,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 Battle Tank main guns
#----------------
AeonBROT3BTproj = Class(EmitterProjectile) {

    FxTrails = {'/effects/emitters/graviton_munition_trail_01_emit.bp',},
    FxImpactUnit = ModEffectTemplate.AeonMainBattleTankHit01,
    FxUnitHitScale = 1,
    FxImpactProp = ModEffectTemplate.AeonMainBattleTankHit01,
    FxPropHitScale = 1,
    FxImpactLand = ModEffectTemplate.AeonMainBattleTankHit01,
    FxLandHitScale = 1,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 Armored battlebot main guns
#----------------
AeonBROT3ABBproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {
        '/effects/emitters/quantum_cannon_munition_03_emit.bp',
        '/effects/emitters/quantum_cannon_munition_04_emit.bp',
    },
    PolyTrail = '/effects/emitters/quantum_cannon_polytrail_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.AeonT3BattleBotHit01,
    FxUnitHitScale = 2,
    FxImpactProp = ModEffectTemplate.AeonT3BattleBotHit01,
    FxPropHitScale = 2,
    FxImpactLand = ModEffectTemplate.AeonT3BattleBotHit01,
    FxLandHitScale = 2,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 Plasma Battery projectile
#----------------
AeonBROT3ML2proj = Class(SinglePolyTrailProjectile) {
    FxTrails = {
        '/effects/emitters/quantum_cannon_munition_03_emit.bp',
        '/effects/emitters/quantum_cannon_munition_04_emit.bp',
    },
    PolyTrail = '/effects/emitters/quantum_cannon_polytrail_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.AeonBattleShipHit01,
    FxUnitHitScale = 1,
    FxImpactProp = ModEffectTemplate.AeonBattleShipHit01,
    FxPropHitScale = 1,
    FxImpactLand = ModEffectTemplate.AeonBattleShipHit01,
    FxLandHitScale = 1,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 2 Akuma Rocket projectile
#----------------
AeonBROT2EXBMproj = Class(SinglePolyTrailProjectile) {
    PolyTrail = '/effects/emitters/aeon_missile_trail_01_emit.bp',

    FxImpactUnit = ModEffectTemplate.AeonBattleShipHit01,
    FxUnitHitScale = 1,
    FxImpactProp = ModEffectTemplate.AeonBattleShipHit01,
    FxPropHitScale = 1,
    FxImpactLand = ModEffectTemplate.AeonBattleShipHit01,
    FxLandHitScale = 1,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Experimental Cougar main guns
#----------------
AeonBROT3COUGproj = Class(SinglePolyTrailProjectile) {

	PolyTrail = '/effects/emitters/default_polytrail_03_emit.bp',
    FxTrails = EffectTemplate.ADisruptorMunition01,
    FxImpactUnit = ModEffectTemplate.AeonCougarMainGuns,
    FxUnitHitScale = 2,
    FxImpactProp = ModEffectTemplate.AeonCougarMainGuns,
    FxPropHitScale = 2,
    FxImpactLand = ModEffectTemplate.AeonCougarMainGuns,
    FxLandHitScale = 2,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Experimental Enforcer main guns
#----------------
AeonBROT3SHBMproj = Class(EmitterProjectile) {
    FxTrails = EffectTemplate.AIFBallisticMortarTrails01,
    FxTrailScale = 0.75,
    FxImpactUnit = ModEffectTemplate.AeonEnforcerMainGuns,
    FxUnitHitScale = 2,
    FxImpactProp = ModEffectTemplate.AeonEnforcerMainGuns,
    FxPropHitScale = 2,
    FxImpactLand = ModEffectTemplate.AeonEnforcerMainGuns,
    FxLandHitScale = 2,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 Heavy Tank main guns
#----------------
AeonBROT3HTproj = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.TIonizedPlasmaGatlingCannonFxTrails,
    PolyTrails = {},
    PolyTrailOffset = {0,0},
    FxImpactUnit = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxUnitHitScale = 3,
    FxImpactProp = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxPropHitScale = 3,
    FxImpactLand = EffectTemplate.TIonizedPlasmaGatlingCannonHit01,
    FxLandHitScale = 3,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 2 Heavy Hover Tank main gun
#----------------
AeonBROT2HTproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = EffectTemplate.ALightDisplacementAutocannonMissilePolyTrails,
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.AEONT2HEAVYHOVERTANKHIT,
    FxUnitHitScale = 1,
    FxImpactProp = ModEffectTemplate.AEONT2HEAVYHOVERTANKHIT,
    FxPropHitScale = 1,
    FxImpactLand = ModEffectTemplate.AEONT2HEAVYHOVERTANKHIT,
    FxLandHitScale = 1,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 2 Missile Launcher
#----------------
AeonBROT2MLproj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.AAntiMissileFlare,
    FxTrailScale = 1.0,
    FxImpactUnit = EffectTemplate.ACommanderOverchargeHit01,
    FxUnitHitScale = 3,
    FxImpactProp = EffectTemplate.ACommanderOverchargeHit01,
    FxPropHitScale = 3,
    FxImpactLand = EffectTemplate.ACommanderOverchargeHit01,
    FxLandHitScale = 3,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 Rocket Battery
#----------------
AeonBROT3MLproj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.AAntiMissileFlare,
    FxTrailScale = 1.0,
    FxImpactUnit = ModEffectTemplate.AeonT3RocketHit01,
    FxUnitHitScale = 1.6,
    FxImpactProp = ModEffectTemplate.AeonT3RocketHit01,
    FxPropHitScale = 1.6,
    FxImpactLand = ModEffectTemplate.AeonT3RocketHit01,
    FxLandHitScale = 1.6,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 Heavy Assault Mech EMP burst
#----------------

AeonBROT3SHBMEMPproj = Class(SinglePolyTrailProjectile) {
    FxImpactUnit = ModEffectTemplate.AeonT3EMPburst,
    FxUnitHitScale = 4,
    FxImpactProp = ModEffectTemplate.AeonT3EMPburst,
    FxPropHitScale = 4,
    FxImpactLand = ModEffectTemplate.AeonT3EMPburst,
    FxLandHitScale = 4,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}


#----------------------------------------------------------------
# 			CYBRAN PROJECTILES
#----------------------------------------------------------------

#----------------
# Cybran Tech 2 Battle Mech Rockets
#----------------
CybranBMRocketProjectile = Class(SingleCompositeEmitterProjectile) {
    BeamName = '/effects/emitters/missile_loa_munition_exhaust_beam_01_emit.bp',
    FxTrails = {'/effects/emitters/missile_cruise_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    FxImpactUnit = EffectTemplate.CHvyDisintegratorHit02,
    FxUnitHitScale = 4,
    FxImpactProp = EffectTemplate.CHvyDisintegratorHit02,
    FxPropHitScale = 4,
    FxImpactLand = EffectTemplate.CHvyDisintegratorHit02,
    FxLandHitScale = 4,
    FxImpactUnderWater = {},
}

#----------------
# Cybran Tech 1 Battle Tank Rockets
#----------------
CybBRMT1BTRLproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
		'/effects/emitters/electron_bolter_trail_02_emit.bp',
		'/effects/emitters/default_polytrail_01_emit.bp',
	},
	PolyTrailOffset = {0,0},  
    FxTrails = {'/effects/emitters/electron_bolter_munition_01_emit.bp',},
    FxImpactUnit = EffectTemplate.CMissileHit02a,
    FxUnitHitScale = 2,
    FxImpactProp = EffectTemplate.CMissileHit02a,
    FxPropHitScale = 2,
    FxImpactLand = EffectTemplate.CMissileHit02a,
    FxLandHitScale = 2,
    FxImpactUnderWater = EffectTemplate.CMissileHit02a,
    FxImpactWater = EffectTemplate.CMissileHit02a,
    FxWaterHitScale = 2,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 1 Heavy Tank Cannon 1
#----------------

CybBRMT1HVYproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        ModEffectTemplate.CybProtonCannonPolyTrail,
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = ModEffectTemplate.CybProtonCannonFXTrail01,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = ModEffectTemplate.CybranT1BattleTankHit,
    FxUnitHitScale = 0.6,
    FxImpactProp = ModEffectTemplate.CybranT1BattleTankHit,
    FxPropHitScale = 0.6,
    FxImpactLand = ModEffectTemplate.CybranT1BattleTankHit,
    FxLandHitScale = 0.6,
    FxImpactWater = EffectTemplate.CNeutronClusterBombHitWater01,
    FxWaterHitScale = 2.5,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 1 Advanced BattleTank projectile
#----------------

CybBRMT1EXTANKproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = ModEffectTemplate.BRMT1EXTANKTRAILS,
	PolyTrailOffset = {0.05,0.05,0.05},  
    PolyTrailOffset = EffectTemplate.TPlasmaGatlingCannonPolyTrailsOffsets,

    FxImpactUnit = ModEffectTemplate.BRMT1EXTANKHIT,
    FxUnitHitScale = 1.6,
    FxImpactProp = ModEffectTemplate.BRMT1EXTANKHIT,
    FxPropHitScale = 1.6,
    FxImpactLand = ModEffectTemplate.BRMT1EXTANKHIT,
    FxLandHitScale = 1.6,
    FxImpactWater = EffectTemplate.CNeutronClusterBombHitWater01,
    FxWaterHitScale = 2.5,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 1 Medium Tank Cannon
#----------------

CybBRMT1MTproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        ModEffectTemplate.CybProtonCannonPolyTrail,
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = ModEffectTemplate.CybProtonCannonFXTrail01MT,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonHit,
    FxUnitHitScale = 1.6,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonHit,
    FxPropHitScale = 1.6,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonHit,
    FxLandHitScale = 1.6,
    FxImpactUnderWater = EffectTemplate.TPlasmaGatlingCannonHit,
    FxImpactWater = EffectTemplate.TPlasmaGatlingCannonHit,
    FxTrailOffset = 0,
}

#------------------------------------------------------------------------
#  CYBRAN RED PLASMA GATLING GUN
#------------------------------------------------------------------------
CybBRMT3RAPproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
    PolyTrailOffset = EffectTemplate.TPlasmaGatlingCannonPolyTrailsOffsets,

    FxImpactNone = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonHit,
    FxImpactWater= EffectTemplate.TPlasmaGatlingCannonHit,
    RandomPolyTrails = 1,
    PolyTrails = ModEffectTemplate.RedGatlingCannonPolyTrails,

}

#------------------------------------------------------------------------
#  AEON T1 FIGHTER
#------------------------------------------------------------------------
AeonBROAT1FIGproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
    PolyTrailOffset = EffectTemplate.TPlasmaGatlingCannonPolyTrailsOffsets,

    FxImpactNone = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonHit,
    FxImpactWater= EffectTemplate.TPlasmaGatlingCannonHit,
    RandomPolyTrails = 1,
    PolyTrails = ModEffectTemplate.AeonT1FighterPolyTrails,

}

#------------------------------------------------------------------------
#  UEF GREEN PLASMA GATLING GUN
#------------------------------------------------------------------------
uefBRNT3ARGUSMINIproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
    PolyTrailOffset = EffectTemplate.TPlasmaGatlingCannonPolyTrailsOffsets,

    FxImpactNone = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonHit,
    FxImpactWater= EffectTemplate.TPlasmaGatlingCannonHit,
    RandomPolyTrails = 1,
    PolyTrails = ModEffectTemplate.GreenGatlingCannonPolyTrails,

}

#------------------------------------------------------------------------
#  UEF YELLOW LASER
#------------------------------------------------------------------------
uefBRNT3ARGUSLASERproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
    PolyTrailOffset = EffectTemplate.TPlasmaGatlingCannonPolyTrailsOffsets,

    FxImpactNone = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonHit,
    FxImpactWater= EffectTemplate.TPlasmaGatlingCannonHit,
    RandomPolyTrails = 1,
    PolyTrails = ModEffectTemplate.YellowLaserPolyTrails,

}

#----------------
# Cybran Tech 3 SnakeBite small Rockets
#----------------

CybBRMT3HAMRLproj = Class(SingleCompositeEmitterProjectile) {
    FxTrails = {},
	PolyTrail = '/effects/emitters/cybran_iridium_missile_polytrail_01_emit.bp',    
    BeamName = '/effects/emitters/rocket_iridium_exhaust_beam_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.CybranT1BattleTankHit,
    FxUnitHitScale = 1.13,
    FxImpactProp = ModEffectTemplate.CybranT1BattleTankHit,
    FxPropHitScale = 1.13,
    FxImpactLand = ModEffectTemplate.CybranT1BattleTankHit,
    FxLandHitScale = 1.13,
    FxImpactUnderWater = ModEffectTemplate.CybranT1BattleTankHit,
    FxImpactWater = ModEffectTemplate.CybranT1BattleTankHit,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 1 Experimental LaserBot
#----------------

CybBRMT1EXM1proj = Class(MultiPolyTrailProjectile) {
    PolyTrails = ModEffectTemplate.HeavyLaserPolyTrail,
    FxImpactUnit = ModEffectTemplate.CLaserBotHit01,
    FxUnitHitScale = 1.13,
    FxImpactProp = ModEffectTemplate.CLaserBotHit01,
    FxPropHitScale = 1.13,
    FxImpactLand = ModEffectTemplate.CLaserBotHit01,
    FxLandHitScale = 1.13,
    FxImpactUnderWater = ModEffectTemplate.CLaserBotHit01,
    FxImpactWater = ModEffectTemplate.CLaserBotHit01,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 2 Heavy Tank Cannon 1
#----------------

CybBRMT2HVYproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        ModEffectTemplate.CybProtonCannonPolyTrail,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = ModEffectTemplate.CybProtonCannonFXTrail01,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = ModEffectTemplate.CybranT1BattleTankHit,
    FxUnitHitScale = 1.1,
    FxImpactProp = ModEffectTemplate.CybranT1BattleTankHit,
    FxPropHitScale = 1.1,
    FxImpactLand = ModEffectTemplate.CybranT1BattleTankHit,
    FxLandHitScale = 1.1,
    FxImpactUnderWater = ModEffectTemplate.CybranT1BattleTankHit,
    FxImpactWater = ModEffectTemplate.CybranT1BattleTankHit,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 2 Heavy Artillery Cannon 1
#----------------

CybBRMT2BEETLEproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        ModEffectTemplate.CybProtonCannonPolyTrail02,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = ModEffectTemplate.CybProtonCannonFXTrail01,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = ModEffectTemplate.CybranT2BeetleHit01,
    FxUnitHitScale = 1.7,
    FxImpactProp = ModEffectTemplate.CybranT2BeetleHit01,
    FxPropHitScale = 1.7,
    FxImpactLand = ModEffectTemplate.CybranT2BeetleHit01,
    FxLandHitScale = 1.7,
    FxImpactUnderWater = ModEffectTemplate.CybranT2BeetleHit01,
    FxImpactWater = ModEffectTemplate.CybranT2BeetleHit01,
    FxTrailOffset = 0,
}

CybBRMT3ADVBOTproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        ModEffectTemplate.CybProtonCannonPolyTrail02,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = ModEffectTemplate.CybProtonCannonFXTrail01,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = ModEffectTemplate.CybranT2BeetleHit01,
    FxUnitHitScale = 0.7,
    FxImpactProp = ModEffectTemplate.CybranT2BeetleHit01,
    FxPropHitScale = 0.7,
    FxImpactLand = ModEffectTemplate.CybranT2BeetleHit01,
    FxLandHitScale = 0.7,
    FxImpactUnderWater = ModEffectTemplate.CybranT2BeetleHit01,
    FxImpactWater = ModEffectTemplate.CybranT2BeetleHit01,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 2 Experimental Point Defense Laser
#----------------

CybBRMT2EPDproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = ModEffectTemplate.HeavyLaserPolyTrail,
    FxImpactUnit = EffectTemplate.CDisintegratorHitUnit01,
    FxImpactAirUnit = EffectTemplate.CDisintegratorHitAirUnit01,
    FxImpactProp = EffectTemplate.CDisintegratorHitUnit01,
    FxLandHitScale = 2.4,
    FxUnitHitScale = 2.4,
    FxPropHitScale = 2.4,
    FxImpactLand = EffectTemplate.CDisintegratorHitLand01,
    FxImpactUnderWater = {},
}

#----------------
# NULLWEAPON
#----------------

CybNULLWEAPONproj = Class(NullShell) {
    # Hit Effects
    FxImpactUnit = {},
    FxImpactAirUnit = {},
    FxImpactProp = {},
    FxImpactLand = {},
    FxImpactUnderWater = {},
}

#----------------
# Cybran Tech 2 Heavy Tank Cannon 2
#----------------

CybBRMT2HVY2proj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        ModEffectTemplate.CybProtonCannonPolyTrail,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = ModEffectTemplate.CybProtonCannonFXTrail01,
    FxImpactUnit = ModEffectTemplate.CybranT2BattleTankHit,
    FxUnitHitScale = 0.55,
    FxImpactProp = ModEffectTemplate.CybranT2BattleTankHit,
    FxPropHitScale = 0.55,
    FxImpactLand = ModEffectTemplate.CybranT2BattleTankHit,
    FxLandHitScale = 0.55,
    FxImpactUnderWater = ModEffectTemplate.CybranT2BattleTankHit,
    FxImpactWater = ModEffectTemplate.CybranT2BattleTankHit,
    FxWaterHitScale = 0.55,
    FxTrailOffset = 0,
}

#----------------
# Aeon Experimental Battle Bot SplitterMissiles
#----------------

AeonBROT3BTBOTproj = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/oblivion_cannon_munition_01_emit.bp'},
    FxImpactUnit = EffectTemplate.AOblivionCannonHit01,
    FxImpactProp = EffectTemplate.AOblivionCannonHit01,
    FxImpactLand = EffectTemplate.AOblivionCannonHit01,
    FxImpactWater = EffectTemplate.AOblivionCannonHit01,
}

AeonBROT3BTBOT2proj = Class(SinglePolyTrailProjectile) {
    PolyTrail = '/effects/emitters/quantum_displacement_cannon_polytrail_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.UEFDeath01,
    FxImpactProp = ModEffectTemplate.UEFDeath01,
    FxImpactLand = ModEffectTemplate.UEFDeath01,
    FxLandHitScale = 0.55,
    FxUnitHitScale = 0.55,
    FxPropHitScale = 0.55,
    FxImpactWater = ModEffectTemplate.UEFDeath01,
    FxWaterHitScale = 0.55,
}

#----------------
# Cybran Tech 3 Battle Tank main gun
#----------------
CybBRMT3BTproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        ModEffectTemplate.CybProtonCannonPolyTrail,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = ModEffectTemplate.CybProtonCannonFXTrail01,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = ModEffectTemplate.CybranT3BattleTankHit,
    FxUnitHitScale = 0.8,
    FxImpactProp = ModEffectTemplate.CybranT3BattleTankHit,
    FxPropHitScale = 0.8,
    FxImpactLand = ModEffectTemplate.CybranT3BattleTankHit,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = ModEffectTemplate.CybranT3BattleTankHit,
    FxImpactWater = ModEffectTemplate.CybranT3BattleTankHit,
    FxTrailOffset = 0,
}

#----------------
# Cybran Experimental MadCat main gun
#----------------
CybMadCatMolecular = Class(MultiPolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    PolyTrail = '/effects/emitters/default_polytrail_03_emit.bp',
    FxTrails = EffectTemplate.CMolecularCannon01,
    FxImpactUnit = ModEffectTemplate.CybranT2BattleTankHit,
    FxUnitHitScale = 1.3,
    FxImpactProp = ModEffectTemplate.CybranT2BattleTankHit,
    FxPropHitScale = 1.3,
    FxImpactLand = ModEffectTemplate.CybranT2BattleTankHit,
    FxLandHitScale = 1.3,
    FxImpactUnderWater = ModEffectTemplate.CybranT2BattleTankHit,
    FxImpactWater = ModEffectTemplate.CybranT2BattleTankHit,
    FxTrailOffset = 0,
}

#----------------
# Cybran Experimental MadCat Rockets
#----------------
CybMadCatRockets = Class(MultiPolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    PolyTrail = '/effects/emitters/default_polytrail_03_emit.bp',
    FxTrails = EffectTemplate.CMolecularCannon01,
    FxImpactUnit = ModEffectTemplate.CybranT3MadCatRocketsHit,
    FxUnitHitScale = 1.2,
    FxImpactProp = ModEffectTemplate.CybranT3MadCatRocketsHit,
    FxPropHitScale = 1.2,
    FxImpactLand = ModEffectTemplate.CybranT3MadCatRocketsHit,
    FxLandHitScale = 1.2,
    FxImpactUnderWater = ModEffectTemplate.CybranT3MadCatRocketsHit,
    FxImpactWater = ModEffectTemplate.CybranT3MadCatRocketsHit,
    FxWaterHitScale = 1.2,
    FxTrailOffset = 0,
}

#----------------
# Cybran Experimental MadCat mk.2 main gun
#----------------
CybBRMT3MCM2proj = Class(MultiPolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    PolyTrails = {
        EffectTemplate.CHvyProtonCannonPolyTrail,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = EffectTemplate.CHvyProtonCannonFXTrail01,
    FxImpactUnit = ModEffectTemplate.Madcatmk2hit,
    FxUnitHitScale = 1.0,
    FxImpactProp = ModEffectTemplate.Madcatmk2hit,
    FxPropHitScale = 1.0,
    FxImpactLand = ModEffectTemplate.Madcatmk2hit,
    FxLandHitScale = 1.0,
    FxImpactUnderWater = ModEffectTemplate.Madcatmk2hit,
    FxImpactWater = ModEffectTemplate.Madcatmk2hit,
    FxTrailOffset = 0,
}

#----------------
# Cybran Experimental MadCat mk.4 main gun
#----------------
CybBRMT3MCM4proj = Class(MultiPolyTrailProjectile) {


	FxTrails = EffectTemplate.CDisintegratorFxTrails01,  
	
    FxImpactUnit = ModEffectTemplate.Beetleprojectilehit01,
    FxUnitHitScale = 1.0,
    FxImpactProp = ModEffectTemplate.Beetleprojectilehit01,
    FxPropHitScale = 1.0,
    FxImpactLand = ModEffectTemplate.Beetleprojectilehit01,
    FxLandHitScale = 1.0,
    FxImpactUnderWater = ModEffectTemplate.Beetleprojectilehit01,
    FxImpactWater = ModEffectTemplate.Beetleprojectilehit01,
}

#----------------
# Cybran Experimental MadCat mk.4 Rockets
#----------------
CybBRMT3MCM4RLproj = Class(MultiPolyTrailProjectile) {
	FxTrails  = {
            '/mods/M&B/effects/emitters/w_u_gau03_p_03_brightglow_emit.bp',
            '/mods/M&B/effects/emitters/w_u_gau03_p_04_smoke_emit.bp',
	},
	FxTrailOffset = 0.2,
	PolyTrails  = {
            '/mods/M&B/effects/emitters/w_u_gau03_p_01_polytrails_emit.bp',
            '/mods/M&B/effects/emitters/w_u_gau03_p_02_polytrails_emit.bp',
	},
	PolyTrailOffset = {0.3,0},

    FxImpactUnit = ModEffectTemplate.BattleMech2RocketHit,
    FxUnitHitScale = 1.3,
    FxImpactProp = ModEffectTemplate.BattleMech2RocketHit,
    FxPropHitScale = 1.3,
    FxImpactLand = ModEffectTemplate.BattleMech2RocketHit,
    FxLandHitScale = 1.3,
    FxImpactUnderWater = ModEffectTemplate.BattleMech2RocketHit,
    FxImpactWater = ModEffectTemplate.BattleMech2RocketHit,
    FxWaterHitScale = 1.3,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 3 Battle Tank Rockets
#----------------
CybBRMT3BTRLproj = Class(SingleCompositeEmitterProjectile) {
    FxTrails = {},
	PolyTrail = '/effects/emitters/cybran_iridium_missile_polytrail_01_emit.bp',    
    BeamName = '/effects/emitters/rocket_iridium_exhaust_beam_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.CybranT3BattleTankRocketHit,
    FxUnitHitScale = 0.85,
    FxImpactProp = ModEffectTemplate.CybranT3BattleTankRocketHit,
    FxPropHitScale = 0.85,
    FxImpactLand = ModEffectTemplate.CybranT3BattleTankRocketHit,
    FxLandHitScale = 0.85,
    FxImpactUnderWater = ModEffectTemplate.CybranT3BattleTankRocketHit,
    FxImpactWater = ModEffectTemplate.CybranT3BattleTankRocketHit,
    FxWaterHitScale = 0.85,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 3 Battle Mech 2 Rockets
#----------------
CybBRMT3BM2TLproj = Class(MultiPolyTrailProjectile) {
	FxTrails  = {
            '/mods/M&B/effects/emitters/w_u_gau03_p_03_brightglow_emit.bp',
            '/mods/M&B/effects/emitters/w_u_gau03_p_04_smoke_emit.bp',
	},
	FxTrailOffset = 0.2,
	PolyTrails  = {
            '/mods/M&B/effects/emitters/w_u_gau03_p_01_polytrails_emit.bp',
            '/mods/M&B/effects/emitters/w_u_gau03_p_02_polytrails_emit.bp',
	},
	PolyTrailOffset = {0.3,0},
    FxImpactUnit = ModEffectTemplate.BattleMech2RocketHit,
    FxUnitHitScale = 1.3,
    FxImpactProp = ModEffectTemplate.BattleMech2RocketHit,
    FxPropHitScale = 1.3,
    FxImpactLand = ModEffectTemplate.BattleMech2RocketHit,
    FxLandHitScale = 1.3,
    FxImpactUnderWater = ModEffectTemplate.BattleMech2RocketHit,
    FxImpactWater = ModEffectTemplate.BattleMech2RocketHit,
    FxWaterHitScale = 1.3,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 3 Battle Mech Rockets
#----------------
CybBRMT3BMRLproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
		'/effects/emitters/electron_bolter_trail_02_emit.bp',
		'/effects/emitters/default_polytrail_01_emit.bp',
	},
	PolyTrailOffset = {0,0},  
    FxTrails = {'/effects/emitters/electron_bolter_munition_01_emit.bp',},
    FxImpactUnit = EffectTemplate.CMissileHit02a,
    FxUnitHitScale = 6.2,
    FxImpactProp = EffectTemplate.CMissileHit02a,
    FxPropHitScale = 6.2,
    FxImpactLand = EffectTemplate.CMissileHit02a,
    FxLandHitScale = 6.2,
    FxImpactUnderWater = EffectTemplate.CMissileHit02a,
    FxImpactWater = EffectTemplate.CMissileHit02a,
    FxWaterHitScale = 6.2,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 3 Heavy Rockets (Rocket Battery)
#----------------
CybBRMT3MLproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/missile_loa_munition_exhaust_beam_01_emit.bp',
    FxTrails = {'/effects/emitters/missile_cruise_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxUnitHitScale = 0.8,
    FxImpactProp = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxPropHitScale = 0.8,
    FxImpactLand = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxImpactWater = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxWaterHitScale = 0.8,
}

#----------------
# Cybran Tech 1 Advanced BattleBot Rockets
#----------------
CybBRMT1ADVBOTRLproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/missile_loa_munition_exhaust_beam_01_emit.bp',
    FxTrails = {'/effects/emitters/missile_cruise_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxUnitHitScale = 1.1,
    FxImpactProp = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxPropHitScale = 1.1,
    FxImpactLand = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxLandHitScale = 1.1,
    FxImpactUnderWater = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxImpactWater = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxWaterHitScale = 1.1,
}

#----------------
# Cybran Experimental Battle Spiderbot Rockets
#----------------
CybBRMT3EXBMRLproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/missile_loa_munition_exhaust_beam_01_emit.bp',
    FxTrails = {'/effects/emitters/missile_cruise_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = ModEffectTemplate.BattleMech2RocketHit,
    FxUnitHitScale = 0.8,
    FxImpactProp = ModEffectTemplate.BattleMech2RocketHit,
    FxPropHitScale = 0.8,
    FxImpactLand = ModEffectTemplate.BattleMech2RocketHit,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = ModEffectTemplate.BattleMech2RocketHit,
    FxImpactWater = ModEffectTemplate.BattleMech2RocketHit,
    FxWaterHitScale = 0.8,
}

#----------------
# Cybran Tech 3 Point Defense Proton Gun
#----------------
CybBRMT3PDproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        ModEffectTemplate.CybProtonCannonPolyTrail,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = ModEffectTemplate.CybProtonCannonFXTrail01,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = ModEffectTemplate.CybranHeavyProtonGunHit,
    FxUnitHitScale = 0.5,
    FxImpactProp = ModEffectTemplate.CybranHeavyProtonGunHit,
    FxPropHitScale = 0.5,
    FxImpactLand = ModEffectTemplate.CybranHeavyProtonGunHit,
    FxLandHitScale = 0.5,
    FxImpactUnderWater = ModEffectTemplate.CybranHeavyProtonGunHit,
    FxImpactWater = EffectTemplate.CNeutronClusterBombHitWater01,
    FxWaterHitScale = 2.5,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 3 Rocket Defense
#----------------
CybBRMT3PDROproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/missile_exhaust_fire_beam_01_emit.bp',
    FxTrails = EffectTemplate.TMissileExhaust03,
    FxImpactUnit = ModEffectTemplate.CybranT3PdroHit,
    FxUnitHitScale = 1.95,
    FxImpactProp = ModEffectTemplate.CybranT3PdroHit,
    FxPropHitScale = 1.95,
    FxImpactLand = ModEffectTemplate.CybranT3PdroHit,
    FxLandHitScale = 1.95,
    FxImpactUnderWater = ModEffectTemplate.CybranT3PdroHit,
    FxImpactWater = ModEffectTemplate.CybranT3PdroHit,
    FxWaterHitScale = 1.95,
    FxTrailOffset = -0.5,
}

#----------------
# Cybran Avalanche Rockets
#----------------
CybBRMT3AVARLproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/missile_exhaust_fire_beam_01_emit.bp',
    FxTrails = EffectTemplate.TMissileExhaust03,
    FxImpactUnit = ModEffectTemplate.AvalancheRocketHit,
    FxUnitHitScale = 1,
    FxImpactProp = ModEffectTemplate.AvalancheRocketHit,
    FxPropHitScale = 1,
    FxImpactLand = ModEffectTemplate.AvalancheRocketHit,
    FxLandHitScale = 1,
    FxImpactUnderWater = ModEffectTemplate.AvalancheRocketHit,
    FxImpactWater = ModEffectTemplate.AvalancheRocketHit,
    FxWaterHitScale = 1,
    FxTrailOffset = -0.5,
}

#----------------
# Cybran Tech 3 Bombardment Ship
#----------------
CybBRMST3BOMproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        EffectTemplate.CHvyProtonCannonPolyTrail,
        '/effects/emitters/default_polytrail_01_emit.bp',
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = EffectTemplate.CHvyProtonCannonFXTrail01,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = ModEffectTemplate.CYBRANHEAVYPROTONARTILLERYHIT01,
    FxUnitHitScale = 3,
    FxImpactProp = ModEffectTemplate.CYBRANHEAVYPROTONARTILLERYHIT01,
    FxPropHitScale = 3,
    FxImpactLand = ModEffectTemplate.CYBRANHEAVYPROTONARTILLERYHIT01,
    FxLandHitScale = 3,
    FxImpactUnderWater = ModEffectTemplate.CYBRANHEAVYPROTONARTILLERYHIT01,
    FxImpactWater = ModEffectTemplate.CYBRANHEAVYPROTONARTILLERYHIT01,
    FxWaterHitScale = 3,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 3 Heavy Tank 2 barreled main gun
#----------------
CybBRMT3HT3proj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
        ModEffectTemplate.CybProtonCannonPolyTrail,
    },
    PolyTrailOffset = {0,0}, 

    FxTrails = ModEffectTemplate.CybProtonCannonFXTrail01,
    #PolyTrail = EffectTemplate.CHvyProtonCannonPolyTrail,
    FxImpactUnit = ModEffectTemplate.CybranT3HVYTankHit,
    FxUnitHitScale = 0.65,
    FxImpactProp = ModEffectTemplate.CybranT3HVYTankHit,
    FxPropHitScale = 0.65,
    FxImpactLand = ModEffectTemplate.CybranT3HVYTankHit,
    FxLandHitScale = 0.65,
    FxImpactUnderWater = ModEffectTemplate.CybranT3HVYTankHit,
    FxImpactWater = ModEffectTemplate.CybranT3HVYTankHit,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 3 Beetle Guns
#----------------
CybBRMT3AVAproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
		'/effects/emitters/disintegrator_polytrail_04_emit.bp',
		'/effects/emitters/disintegrator_polytrail_05_emit.bp',
		'/effects/emitters/default_polytrail_03_emit.bp',
	},
	PolyTrailOffset = {0,0,0},  
	FxTrails = EffectTemplate.CDisintegratorFxTrails01,  
	
    FxImpactUnit = ModEffectTemplate.Beetleprojectilehit01,
    FxUnitHitScale = 1.4,
    FxImpactProp = ModEffectTemplate.Beetleprojectilehit01,
    FxPropHitScale = 1.4,
    FxImpactLand = ModEffectTemplate.Beetleprojectilehit01,
    FxLandHitScale = 1.4,
    FxImpactUnderWater = ModEffectTemplate.Beetleprojectilehit01,
    FxImpactWater = ModEffectTemplate.Beetleprojectilehit01,
}


#----------------------------------------------------------------
# 			UEF PROJECTILES
#----------------------------------------------------------------


#----------------
# UEF Tech 1 Battle Tank rockets
#----------------
UefBRNT1BTRLproj = Class(MultiPolyTrailProjectile) {
    FxInitial = {},
    TrailDelay = 1,
    FxTrails = {'/effects/emitters/missile_sam_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    FxImpactUnit = EffectTemplate.TGaussCannonHitLand01,
    FxUnitHitScale = 5,
    FxImpactProp = EffectTemplate.TGaussCannonHitLand01,
    FxPropHitScale = 5,
    FxImpactLand = EffectTemplate.TGaussCannonHitLand01,
    FxLandHitScale = 5,
    FxImpactUnderWater = EffectTemplate.TGaussCannonHitLand01,
    FxImpactWater = EffectTemplate.TGaussCannonHitLand01,
    FxWaterHitScale = 5,
}

#----------------
# UEF Tech 2 Advanced Sniper Tank Main gun
#----------------
UefBRNT2SNIPERproj = Class(MultiPolyTrailProjectile) {
    FxTrails = ModEffectTemplate.UEFArmoredBattleBotTrails,
    PolyTrailOffset = {0,0},    
    PolyTrails = ModEffectTemplate.UEFArmoredBattleBotPolyTrails,
    FxImpactUnit = ModEffectTemplate.UEFT2snipertankhit01,
    FxUnitHitScale = 0.5,
    FxImpactProp = ModEffectTemplate.UEFT2snipertankhit01,
    FxPropHitScale = 0.5,
    FxImpactLand = ModEffectTemplate.UEFT2snipertankhit01,
    FxLandHitScale = 0.5,
    FxImpactUnderWater = ModEffectTemplate.UEFT2snipertankhit01,
    FxImpactWater = ModEffectTemplate.UEFT2snipertankhit01,
    FxWaterHitScale = 0.5,
}

#----------------
# UEF Tech 3 Battle Tank main gun
#----------------
UefBRNT3BTproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.UefT3BattletankHit,
    FxUnitHitScale = 1.0,
    FxImpactProp = ModEffectTemplate.UefT3BattletankHit,
    FxPropHitScale = 1.0,
    FxImpactLand = ModEffectTemplate.UefT3BattletankHit,
    FxLandHitScale = 1.0,
    FxImpactUnderWater = ModEffectTemplate.UefT3BattletankHit,
    FxImpactWater = ModEffectTemplate.UefT3BattletankHit,
}

#----------------
# UEF Tech 1 Battle Tank main gun
#----------------
UefBRNT1BTproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.UefT1BattleTankHit,
    FxUnitHitScale = 0.9,
    FxImpactProp = ModEffectTemplate.UefT1BattleTankHit,
    FxPropHitScale = 0.9,
    FxImpactLand = ModEffectTemplate.UefT1BattleTankHit,
    FxLandHitScale = 0.9,
    FxImpactUnderWater = ModEffectTemplate.UefT1BattleTankHit,
    FxImpactWater = ModEffectTemplate.UefT1BattleTankHit,
}

#----------------
# UEF Tech 2 Heavy Tank main gun
#----------------
UefBRNT2HTproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.UefT2BattleTankHit,
    FxUnitHitScale = 1.1,
    FxImpactProp = ModEffectTemplate.UefT2BattleTankHit,
    FxPropHitScale = 1.1,
    FxImpactLand = ModEffectTemplate.UefT2BattleTankHit,
    FxLandHitScale = 1.1,
    FxImpactUnderWater = ModEffectTemplate.UefT2BattleTankHit,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

#----------------
# UEF Tech 2 Battle Tank main gun
#----------------
UefBRNT2BTproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.UefT2BattleTankHit2,
    FxUnitHitScale = 1.1,
    FxImpactProp = ModEffectTemplate.UefT2BattleTankHit2,
    FxPropHitScale = 1.1,
    FxImpactLand = ModEffectTemplate.UefT2BattleTankHit2,
    FxLandHitScale = 1.1,
    FxImpactUnderWater = ModEffectTemplate.UefT2BattleTankHit2,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

#----------------
# UEF Tech 2 Experimental Light Assault Mech Big Gun
#----------------
UefBRNT2EXLMproj = Class(MultiPolyTrailProjectile) {
    FxTrails = ModEffectTemplate.UEFArmoredBattleBotTrails,
    PolyTrailOffset = {0,0},    
    PolyTrails = ModEffectTemplate.UEFArmoredBattleBotPolyTrails,
    FxImpactUnit = ModEffectTemplate.BRNT2EXLMHit1,
    FxUnitHitScale = 2.1,
    FxImpactProp = ModEffectTemplate.BRNT2EXLMHit1,
    FxPropHitScale = 2.1,
    FxImpactLand = ModEffectTemplate.BRNT2EXLMHit1,
    FxLandHitScale = 2.1,
    FxImpactUnderWater = ModEffectTemplate.BRNT2EXLMHit1,
}

#----------------
# UEF Tech 1 Medium Tank main gun
#----------------
UefBRNT1MTproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.UefT1MedTankHit,
    FxUnitHitScale = 0.7,
    FxImpactProp = ModEffectTemplate.UefT1MedTankHit,
    FxPropHitScale = 0.7,
    FxImpactLand = ModEffectTemplate.UefT1MedTankHit,
    FxLandHitScale = 0.7,
    FxImpactUnderWater = ModEffectTemplate.UefT1MedTankHit,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

#----------------
# UEF Tech 3 Armored Battle Bot Main guns
#----------------
UefBRNT3ABBproj = Class(MultiPolyTrailProjectile) {
	FxImpactLand = ModEffectTemplate.UEFArmoredBattleBotHit,
    FxImpactNone = ModEffectTemplate.UEFArmoredBattleBotHit,
    FxImpactProp = ModEffectTemplate.UEFArmoredBattleBotHit,    
    FxImpactUnit = ModEffectTemplate.UEFArmoredBattleBotHit,
    FxLandHitScale = 1.3,
    FxPropHitScale = 1.3,
    FxUnitHitScale = 1.3,
    FxTrails = ModEffectTemplate.UEFArmoredBattleBotTrails,
    PolyTrailOffset = {0,0},    
    PolyTrails = ModEffectTemplate.UEFArmoredBattleBotPolyTrails,
}

#----------------
# UEF experimental Blood Asp gun
#----------------
UefBRNT3BLASPproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/laserturret_munition_beam_03_emit.bp',
    FxImpactUnit = ModEffectTemplate.UEFHighExplosiveShellHit01,
    FxUnitHitScale = 1.9,
    FxImpactProp = ModEffectTemplate.UEFHighExplosiveShellHit01,
    FxPropHitScale = 1.9,
    FxImpactLand = ModEffectTemplate.UEFHighExplosiveShellHit01,
    FxLandHitScale = 1.9,
    FxImpactUnderWater = ModEffectTemplate.UEFHighExplosiveShellHit01,
    FxImpactWater = ModEffectTemplate.UEFHighExplosiveShellHit01,
}

#----------------
# UEF Tech 3 Battle Tank rockets
#----------------
UefBRNT3BTRLproj = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.UefT3BattletankRocketHit,
    FxUnitHitScale = 0.8,
    FxImpactProp = ModEffectTemplate.UefT3BattletankRocketHit,
    FxPropHitScale = 0.8,
    FxImpactLand = ModEffectTemplate.UefT3BattletankRocketHit,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = ModEffectTemplate.UefT3BattletankRocketHit,
    FxImpactWater = ModEffectTemplate.UefT3BattletankRocketHit,
}

#----------------
# UEF Tech Experimental MAYHEM new rockets
#----------------
UefBRNT3SHBMNEWRLproj = Class(SingleBeamProjectile) {
    FxTrailOffset = -0.8,
    FxTrails = EffectTemplate.TMissileExhaust03,
    FxImpactUnit = ModEffectTemplate.UEFmayhemRocketHit,
    FxUnitHitScale = 1.2,
    FxImpactProp = ModEffectTemplate.UEFmayhemRocketHit,
    FxPropHitScale = 1.2,
    FxImpactLand = ModEffectTemplate.UEFmayhemRocketHit,
    FxLandHitScale = 1.2,
    FxImpactUnderWater = ModEffectTemplate.UEFmayhemRocketHit,
    FxImpactWater = ModEffectTemplate.UEFmayhemRocketHit,
}

#----------------
# UEF Doomsday Main TriGuns
#----------------
UefBRNT3DOOMSGUNproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.UEFDeath02,
    FxUnitHitScale = 0.9,
    FxImpactProp = ModEffectTemplate.UEFDeath02,
    FxPropHitScale = 0.9,
    FxImpactLand = ModEffectTemplate.UEFDeath02,
    FxLandHitScale = 0.9,
    FxImpactUnderWater = ModEffectTemplate.UEFDeath02,
    FxImpactWater = ModEffectTemplate.UEFDeath02,
}

#----------------
# UEF Doomsday Missiles
#----------------
UefBRNT3DOOMSDAYproj = Class(SingleBeamProjectile) {
    FxTrailOffset = -0.8,
    FxTrails = EffectTemplate.TMissileExhaust03,
    FxImpactUnit = ModEffectTemplate.UEFmayhemRocketHit,
    FxUnitHitScale = 1.7,
    FxImpactProp = ModEffectTemplate.UEFmayhemRocketHit,
    FxPropHitScale = 1.7,
    FxImpactLand = ModEffectTemplate.UEFmayhemRocketHit,
    FxLandHitScale = 1.7,
    FxImpactUnderWater = ModEffectTemplate.UEFmayhemRocketHit,
    FxImpactWater = ModEffectTemplate.UEFmayhemRocketHit,
}

#----------------
# UEF Tech Experimental MAYHEM new rockets small
#----------------
UefBRNT3SHBMNEWRL2proj = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -0.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.UEFmayhemRocketHit2,
    FxUnitHitScale = 0.8,
    FxImpactProp = ModEffectTemplate.UEFmayhemRocketHit2,
    FxPropHitScale = 0.8,
    FxImpactLand = ModEffectTemplate.UEFmayhemRocketHit2,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = ModEffectTemplate.UEFmayhemRocketHit2,
    FxImpactWater = ModEffectTemplate.UEFmayhemRocketHit2,
}

#----------------
# UEF Tech 2 Jackhammer mk2 new rockets
#----------------
UefUEFT2Exocet = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -1.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.UEFmayhemRocketHit2,
    FxUnitHitScale = 0.8,
    FxImpactProp = ModEffectTemplate.UEFmayhemRocketHit2,
    FxPropHitScale = 0.8,
    FxImpactLand = ModEffectTemplate.UEFmayhemRocketHit2,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = ModEffectTemplate.UEFmayhemRocketHit2,
    FxImpactWater = ModEffectTemplate.UEFmayhemRocketHit2,
}

#----------------
# UEF Tech 1 Experimental Assault Tank
#----------------
UefBRNT1EXM1proj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.UEFHighExplosiveShellHit01,	
    FxUnitHitScale = 1.5,
    FxImpactProp = ModEffectTemplate.UEFHighExplosiveShellHit01,
    FxPropHitScale = 1.5,
    FxImpactLand = ModEffectTemplate.UEFHighExplosiveShellHit01,
    FxLandHitScale = 1.5,
    FxImpactUnderWater = ModEffectTemplate.UEFHighExplosiveShellHit01,
    FxImpactWater = ModEffectTemplate.UEFHighExplosiveShellHit01,
}

#----------------
# UEF Tech 3 Ultra Heavy Battle Mech Rockets
#----------------
UefBRNT3SHBMproj = Class(MultiPolyTrailProjectile) {
    FxInitial = {},
    TrailDelay = 1,
    FxTrails = {'/effects/emitters/missile_sam_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    FxImpactUnit = ModEffectTemplate.UEFHighExplosiveShellHit02,
    FxUnitHitScale = 0.6,
    FxImpactProp = ModEffectTemplate.UEFHighExplosiveShellHit02,
    FxPropHitScale = 0.6,
    FxImpactLand = ModEffectTemplate.UEFHighExplosiveShellHit02,
    FxLandHitScale = 0.6,
    FxImpactUnderWater = ModEffectTemplate.UEFHighExplosiveShellHit02,
    FxImpactWater = ModEffectTemplate.UEFHighExplosiveShellHit02,
}

#----------------
# UEF Tech 2 Experimental Point Defense
#----------------
UefBRNT2EPDproj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.TPlasmaCannonHeavyMunition,
    RandomPolyTrails = 1,
    PolyTrailOffset = {0,0,0},
    PolyTrails = EffectTemplate.TPlasmaCannonHeavyPolyTrails,
    FxImpactUnit = ModEffectTemplate.UefT2EPDPlasmaHit01,
    FxUnitHitScale = 1.7,
    FxImpactProp = ModEffectTemplate.UefT2EPDPlasmaHit01,
    FxPropHitScale = 1.7,
    FxImpactLand = ModEffectTemplate.UefT2EPDPlasmaHit01,
    FxLandHitScale = 1.7,
    FxImpactUnderWater = ModEffectTemplate.UefT2EPDPlasmaHit01,
    FxImpactWater = ModEffectTemplate.UefT2EPDPlasmaHit01,
}

#----------------
# UEF Tech 3 Super Heavy Point Defense
#----------------
UefBRNT3SHPDproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.UefT3SHPDGaussHit01,
    FxUnitHitScale = 1.4,
    FxImpactProp = ModEffectTemplate.UefT3SHPDGaussHit01,
    FxPropHitScale = 1.4,
    FxImpactLand = ModEffectTemplate.UefT3SHPDGaussHit01,
    FxLandHitScale = 1.4,
    FxImpactUnderWater = ModEffectTemplate.UefT3SHPDGaussHit01,
    FxImpactWater = ModEffectTemplate.UefT3SHPDGaussHit01,
}

#----------------
# UEF Experimental Mobile Fortress Main Guns
#----------------
UefBRNT3MOBproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
	FxTrails  = {
            '/mods/M&B/effects/emitters/w_u_gau03_p_03_brightglow_emit.bp',
            '/mods/M&B/effects/emitters/w_u_gau03_p_04_smoke_emit.bp',
	},
	PolyTrails  = {
            '/mods/M&B/effects/emitters/w_u_gau03_p_01_polytrails_emit.bp',
            '/mods/M&B/effects/emitters/w_u_gau03_p_02_polytrails_emit.bp',
	},
    FxImpactUnit = ModEffectTemplate.UefMobileFortressGunhit,
    FxUnitHitScale = 1.5,
    FxImpactProp = ModEffectTemplate.UefMobileFortressGunhit,
    FxPropHitScale = 1.5,
    FxImpactLand = ModEffectTemplate.UefMobileFortressGunhit,
    FxLandHitScale = 1.5,
    FxImpactUnderWater = ModEffectTemplate.UefMobileFortressGunhit,
    FxImpactWater = ModEffectTemplate.UefMobileFortressGunhit,
}

#----------------
# UEF Tech 2 Heavy Tank rockets
#----------------
UefBRNT2HTRLproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp',},
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = EffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxUnitHitScale = 0.45,
    FxImpactProp = EffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxPropHitScale = 0.45,
    FxImpactLand = EffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxLandHitScale = 0.45,
    FxImpactUnderWater = EffectTemplate.TShipGaussCannonHit02,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

#----------------
# UEF Tech 2 Medium Tank rockets
#----------------
UefBRNT2MTRLproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp',},
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxUnitHitScale = 0.75,
    FxImpactProp = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxPropHitScale = 0.75,
    FxImpactLand = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxLandHitScale = 0.75,
    FxImpactUnderWater = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

#----------------
# UEF Tech 3 Heavy Rockets (Rocket Battery)
#----------------
UefBRNT3MLproj = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.UEFHighExplosiveRocketHit,
    FxUnitHitScale = 1.8,
    FxImpactProp = ModEffectTemplate.UEFHighExplosiveRocketHit,
    FxPropHitScale = 1.8,
    FxImpactLand = ModEffectTemplate.UEFHighExplosiveRocketHit,
    FxLandHitScale = 1.8,
    FxImpactUnderWater = ModEffectTemplate.UEFHighExplosiveRocketHit,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

#----------------
# UEF Tech 3 Rocket Defense
#----------------
UefBRNT3PDROproj = Class(SingleBeamProjectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp',},
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.UEFHEAVYROCKET02,
    FxUnitHitScale = 2.2,
    FxImpactProp = ModEffectTemplate.UEFHEAVYROCKET02,
    FxPropHitScale = 2.2,
    FxImpactLand = ModEffectTemplate.UEFHEAVYROCKET02,
    FxLandHitScale = 2.2,
    FxImpactUnderWater = ModEffectTemplate.UEFHEAVYROCKET02,
    FxImpactWater = ModEffectTemplate.UEFHEAVYROCKET02,
    FxWaterHitScale = 2.2,
}

#----------------
# UEF Tech 2 Experimental Missile Launcher
#----------------
UefBRNT2EXM2proj = Class(MultiPolyTrailProjectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp',},
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.UEFHEAVYMISSILE01,
    FxUnitHitScale = 2.2,
    FxImpactProp = ModEffectTemplate.UEFHEAVYMISSILE01,
    FxPropHitScale = 2.2,
    FxImpactLand = ModEffectTemplate.UEFHEAVYMISSILE01,
    FxLandHitScale = 2.2,
    FxImpactUnderWater = ModEffectTemplate.UEFHEAVYMISSILE01,
    FxImpactWater = ModEffectTemplate.UEFHEAVYMISSILE01,
    FxWaterHitScale = 2.2,
}

#----------------
# UEF Tech 3 Battle Mech main gun
#----------------
UefBRNT3WKproj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.TPlasmaCannonHeavyMunition,
    RandomPolyTrails = 1,
    PolyTrailOffset = {0,0,0},
    PolyTrails = EffectTemplate.TPlasmaCannonHeavyPolyTrails,
    FxImpactUnit = ModEffectTemplate.UEFHeavyMechHit01,
    FxUnitHitScale = 1.0,
    FxImpactProp = ModEffectTemplate.UEFHeavyMechHit01,
    FxPropHitScale = 1.0,
    FxImpactLand = ModEffectTemplate.UEFHeavyMechHit01,
    FxLandHitScale = 1.0,
    FxImpactUnderWater = ModEffectTemplate.UEFHeavyMechHit01,
    FxImpactWater = ModEffectTemplate.UEFHeavyMechHit01,
    FxWaterHitScale = 1.0,
}

#----------------
# UEF Tech 3 Battle Mech rockets
#----------------
UefBRNT3WKRLproj = Class(MultiPolyTrailProjectile) {
    FxInitial = {},
    TrailDelay = 1,
    FxTrails = {'/effects/emitters/missile_sam_munition_trail_01_emit.bp',},
    FxTrailOffset = -0.5,
    FxImpactUnit = EffectTemplate.TShipGaussCannonHit02,
    FxUnitHitScale = 1.8,
    FxImpactProp = EffectTemplate.TShipGaussCannonHit02,
    FxPropHitScale = 1.8,
    FxImpactLand = EffectTemplate.TShipGaussCannonHit02,
    FxLandHitScale = 1.8,
    FxImpactUnderWater = EffectTemplate.TShipGaussCannonHit02,
    FxImpactWater = EffectTemplate.TShipGaussCannonHit02,
}



#			----------------
# 			DEATH EXPLOSIONS
#			----------------

#----------------
# Cybran Tech 3 Rocket Defense
#----------------
CybBRMT1Dproj = Class(NullShell) {
    FxImpactUnit = EffectTemplate.CMobileKamikazeBombExplosion,
    FxUnitHitScale = 1.35,
    FxImpactProp = EffectTemplate.CMobileKamikazeBombExplosion,
    FxPropHitScale = 1.35,
    FxImpactLand = EffectTemplate.CMobileKamikazeBombExplosion,
    FxLandHitScale = 1.35,
    FxImpactUnderWater = EffectTemplate.CMobileKamikazeBombExplosion,
    FxImpactWater = EffectTemplate.CMobileKamikazeBombExplosion,
    FxWaterHitScale = 1.35,
    FxTrailOffset = 0,
}



#----------------
# Cybran Tech 3 Heavy Rockets FFAR Class
#----------------
CybBRMT3FFARproj = Class(MultiPolyTrailProjectile) {
	FxTrails  = {
            '/mods/M&B/effects/emitters/w_u_gau03_p_03_brightglow_emit.bp',
            '/mods/M&B/effects/emitters/w_u_gau03_p_04_smoke_emit.bp',
	},
	FxTrailOffset = 0.2,
	PolyTrails  = {
            '/mods/M&B/effects/emitters/w_u_gau03_p_01_polytrails_emit.bp',
            '/mods/M&B/effects/emitters/w_u_gau03_p_02_polytrails_emit.bp',
	},
	PolyTrailOffset = {0.3,0},

    FxImpactUnit = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxUnitHitScale = 0.25,
    FxImpactProp = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxPropHitScale = 0.25,
    FxImpactLand = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxLandHitScale = 0.25,
    FxImpactUnderWater = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxImpactWater = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxWaterHitScale = 0.25,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 2 Vulture Molecular Cannon
#----------------
CybMadCatMolecular2 = Class(MultiPolyTrailProjectile) {
    PolyTrails = ModEffectTemplate.VultureMolecularPolyTrail,
    FxImpactUnit = ModEffectTemplate.CybranT2BattleTankHit,
    FxUnitHitScale = 0.4,
    FxImpactProp = ModEffectTemplate.CybranT2BattleTankHit,
    FxPropHitScale = 0.4,
    FxImpactLand = ModEffectTemplate.CybranT2BattleTankHit,
    FxLandHitScale = 0.4,
    FxImpactUnderWater = ModEffectTemplate.CybranT2BattleTankHit,
    FxImpactWater = ModEffectTemplate.CybranT2BattleTankHit,
}

#----------------
# UEF Tech 3 Heavy Rockets FFAR Class
#----------------
UefBRNT3FFARproj = Class(MultiPolyTrailProjectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp',},
    FxTrailOffset = -1,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.UEFHighExplosiveRocketHit,
    FxUnitHitScale = 0.8,
    FxImpactProp = ModEffectTemplate.UEFHighExplosiveRocketHit,
    FxPropHitScale = 0.8,
    FxImpactLand = ModEffectTemplate.UEFHighExplosiveRocketHit,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = ModEffectTemplate.UEFHighExplosiveRocketHit,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
}

#----------------
# Cybran Tech 3 Heavy Rockets FFAR Class
#----------------
CybBRMT3FFAR2proj = Class(MultiPolyTrailProjectile) {
	FxTrails  = {
            '/mods/M&B/effects/emitters/w_u_gau03_p_03_brightglow_emit.bp',
            '/mods/M&B/effects/emitters/w_u_gau03_p_04_smoke_emit.bp',
	},
	FxTrailOffset = 0.2,
	PolyTrails  = {
            '/mods/M&B/effects/emitters/w_u_gau03_p_01_polytrails_emit.bp',
            '/mods/M&B/effects/emitters/w_u_gau03_p_02_polytrails_emit.bp',
	},
	PolyTrailOffset = {0.3,0},

    FxImpactUnit = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxUnitHitScale = 0.25,
    FxImpactProp = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxPropHitScale = 0.25,
    FxImpactLand = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxLandHitScale = 0.25,
    FxImpactUnderWater = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxImpactWater = ModEffectTemplate.CybranHeavyProtonRocketHit,
    FxWaterHitScale = 0.25,
    FxTrailOffset = 0,
}

#----------------
# Cybran Tech 1 Light Battle Mech Laser
#----------------
CybBRMT1BMproj = Class(MultiPolyTrailProjectile) {
    PolyTrails = ModEffectTemplate.LightLaserPolyTrail,
    FxImpactUnit = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxUnitHitScale = 0.6,
    FxImpactProp = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxPropHitScale = 0.6,
    FxImpactLand = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxLandHitScale = 0.6,
    FxImpactUnderWater = EffectTemplate.TPlasmaGatlingCannonUnitHit,
    FxImpactWater = EffectTemplate.TPlasmaGatlingCannonUnitHit,
}

#----------------
# Aeon Tech 3 Advanced Battle Ship main guns
#----------------
AeonBROST3BSHIPproj = Class(EmitterProjectile) {

    FxTrails = EffectTemplate.AOblivionCannonFXTrails02,
    FxImpactUnit = ModEffectTemplate.AeonBattleShipHit01,
    FxUnitHitScale = 1.7,
    FxImpactProp = ModEffectTemplate.AeonBattleShipHit01,
    FxPropHitScale = 1.7,
    FxImpactLand = ModEffectTemplate.AeonBattleShipHit01,
    FxLandHitScale = 1.7,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 2 Experimental Tank Hunter main gun
#----------------
AeonBROT2EXTHproj = Class(MultiPolyTrailProjectile) {

	PolyTrails  = {
            '/mods/M&B/effects/emitters/AeonT2EXTH_polytrails_emit.bp',
	},
    FxImpactUnit = ModEffectTemplate.AeonT2ExperimentalTankHunterHit01,
    FxUnitHitScale = 1,
    FxImpactProp = ModEffectTemplate.AeonT2ExperimentalTankHunterHit01,
    FxPropHitScale = 1,
    FxImpactLand = ModEffectTemplate.AeonT2ExperimentalTankHunterHit01,
    FxLandHitScale = 1,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Aeon Tech 3 Super Defense main gun
#----------------
AeonBROT3SHPD2proj = Class(MultiPolyTrailProjectile) {

	PolyTrails  = {
            '/mods/M&B/effects/emitters/AeonT3SHPD_polytrails_emit.bp',
	},
    FxImpactUnit = ModEffectTemplate.AeonT2ExperimentalTankHunterHit01,
    FxUnitHitScale = 1.25,
    FxImpactProp = ModEffectTemplate.AeonT2ExperimentalTankHunterHit01,
    FxPropHitScale = 1.25,
    FxImpactLand = ModEffectTemplate.AeonT2ExperimentalTankHunterHit01,
    FxLandHitScale = 1.25,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# UEF Tech 2 Experimental Artillery main gun
#----------------
UefBRNT2EXARTproj = Class(MultiPolyTrailProjectile) {
	PolyTrailOffset = {0.05,0.05,0.05},  
	PolyTrails  = {
            '/mods/M&B/effects/emitters/UEFT2EXART_polytrails_emit.bp',
            '/mods/M&B/effects/emitters/w_u_gau03_p_01_polytrails_emit.bp',
	},
    FxImpactUnit = ModEffectTemplate.UEFT2EXARTHit02,
    FxUnitHitScale = 1.0,
    FxImpactProp = ModEffectTemplate.UEFT2EXARTHit02,
    FxPropHitScale = 1.0,
    FxImpactLand = ModEffectTemplate.UEFT2EXARTHit02,
    FxLandHitScale = 1.0,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Cybran Tech 3 Advanced Battle Bot cannon
#----------------
CybBRMT3ADVBTBOTproj = Class(MultiPolyTrailProjectile) {

	PolyTrails  = {
            '/mods/M&B/effects/emitters/BRMT3ADVBTBOT_polytrails_emit.bp',
		'/effects/emitters/disintegrator_polytrail_02_emit.bp',
		'/effects/emitters/disintegrator_polytrail_03_emit.bp',
		'/effects/emitters/default_polytrail_03_emit.bp',
	},
    FxImpactUnit = ModEffectTemplate.CybranT3AdvancedBattleBotHit01,
    FxUnitHitScale = 1.25,
    FxImpactProp = ModEffectTemplate.CybranT3AdvancedBattleBotHit01,
    FxPropHitScale = 1.25,
    FxImpactLand = ModEffectTemplate.CybranT3AdvancedBattleBotHit01,
    FxLandHitScale = 1.25,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}
AeonBROAT3PRIDEproj = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/oblivion_cannon_munition_01_emit.bp'},
    FxImpactUnit = ModEffectTemplate.PrideHit01,
    FxUnitHitScale = 6.8,
    FxImpactProp = ModEffectTemplate.PrideHit01,
    FxPropHitScale = 6.8,
    FxImpactLand = ModEffectTemplate.PrideHit01,
    FxLandHitScale = 6.8,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},

    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_005_albedo', 45, 45, 850, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        EmitterProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

#----------------
# Aeon Prototype Hades ShoulderCannon
#----------------
AeonBROT3HADES2proj = Class(EmitterProjectile) {

    FxImpactUnit = ModEffectTemplate.ValiantHit,
    FxUnitHitScale = 2.55,
    FxImpactProp = ModEffectTemplate.ValiantHit,
    FxPropHitScale = 2.55,
    FxImpactLand = ModEffectTemplate.ValiantHit,
    FxLandHitScale = 2.55,
    FxImpactUnderWater = ModEffectTemplate.ValiantHit,
    FxImpactWater = ModEffectTemplate.ValiantHit,
    FxWaterHitScale = 2.55,
    FxTrails = EffectTemplate.SZthuthaamArtilleryProjectileFXTrails,
    PolyTrails = EffectTemplate.SZthuthaamArtilleryProjectilePolyTrails, 
    PolyTrailOffset = {0,0},

    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_002_albedo', 28, 28, 250, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        EmitterProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

#----------------
# Aeon Prototype Hades cannons
#----------------
AeonBROT3HADESproj = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/oblivion_cannon_munition_01_emit.bp'},
    FxImpactUnit = ModEffectTemplate.HadesHit01,
    FxUnitHitScale = 2.4,
    FxImpactProp = ModEffectTemplate.HadesHit01,
    FxPropHitScale = 2.4,
    FxImpactLand = ModEffectTemplate.HadesHit01,
    FxLandHitScale = 2.4,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},

    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_001_albedo', 6, 6, 250, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        EmitterProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

#----------------
# Aeon Prototype Flying Fortress Small Projectile
#----------------
AeonBROAT3PRIDESMALLproj = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/oblivion_cannon_munition_01_emit.bp'},
    FxImpactUnit = ModEffectTemplate.PrideSmallHit01,
    FxUnitHitScale = 2.4,
    FxImpactProp = ModEffectTemplate.PrideSmallHit01,
    FxPropHitScale = 2.4,
    FxImpactLand = ModEffectTemplate.PrideSmallHit01,
    FxLandHitScale = 2.4,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},

    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_001_albedo', 6, 6, 250, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        EmitterProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

#----------------
# Aeon Valiant bomb
#----------------
AeonBROAT3BOMBERproj = Class(EmitterProjectile) {

    FxImpactUnit = ModEffectTemplate.ValiantHit,
    FxUnitHitScale = 1.55,
    FxImpactProp = ModEffectTemplate.ValiantHit,
    FxPropHitScale = 1.55,
    FxImpactLand = ModEffectTemplate.ValiantHit,
    FxLandHitScale = 1.55,
    FxImpactUnderWater = ModEffectTemplate.ValiantHit,
    FxImpactWater = ModEffectTemplate.ValiantHit,
    FxWaterHitScale = 1.55,
    FxTrails = EffectTemplate.SZthuthaamArtilleryProjectileFXTrails,
    PolyTrails = EffectTemplate.SZthuthaamArtilleryProjectilePolyTrails, 
    PolyTrailOffset = {0,0},

    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_002_albedo', 15, 15, 250, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        EmitterProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

#----------------
# Cybran Eagle-Eye bomb
#----------------
CybBRMAT2ADVBOMBERproj = Class(EmitterProjectile) {

    FxImpactUnit = ModEffectTemplate.AvalancheRocketHit,
    FxUnitHitScale = 0.45,
    FxImpactProp = ModEffectTemplate.AvalancheRocketHit,
    FxPropHitScale = 0.45,
    FxImpactLand = ModEffectTemplate.AvalancheRocketHit,
    FxLandHitScale = 0.45,
    FxImpactUnderWater = ModEffectTemplate.AvalancheRocketHit,
    FxImpactWater = ModEffectTemplate.AvalancheRocketHit,
    FxWaterHitScale = 0.45,
    FxTrailOffset = -0.5,

    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_008_albedo', 5, 5, 250, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        EmitterProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

#----------------
# UEF Havoc Bomb
#----------------
UefBRNAT3BOMBERproj = Class(EmitterProjectile) {
    FxTrails = {},
    FxImpactUnit = ModEffectTemplate.UEFDeath02,
    FxImpactProp = ModEffectTemplate.UEFDeath02,
    FxPropHitScale = 1.25,
    FxUnitHitScale = 1.25,
    FxLandHitScale = 1.25,
    FxImpactLand = ModEffectTemplate.UEFDeath02,
    FxImpactUnderWater = {},

    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()
        CreateLightParticle( self, -1, army, 2.75, 4, 'sparkle_03', 'ramp_fire_03' )
        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_008_albedo', 12, 12, 550, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        EmitterProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

#----------------
# Aeon Experimental Novacat mk2 Smallguns
#----------------
AeonBROT3NCM2proj = Class(MultiPolyTrailProjectile) {

    PolyTrails  = {
            '/mods/M&B/effects/emitters/AeonT3NCM2_polytrails_emit.bp',
    },
    FxImpactUnit = EffectTemplate.SDFExperimentalPhasonProjHit01,
    FxUnitHitScale = 0.85,
    FxImpactProp = EffectTemplate.SDFExperimentalPhasonProjHit01,
    FxPropHitScale = 0.85,
    FxImpactLand = EffectTemplate.SDFExperimentalPhasonProjHit01,
    FxLandHitScale = 0.85,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_007_albedo', 5, 5, 250, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        MultiPolyTrailProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

#----------------
# UEF T1 Advanced Fighter Bomber missiles AA
#----------------
UefBRNAT1ADVFIGproj = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -0.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = EffectTemplate.TShipGaussCannonHit02,
    FxUnitHitScale = 0.55,
    FxImpactProp = EffectTemplate.TShipGaussCannonHit02,
    FxPropHitScale = 0.55,
    FxImpactLand = EffectTemplate.TShipGaussCannonHit02,
    FxLandHitScale = 0.55,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# UEF T2 Fighter missiles AA
#----------------
UefBRNAT2FIGHTERproj = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -0.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = EffectTemplate.TShipGaussCannonHit02,
    FxUnitHitScale = 0.55,
    FxImpactProp = EffectTemplate.TShipGaussCannonHit02,
    FxPropHitScale = 0.55,
    FxImpactLand = EffectTemplate.TShipGaussCannonHit02,
    FxLandHitScale = 0.55,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}

#----------------
# Cybran Avalanche Rockets
#----------------
CybBRMT3AVARLproj = Class(SingleBeamProjectile) {
    BeamName = '/effects/emitters/missile_exhaust_fire_beam_01_emit.bp',
    FxTrails = EffectTemplate.TMissileExhaust03,
    FxImpactUnit = ModEffectTemplate.AvalancheRocketHit,
    FxUnitHitScale = 1,
    FxImpactProp = ModEffectTemplate.AvalancheRocketHit,
    FxPropHitScale = 1,
    FxImpactLand = ModEffectTemplate.AvalancheRocketHit,
    FxLandHitScale = 1,
    FxImpactUnderWater = ModEffectTemplate.AvalancheRocketHit,
    FxImpactWater = ModEffectTemplate.AvalancheRocketHit,
    FxWaterHitScale = 1,
    FxTrailOffset = -0.5,

    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_003_albedo', 18, 18, 250, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        SingleBeamProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

#----------------
# UEF Mayhem mk4 Main Guns
#----------------
UefBRNT3SHBM2proj = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.SChronotronCannonProjectileFxTrails,
    PolyTrails = EffectTemplate.TGaussCannonPolyTrail,
    PolyTrailOffset = {0,0},
    FxImpactUnit = ModEffectTemplate.UEFMayhemMK4hit1,
    FxUnitHitScale = 1.2,
    FxImpactProp = ModEffectTemplate.UEFMayhemMK4hit1,
    FxPropHitScale = 1.2,
    FxImpactLand = ModEffectTemplate.UEFMayhemMK4hit1,
    FxLandHitScale = 1.2,
    FxImpactUnderWater = ModEffectTemplate.UEFMayhemMK4hit1,
    FxImpactWater = ModEffectTemplate.UEFMayhemMK4hit1,
    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()

        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_004_albedo', 11, 11, 250, 200, army )

            #local blanketSides = 12
            #local blanketAngle = (2*math.pi) / blanketSides
            #local blanketStrength = 1
            #local blanketVelocity = 2.25

            #for i = 0, (blanketSides-1) do
            #    local blanketX = math.sin(i*blanketAngle)
            #    local blanketZ = math.cos(i*blanketAngle)
            #    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            #        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            #end
        end
        MultiPolyTrailProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}

#----------------
# UEF Mayhem mk4 EMP weapon
#----------------
UefBRNT3SHBM2EMPproj = Class(MultiPolyTrailProjectile) {
    FxImpactUnit = ModEffectTemplate.UEFMayhemMK4hit1,
    FxUnitHitScale = 0,
    FxImpactProp = ModEffectTemplate.UEFMayhemMK4hit1,
    FxPropHitScale = 0,
    FxImpactLand = ModEffectTemplate.UEFMayhemMK4hit1,
    FxLandHitScale = 0,
    FxImpactUnderWater = ModEffectTemplate.UEFMayhemMK4hit1,
    FxImpactWater = ModEffectTemplate.UEFMayhemMK4hit1,
}

#----------------
# UEF MAYHEM mk4 new rockets
#----------------
UefBRNT3SHBMNEWRLAproj = Class(SingleBeamProjectile) {
    FxTrailOffset = -0.8,
    FxTrails = EffectTemplate.TMissileExhaust03,
    FxImpactUnit = ModEffectTemplate.UEFmayhemRocketHit,
    FxUnitHitScale = 1.2,
    FxImpactProp = ModEffectTemplate.UEFmayhemRocketHit,
    FxPropHitScale = 1.2,
    FxImpactLand = ModEffectTemplate.UEFmayhemRocketHit,
    FxLandHitScale = 1.2,
    FxImpactUnderWater = ModEffectTemplate.UEFmayhemRocketHit,
    FxImpactWater = ModEffectTemplate.UEFmayhemRocketHit,
}

#----------------
# UEF Tech Experimental MAYHEM new rockets
#----------------
UefBRNT3SHBMNEWRLAproj = Class(SingleBeamProjectile) {
    FxTrailOffset = -0.8,
    FxTrails = EffectTemplate.TMissileExhaust03,
    FxImpactUnit = ModEffectTemplate.UEFmayhemRocketHitA,
    FxUnitHitScale = 1.2,
    FxImpactProp = ModEffectTemplate.UEFmayhemRocketHitA,
    FxPropHitScale = 1.2,
    FxImpactLand = ModEffectTemplate.UEFmayhemRocketHitA,
    FxLandHitScale = 1.2,
    FxImpactUnderWater = ModEffectTemplate.UEFmayhemRocketHitA,
    FxImpactWater = ModEffectTemplate.UEFmayhemRocketHitA,
}

#----------------
# UEF MAYHEM mk4 new rockets small
#----------------
UefBRNT3SHBMNEWRL2Aproj = Class(SingleBeamProjectile) {
    FxTrails = EffectTemplate.TMissileExhaust02,
    FxTrailOffset = -0.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',
    FxImpactUnit = ModEffectTemplate.UEFmayhemRocketHit2A,
    FxUnitHitScale = 0.8,
    FxImpactProp = ModEffectTemplate.UEFmayhemRocketHit2A,
    FxPropHitScale = 0.8,
    FxImpactLand = ModEffectTemplate.UEFmayhemRocketHit2A,
    FxLandHitScale = 0.8,
    FxImpactUnderWater = ModEffectTemplate.UEFmayhemRocketHit2A,
    FxImpactWater = ModEffectTemplate.UEFmayhemRocketHit2A,
}

TBalrogMagmaCannon = Class(MultiPolyTrailProjectile) {
    FxImpactWater = ModEffectTemplate.TMagmaCannonHit,
    FxImpactLand = ModEffectTemplate.TMagmaCannonHit,
    FxImpactNone = ModEffectTemplate.TMagmaCannonHit,
    FxImpactProp = ModEffectTemplate.TMagmaCannonUnitHit,    
    FxImpactUnit = ModEffectTemplate.TMagmaCannonUnitHit,    
    FxTrails = ModEffectTemplate.TMagmaCannonFxTrails,

    # Using MultPolyTrail:
        PolyTrails = ModEffectTemplate.TMagmaCannonPolyTrails,
        PolyTrailOffset = {0,-1.55}, # original = {0,0}
    FxImpactProjectile = {},
    FxImpactUnderWater = {},
    
    # Adjusting scale for testing...remove and fix projectile if sizing desired
    FxTrailScale = 1.25,
}