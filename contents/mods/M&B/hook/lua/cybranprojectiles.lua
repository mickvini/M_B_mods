#****************************************************************************
#**
#**  File     :  /data/lua/modules/cybranprojectiles.lua
#**  Author(s): John Comes, Gordon Duclos
#**
#**  Summary  :
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
#------------------------------------------------------------------------
#  CYBRAN PROJECILES SCRIPTS
#------------------------------------------------------------------------
local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local OnWaterEntryEmitterProjectile = DefaultProjectileFile.OnWaterEntryEmitterProjectile
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
local MultiBeamProjectile = DefaultProjectileFile.MultiBeamProjectile
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local MultiPolyTrailProjectile = DefaultProjectileFile.MultiPolyTrailProjectile 
local SingleCompositeEmitterProjectile = DefaultProjectileFile.SingleCompositeEmitterProjectile
local DepthCharge = import('/lua/defaultantiprojectile.lua').DepthCharge
local NullShell = DefaultProjectileFile.NullShell
local EffectTemplate = import('/lua/EffectTemplates.lua')
local DefaultExplosion = import('/lua/defaultexplosions.lua')

CDisintegratorLaserProjectile3 = Class(MultiPolyTrailProjectile) {
    PolyTrails = {
		'/Mods/M&B/effects/Emitters/disintegrator_polytrail_07_emit.bp',
		
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
