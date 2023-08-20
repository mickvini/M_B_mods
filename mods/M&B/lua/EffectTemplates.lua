#****************************************************************************
TableCat = import('/lua/utilities.lua').TableCat
EmtBpPath = '/effects/emitters/'
EmtBpPathAlt = '/mods/M&B/effects/emitters/'
EmtBpPathTM = '/mods/M&B/effects/emitters/'
EmitterTempEmtBpPath = '/effects/emitters/temp/'

#---------------------------------------------------------------
# Test weapon
#---------------------------------------------------------------

AlchemistPhasonLaserBeam = { EmtBpPathAlt .. 'alchemist_phason_laser_beam_01_emit.bp' }

CybProtonCannonFXTrail01 =  { EmtBpPathAlt .. 'proton_cannon_fxtrail_01_emit.bp' }
CybProtonCannonFXTrail01MT =  { EmtBpPathAlt .. 'proton_cannon_fxtrailmt_01_emit.bp' }
CybProtonCannonFXTrail02 =  { EmtBpPathAlt .. 'proton_cannon_fxtrail_02_emit.bp' }
CybProtonCannonPolyTrail =  EmtBpPathAlt .. 'proton_cannon_polytrail_01_emit.bp'
CybProtonCannonPolyTrail02 =  EmtBpPathAlt .. 'proton_cannon_polytrail_02_emit.bp'

FlareSml01 = { EmtBpPath .. 'flare_01_emit.bp',}
FireCloudSml01 = {
    EmtBpPath .. 'fire_cloud_05_emit.bp',
    EmtBpPath .. 'fire_cloud_04_emit.bp',
}
ExplosionDebrisSml01 = {
    EmtBpPath .. 'destruction_explosion_debris_07_emit.bp',
    EmtBpPath .. 'destruction_explosion_debris_08_emit.bp',
    EmtBpPath .. 'destruction_explosion_debris_09_emit.bp',
}
GenericDebrisTrails01 = { EmtBpPath .. 'destruction_explosion_debris_trail_01_emit.bp',}
ExplosionEffectsSml01 = TableCat( FlareSml01, FireCloudSml01, ExplosionDebrisSml01, GenericDebrisTrails01 )

AvalancheRocketHit = {
    EmtBpPathAlt .. 'bigdistort_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'comedred_darkfire_emit.bp',	##	
    EmtBpPathAlt .. 'comedred_fire_emit.bp',	##
    EmtBpPathAlt .. 'comedred_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'madcatdeathring.bp',	##
    EmtBpPathAlt .. 'madcatredglow_02_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_01_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_02_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_03_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_04_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_05_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_06_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_07_emit.bp',
}

AMiasmaMunition02 = {
    EmtBpPath .. 'miasma_cloud_02_emit.bp',
}

AeonT1FighterPolyTrails = {
    EmtBpPathAlt .. 'aeonfigther_munition_emit.bp',
}

AMiasmaField01 = {
    EmtBpPath .. 'miasma_cloud_01_emit.bp',
}

OthuyElectricityStrikeBeam = {
	EmtBpPathAlt .. 'xsl0310a_seraphim_othuy_beam_01_emit.bp',
}

BRNT2EXLMPoly = {
    EmtBpPath .. 'seraphim_rifter_mobileartillery_polytrail_01_emit.bp',
    EmtBpPath .. 'plasma_cannon_polytrail_01_emit.bp',
    EmtBpPath .. 'plasma_cannon_polytrail_02_emit.bp',
    EmtBpPath .. 'plasma_cannon_polytrail_03_emit.bp',
}

BRNT1ADVBOTFXTrails01 = {
	EmtBpPathAlt .. 'uef_sinnuthe_fxtrails_01_emit.bp',
	EmtBpPathAlt .. 'uef_sinnuthe_fxtrails_02_emit.bp',
	EmtBpPathAlt .. 'uef_sinnuthe_fxtrails_03_emit.bp',
}

BRMT3EXBMPOWEREFFECT = {
    EmtBpPath .. 'economy_electricity_01_emit.bp',
}

BROST2ADVBATTLESHIPTRAILS = {
    EmtBpPathAlt .. 'aeont2battleship_01_emit.bp',
    EmtBpPathAlt .. 'aeont2battleship_02_emit.bp',
}

BROST2ADVBATTLESHIPHIT = {
    EmtBpPathAlt .. 'aeont2advbattleship_hit_01.bp', ## Cool exploding flames!!!
    EmtBpPathTM .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathTM .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathTM .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
    EmtBpPathTM .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPathTM .. 'comed_smoke_emit.bp',	##	
    EmtBpPathTM .. 'comed_darkfire_emit.bp',	##
    EmtBpPathTM .. 'comed_fire_emit.bp',	##	
	EmtBpPathTM .. 'ueft2experimental_missile_07_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_08_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_09_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_10_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_11_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_12_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_13_emit.bp',
    EmtBpPathAlt .. 'mayhemmk4blueglow2_emit.bp',	##	
}

BRNST2ADVBATTLESHIPHIT = {
    EmtBpPathAlt .. 'aeont2advbattleship_hit_01.bp', ## Cool exploding flames!!!
    EmtBpPathTM .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathTM .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathTM .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
    EmtBpPathTM .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPathTM .. 'comed_smoke_emit.bp',	##	
    EmtBpPathTM .. 'comed_darkfire_emit.bp',	##
    EmtBpPathTM .. 'comed_fire_emit.bp',	##	
	EmtBpPathTM .. 'ueft2experimental_missile_07_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_08_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_09_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_10_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_11_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_12_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_13_emit.bp',
    EmtBpPathAlt .. 'mayhemmk4blueglow2_emit.bp',	##	
}

AeonGraniteHit01 = {
    EmtBpPathAlt .. 'aeongranite_01_emit.bp',
    EmtBpPathAlt .. 'aeongranite_02_emit.bp',
    EmtBpPathAlt .. 'aeongranite_03_emit.bp',
    EmtBpPathAlt .. 'aeongranite_04_emit.bp',
    EmtBpPathAlt .. 'aeongranite_05_emit.bp',
    EmtBpPathAlt .. 'aeongranite_06_emit.bp',
    EmtBpPathAlt .. 'aeongranite_07_emit.bp',
    EmtBpPathAlt .. 'aeongranite_08_emit.bp',
}

SerT3SHBMHit01 = {
    EmtBpPathAlt .. 'seramegabot_01_emit.bp',
    EmtBpPathAlt .. 'seramegabot_02_emit.bp',
    EmtBpPathAlt .. 'seramegabot_03_emit.bp',
    EmtBpPathAlt .. 'seramegabot_04_emit.bp',
    EmtBpPathAlt .. 'seramegabot_05_emit.bp',
    EmtBpPathAlt .. 'seramegabot_06_emit.bp',
    EmtBpPathAlt .. 'seramegabot_07_emit.bp',
    EmtBpPathAlt .. 'seramegabot_08_emit.bp',
    EmtBpPathAlt .. 'seramegabot_09_emit.bp',
    EmtBpPathAlt .. 'seramegabot_10_emit.bp',
}

UEFT1ADVBOThit1 = {
    EmtBpPathAlt .. 'seramegabot_01b_emit.bp',
    EmtBpPathAlt .. 'seramegabot_02b_emit.bp',
    EmtBpPathAlt .. 'seramegabot_03b_emit.bp',
    EmtBpPathAlt .. 'seramegabot_04b_emit.bp',
    EmtBpPathAlt .. 'seramegabot_05b_emit.bp',
    EmtBpPathAlt .. 'seramegabot_06b_emit.bp',
    EmtBpPathAlt .. 'seramegabot_09b_emit.bp',
    EmtBpPathAlt .. 'seramegabot_10b_emit.bp',
}

SerT3SHBMDeath = {
    EmtBpPathAlt .. 'seramegabot_01a_emit.bp',
    EmtBpPathAlt .. 'seramegabot_02a_emit.bp',
    EmtBpPathAlt .. 'seramegabot_03a_emit.bp',
    EmtBpPathAlt .. 'seramegabot_04a_emit.bp',
    EmtBpPathAlt .. 'seramegabot_05a_emit.bp',
    EmtBpPathAlt .. 'seramegabot_06a_emit.bp',
    EmtBpPathAlt .. 'seramegabot_07a_emit.bp',
    EmtBpPathAlt .. 'seramegabot_08a_emit.bp',
    EmtBpPathAlt .. 'seramegabot_09a_emit.bp',
    EmtBpPathAlt .. 'seramegabot_10a_emit.bp',
    EmtBpPathAlt .. 'seramegabot_11a_emit.bp',
}

AeonGraniteDeath = {
    EmtBpPathAlt .. 'aeongranite_01_emit.bp',
    EmtBpPathAlt .. 'aeongranite_02_emit.bp',
    EmtBpPathAlt .. 'aeongranite_08_emit.bp',
    EmtBpPathAlt .. 'comed_smoke_emit.bp',
    EmtBpPathAlt .. 'comedaeon_fire_emit.bp',
    EmtBpPathAlt .. 'co_darkfire_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_02_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_03_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_04_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_05_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_06_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_07_emit.bp',
}

SerT1AdvancedTankHit01 = {
	EmtBpPathAlt .. 'seraphimt1advtank_hit_01_emit.bp',
	EmtBpPathAlt .. 'seraphimt1advtank_hit_03_emit.bp',
	EmtBpPathAlt .. 'seraphimt1advtank_hit_04_emit.bp',
	EmtBpPathAlt .. 'seraphimt1advtank_hit_05_emit.bp',
	EmtBpPathAlt .. 'seraphimt1advtank_hit_06_emit.bp',
	EmtBpPathAlt .. 'seraphimt1advtank_hit_07_emit.bp',
	EmtBpPathAlt .. 'seraphimt1advtank_hit_08_emit.bp',
	EmtBpPathAlt .. 'seraphimt1advtank_hit_09_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit04_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit05_emit.bp',
}

BRMT1EXTANKHIT = {
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit01_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit01b_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit02_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit03_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit04_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit05_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit06_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit07_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit06b_emit.bp',
}

BRMT1EXTANKTRAILS = {
    EmtBpPathAlt .. 'cybran_advancedt1tank_polytrail_01_emit.bp',
}

BRMT1EXTANKDEATH = {
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit01_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit01b_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit02_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit03_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit04_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit05deathring_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit06_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit07_emit.bp',
	EmtBpPathAlt .. 'cybran_advancedt1tank_hit06b_emit.bp',
}

BRNT2EXLMmuzzle = {
    '/effects/emitters/plasma_cannon_muzzle_flash_01_emit.bp',
    '/effects/emitters/plasma_cannon_muzzle_flash_02_emit.bp',
    '/effects/emitters/cannon_muzzle_flash_01_emit.bp',
    '/effects/emitters/heavy_plasma_cannon_hitunit_05_emit.bp',
	EmtBpPath .. 'seraphim_cleo_cannon_muzzle_flash_01_emit.bp',
	EmtBpPath .. 'seraphim_cleo_cannon_muzzle_flash_02_emit.bp',
	EmtBpPath .. 'seraphim_cleo_cannon_muzzle_flash_03_emit.bp',
}

BRNT2EXLMHit1 = {
	EmtBpPathAlt .. 'ueft2exlmbiggun_01_emit.bp',
	EmtBpPathAlt .. 'ueft2exlmbiggun_02_emit.bp',
	EmtBpPathAlt .. 'ueft2exlmbiggun_03_emit.bp',
	EmtBpPathAlt .. 'ueft2exlmbiggun_04_emit.bp',
	EmtBpPathAlt .. 'ueft2exlmbiggun_05_emit.bp',
	EmtBpPathAlt .. 'ueft2exlmbiggun_06_emit.bp',
	EmtBpPathAlt .. 'ueft2exlmbiggun_07_emit.bp',
	EmtBpPathAlt .. 'ueft2exlmbiggun_08_emit.bp',
}

AeonT2ExperimentalTankHunterHit01 = {
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_01_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_02_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_03_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_04_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_05_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_06_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_07_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_08_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_09_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_10_emit.bp',

}

AeonBattleShipHit01 = {
	EmtBpPathAlt .. 'ueft2experimental_missile_13_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_14_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon01_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon02_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon03_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon04_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon05_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon06_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon07_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon08_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon09_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon10_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon11_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon12_emit.bp',
}

AeonUnitDeathRing01 = {
	EmtBpPathAlt .. 'ueft2experimental_missile_13_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_14_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon01_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon11_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon12_emit.bp',
}

AeonUnitDeathRing02 = {
	EmtBpPathAlt .. 'ueft2experimental_missile_13_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_14_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_04_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_05_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_06_emit.bp',
}

AeonUnitDeathRing03 = {
	EmtBpPathAlt .. 'ueft2experimental_missile_13_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_05_emit.bp',
	EmtBpPathAlt .. 'AeonT2TankHunter_hit_06_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_12_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_13_emit.bp',
}

AeonExpT1ArtilleryHit = {
	EmtBpPathAlt .. 'ueft2experimental_missile_14_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon01_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon11_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon12_emit.bp',
}

CybranT3AdvancedBattleBotHit01 = {
	EmtBpPathAlt .. 'cybran_t2beetle_01_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_02_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_01_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_02_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_03_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_04_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_05_emit.bp',
	EmtBpPathAlt .. 'tm_kamibomb_hit_05_emit.bp', ## Red glow
	EmtBpPathAlt .. 'tmcybrant2battletankhit_07_emit.bp', ## black dots on ground
	EmtBpPathAlt .. 'bm2rockethit_06_emit.bp', ## ring
	EmtBpPathAlt .. 'hvyproton_cannon_hit_02_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_10_emit.bp', ## Exploding flames
    EmtBpPathAlt .. 'tmcybrant3battletankhit_distort_emit.bp',
	EmtBpPathAlt .. 'bm2rockethit_07_emit.bp', ## Ring effect
	EmtBpPathAlt .. 'tm_kamibomb_hit_08_emit.bp', ## White inner ring
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
	EmtBpPathAlt .. 'bm2rockethit_09_emit.bp', ## Red glow explosion with smoke
    EmtBpPathAlt .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'ueft2experimental_missile_11_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_12_emit.bp',
    EmtBpPathAlt .. 'tmcybrant2battletankhit_distort_emit.bp',
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
    EmtBpPath .. 'antimatter_hit_07_emit.bp',	##	base dark 
}

CybranT3AdvancedBattleBotDeath01 = {
	EmtBpPathAlt .. 'cybran_t2beetle_01_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_02_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_03_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_04_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_05_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_06_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_07_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_03_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_11_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_12_emit.bp',
    EmtBpPath .. 'antimatter_hit_09_emit.bp',	##	base smoke
    EmtBpPath .. 'antimatter_hit_07_emit.bp',	##	base dark 
}

CybranT2BeetleHit01 = {
	EmtBpPathAlt .. 'cybran_t2beetle_01_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_02_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_03_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_04_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_05_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_06_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_07_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhit_distort_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emita.bp', ## Exploding flames
    EmtBpPathAlt .. 'bm2rockethit_11_emitaa.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'co_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'co_darkfire_emit.bp',	##
}

MadCatDeath01 = {
	EmtBpPathAlt .. 'cybran_t2beetle_01_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_02_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_03_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_04_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_05_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_06_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_07_emit.bp',
    EmtBpPathAlt .. 'bigdistort_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emita.bp', ## Exploding flames
    EmtBpPathAlt .. 'bm2rockethit_11_emitaa.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'comedred_darkfire_emit.bp',	##	
    EmtBpPathAlt .. 'comedred_fire_emit.bp',	##
    EmtBpPathAlt .. 'comedred_smoke_emit.bp',	##	
}

MadCatDeath02 = {
	EmtBpPathAlt .. 'cybran_t2beetle_01_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_02_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_03_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_04_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_05_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_06_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_07_emit.bp',
    EmtBpPathAlt .. 'bigdistort_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emita.bp', ## Exploding flames
    EmtBpPathAlt .. 'bm2rockethit_11_emitaa.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'comedred_darkfire_emit.bp',	##	
    EmtBpPathAlt .. 'madcatredglow_01_emit.bp',	##	
    EmtBpPathAlt .. 'comedred2_fire_emit.bp',	##
    EmtBpPathAlt .. 'comedred_smoke_emit.bp',	##
}

MadCatDeath03 = {
	EmtBpPathAlt .. 'cybran_t2beetle_01_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_02_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_03_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_07_emit.bp',
    EmtBpPathAlt .. 'bigdistort_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'comedred_darkfire_emit.bp',	##	
    EmtBpPathAlt .. 'comedred_fire_emit.bp',	##
    EmtBpPathAlt .. 'comedred_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'madcatdeathring.bp',	##
    EmtBpPathAlt .. 'madcatredglow_01_emit.bp',
}

AvalancheRocketHit = {
    EmtBpPathAlt .. 'bigdistort_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'comedred_darkfire_emit.bp',	##	
    EmtBpPathAlt .. 'comedred_fire_emit.bp',	##
    EmtBpPathAlt .. 'comedred_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'madcatdeathring.bp',	##
    EmtBpPathAlt .. 'madcatredglow_02_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_01_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_02_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_03_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_04_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_05_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_06_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_07_emit.bp',
}

UEFDeath01 = {
	EmtBpPathAlt .. 'cybran_t2beetle_01_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_02_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_03_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_04_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_05_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_06_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_07_emit.bp',
    EmtBpPathAlt .. 'bigdistort_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emita.bp', ## Exploding flames
    EmtBpPathAlt .. 'bm2rockethit_11_emitaa.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'co_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'co_darkfire_emit.bp',	##
    EmtBpPathAlt .. 'co_fire_emit.bp',	##	
}

UEFDeath02 = {
	EmtBpPathAlt .. 'cybran_t2beetle_01_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_02_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_03_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_04_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_05_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_06_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_07_emit.bp',
    EmtBpPathAlt .. 'bigdistort_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emita.bp', ## Exploding flames
    EmtBpPathAlt .. 'bm2rockethit_11_emitaa.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'co_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'co_darkfire_emit.bp',	##
    EmtBpPathAlt .. 'co_fire_emit.bp',	##	
    EmtBpPath .. 'antimatter_ring_01_emit.bp',	##	ring14
    EmtBpPath .. 'antimatter_ring_02_emit.bp',	##	ring11
}

UEFDeath02a = {
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
    EmtBpPathAlt .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'comed_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'comed_darkfire_emit.bp',	##
    EmtBpPathAlt .. 'comed_fire_emit.bp',	##	
}

UEFDeath02b = {
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
    EmtBpPathAlt .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'comed_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'comed_darkfire_emit.bp',	##
    EmtBpPath .. 'antimatter_ring_01_emit.bp',	##	ring14
    EmtBpPath .. 'antimatter_ring_02_emit.bp',	##	ring11
    EmtBpPathAlt .. 'comed_fire_emit.bp',	##	
}

UEFDeath03 = {
    EmtBpPathAlt .. 'bigdistort_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
    EmtBpPathAlt .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'comed_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'comed_darkfire_emit.bp',	##
    EmtBpPathAlt .. 'comed_fire_emit.bp',	##	
}

UEFmayhemRocketHit = {
    EmtBpPathAlt .. 'bigdistort_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
    EmtBpPathAlt .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'comed_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'comed_darkfire_emit.bp',	##
    EmtBpPathAlt .. 'comed_fire_emit.bp',	##	
	EmtBpPathAlt .. 'ueft2experimental_missile_07_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_08_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_09_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_10_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_11_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_12_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_13_emit.bp',
}

UEFmayhemRocketHit2 = {
    EmtBpPathAlt .. 'bigdistort_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
    EmtBpPathAlt .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'cosml_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'cosml_darkfire_emit.bp',	##
    EmtBpPathAlt .. 'cosml_fire_emit.bp',	##	
}

UEFDeath04 = {
    EmtBpPathAlt .. 'bm2rockethit_01_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_02_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_03_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'comed_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'comed_darkfire_emit.bp',	##
    EmtBpPathAlt .. 'comed_fire_emit.bp',	##	
	EmtBpPathAlt .. 'ueft2experimental_missile_07_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_08_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_09_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_10_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_11_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_12_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_13_emit.bp',
}

UEFDeathSML01 = {
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'cosml_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'cosml_darkfire_emit.bp',	##
    EmtBpPathAlt .. 'cosml_fire_emit.bp',	##	
	EmtBpPathAlt .. 'bm2rockethit_09_emit.bp', ## Red glow explosion with smoke
}

RedGatlingCannonPolyTrails = {
    EmtBpPathAlt .. 'red_gatling_plasma_cannon_polytrail_01_emit.bp',
    EmtBpPathAlt .. 'red_gatling_plasma_cannon_polytrail_02_emit.bp',
    EmtBpPathAlt .. 'red_gatling_plasma_cannon_polytrail_03_emit.bp',
}

AeonT1FighterPolyTrails = {
    EmtBpPathAlt .. 'aeonfigther_munition_emit.bp',
}

GreenGatlingCannonPolyTrails = {
    EmtBpPathAlt .. 'green_gatling_plasma_cannon_polytrail_01_emit.bp',
    EmtBpPathAlt .. 'green_gatling_plasma_cannon_polytrail_02_emit.bp',
    EmtBpPathAlt .. 'green_gatling_plasma_cannon_polytrail_03_emit.bp',
}

YellowLaserPolyTrails = {
    EmtBpPathAlt .. 'yellowlaser_polytrail_01_emit.bp',
}

VultureMolecularPolyTrail = {
    EmtBpPathAlt .. 'vulture_polytrail_01_emit.bp',
}

LightLaserPolyTrail = {
    EmtBpPathAlt .. 'LightLaserPolyTrail_polytrail_01_emit.bp',
}

HeavyLaserPolyTrail = {
    EmtBpPathAlt .. 'HeavyLaserPolyTrail_polytrail_01_emit.bp',
}

UEFArmoredBattleBotTrails = {
	EmtBpPath .. 'seraphim_tau_cannon_projectile_01_emit.bp',
	EmtBpPath .. 'seraphim_tau_cannon_projectile_02_emit.bp',	
}

UEFArmoredBattleBotPolyTrails = {
	EmtBpPath .. 'seraphim_tau_cannon_projectile_polytrail_01_emit.bp',
    EmtBpPath .. 'seraphim_heavyquarnon_cannon_projectile_trail_02_emit.bp',
}

UEFArmoredBattleBotHit = {
    EmtBpPath .. 'seraphim_tau_cannon_projectile_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_tau_cannon_projectile_hit_03_flat_emit.bp',
}

UEFT2snipertankhit01 = {
    EmtBpPath .. 'seraphim_tau_cannon_projectile_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_tau_cannon_projectile_hit_03_flat_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_13_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_14_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_03_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_06_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_07_emit.bp',
}

UEFHEAVYMISSILE01 = {
	EmtBpPathAlt .. 'ueft2experimental_missile_01_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_02_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_03_emit.bp',

	EmtBpPathAlt .. 'ueft2experimental_missile_05_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_06_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_07_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_08_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_09_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_10_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_11_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_12_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_13_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_14_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_15_emit.bp',
}

UEFT2EXARTHit02 = {
    EmtBpPath .. 'hvyproton_cannon_hit_distort_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon08_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon09_emit.bp',
	EmtBpPathAlt .. 'aeon_battleshipcannon10_emit.bp',
    EmtBpPath .. 'antimatter_hit_04_emit.bp',	##	plume fire
	EmtBpPathAlt .. 'ueft2experimental_missile_06_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_07_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_08_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_09_emit.bp',
	EmtBpPathAlt .. 'ueft2experimental_missile_10_emit.bp',
    EmtBpPath .. 'antimatter_hit_11_emit.bp',	##	base highlights
    EmtBpPath .. 'antimatter_ring_01_emit.bp',	##	ring14
    EmtBpPath .. 'antimatter_ring_02_emit.bp',	##	ring11	
    EmtBpPathAlt .. 'quantum_hit_flash_02_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_03_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_06_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_07_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_09_emit.bp',
	EmtBpPathAlt .. 'bm2rockethit_09_emit.bp', ## Red glow explosion with smoke
    EmtBpPathAlt .. 'bm2rockethit_11a_emit.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPath .. 'antimatter_hit_09_emit.bp',	##	base smoke
    EmtBpPath .. 'antimatter_hit_06_emit.bp',	##	base fire
    EmtBpPath .. 'antimatter_hit_07_emit.bp',	##	base dark
}

UefMobileFortressGunhit = {
    EmtBpPath .. 'hvyproton_cannon_hit_distort_emit.bp',
    EmtBpPath .. 'antimatter_hit_01_emit.bp',	##	glow	
    EmtBpPath .. 'antimatter_hit_02_emit.bp',	##	flash	     
    EmtBpPath .. 'antimatter_hit_03_emit.bp', 	##	sparks
    EmtBpPath .. 'antimatter_hit_04_emit.bp',	##	plume fire
    EmtBpPath .. 'antimatter_hit_05_emit.bp',	##	plume dark 
    EmtBpPath .. 'antimatter_hit_06_emit.bp',	##	base fire
    EmtBpPath .. 'antimatter_hit_07_emit.bp',	##	base dark 
    EmtBpPath .. 'antimatter_hit_08_emit.bp',	##	plume smoke
    EmtBpPath .. 'antimatter_hit_09_emit.bp',	##	base smoke
    EmtBpPath .. 'antimatter_hit_10_emit.bp',	##	plume highlights
    EmtBpPath .. 'antimatter_hit_11_emit.bp',	##	base highlights
    EmtBpPath .. 'antimatter_ring_01_emit.bp',	##	ring14
    EmtBpPath .. 'antimatter_ring_02_emit.bp',	##	ring11	
    EmtBpPath .. 'seraphim_inaino_hit_03_emit.bp',			## long glow
    EmtBpPath .. 'seraphim_khamaseen_bomb_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_khamaseen_bomb_hit_02_emit.bp',
    EmtBpPath .. 'seraphim_khamaseen_bomb_hit_04_emit.bp',
    EmtBpPath .. 'seraphim_khamaseen_bomb_hit_06_emit.bp',
    EmtBpPath .. 'seraphim_khamaseen_bomb_hit_08_emit.bp',
    EmtBpPath .. 'seraphim_khamaseen_bomb_hit_09_emit.bp',
    EmtBpPath .. 'seraphim_khamaseen_bomb_hit_10_emit.bp',
    EmtBpPath .. 'seraphim_khamaseen_bomb_hit_11_emit.bp',
    EmtBpPath .. 'shockwave_01_emit.bp', 
}

CYBRANHEAVYPROTONARTILLERYHIT01 = {
	EmtBpPath .. 'hvyproton_cannon_hit_01_emit.bp',
	EmtBpPath .. 'hvyproton_cannon_hit_02_emit.bp',
	EmtBpPath .. 'hvyproton_cannon_hit_03_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_04_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_05_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_07_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_09_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_10_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_distort_emit.bp',
    EmtBpPath .. 'dust_cloud_06_emit.bp',
    EmtBpPath .. 'dirtchunks_01_emit.bp',
    EmtBpPath .. 'molecular_resonance_cannon_ring_02_emit.bp',
}

UEFHEAVYROCKET = {
EmtBpPath .. 'flash_01_emit.bp',
	EmtBpPath .. 'quark_bomb_explosion_06_emit.bp',	    
    EmtBpPath .. 'antimatter_ring_01_emit.bp',	##	ring14
    EmtBpPath .. 'antimatter_ring_02_emit.bp',	##	ring11	 
	EmtBpPath .. 'antimatter_hit_12_emit.bp',	
	EmtBpPath .. 'antimatter_hit_13_emit.bp',	     
	EmtBpPath .. 'antimatter_hit_14_emit.bp',   
	EmtBpPath .. 'antimatter_hit_15_emit.bp',  
	EmtBpPath .. 'antimatter_hit_16_emit.bp',
}

UEFHEAVYROCKET02 = {
    EmtBpPathAlt .. 'quantum_hit_flash_01_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_02_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_03_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_04_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_05_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_06_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_07_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_09_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_08_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_02b_emit.bp',
}

CybranT1BattleTankHit = {
	EmtBpPath .. 'hvyproton_cannon_hit_01_emit.bp',
	EmtBpPath .. 'hvyproton_cannon_hit_02_emit.bp',
	EmtBpPath .. 'hvyproton_cannon_hit_03_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_04_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_05_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_07_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_09_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_10_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_distort_emit.bp',
    EmtBpPathAlt .. 'tmcybrant1battletank_emit.bp',
    EmtBpPathAlt .. 'tmcybrant1battletank3_emit.bp',
    EmtBpPathAlt .. 'tmcybrant1battletank2_emit.bp',
}

CybranT2BattleTankHit = {
    EmtBpPathAlt .. 'tmcybrant2battletankhit_distort_emit.bp',
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
	EmtBpPathAlt .. 'tmcybrant2battletankhit_02_emit.bp', ## Red glow
	EmtBpPathAlt .. 'tmcybrant2battletankhit_03_emit.bp', ## white sparks flying opposite direction of impact
	EmtBpPathAlt .. 'tmcybrant2battletankhit_04_emit.bp', ## dirt flying
	EmtBpPathAlt .. 'tmcybrant2battletankhit_05_emit.bp', ## ring
	EmtBpPathAlt .. 'tmcybrant2battletankhit_06_emit.bp', ## white glow in middle
	EmtBpPathAlt .. 'tmcybrant2battletankhit_07_emit.bp', ## black dots on ground
	EmtBpPathAlt .. 'tmcybrant2battletankhit_08_emit.bp', ## white exploding glow in middle
	EmtBpPathAlt .. 'tmcybrant2battletankhit_09_emit.bp', ## black exploding dots in middle
}

AEONT2HEAVYHOVERTANKHIT = {
	EmtBpPathAlt .. 'aeont2hovertankhit_01_emit.bp', ## sparks
	EmtBpPathAlt .. 'aeont2hovertankhit_02_emit.bp', ## black smoke
	EmtBpPathAlt .. 'aeont2hovertankhit_03_emit.bp', ##
	EmtBpPathAlt .. 'aeont2hovertankhit_04_emit.bp', ##
	EmtBpPathAlt .. 'aeont2hovertankhit_05_emit.bp', ##
	EmtBpPathAlt .. 'aeont2hovertankhit_06_emit.bp', ##
	EmtBpPathAlt .. 'aeont2hovertankhit_07_emit.bp', ##
	EmtBpPathAlt .. 'aeont2hovertankhit_08_emit.bp', ##
	EmtBpPathAlt .. 'aeont2hovertankhit_09_emit.bp', ##
}

CybranT3HVYTankHit = {
    EmtBpPathAlt .. 'tmcybrant2battletankhit_distort_emit.bp',
	EmtBpPathAlt .. 'tmcybrant2battletankhit_02_emit.bp', ## Red glow
	EmtBpPathAlt .. 'tmcybrant2battletankhit_03_emit.bp', ## white sparks flying opposite direction of impact
	EmtBpPathAlt .. 'tmcybrant2battletankhit_04_emit.bp', ## dirt flying
	EmtBpPathAlt .. 'tmcybrant2battletankhit_08_emit.bp', ## white exploding glow in middle
	EmtBpPathAlt .. 'tmcybrant2battletankhit_09_emit.bp', ## black exploding dots in middle
	EmtBpPathAlt .. 'tm_kamibomb_hit_09a_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'hvyproton_cannon_hit_05_emit.bp',
    EmtBpPathAlt .. 'hvyproton_cannon_hit_07_emit.bp',
    EmtBpPath .. 'hiro_laser_cannon_hit_01_emit.bp',
    EmtBpPath .. 'hiro_laser_cannon_hit_02_emit.bp',
    EmtBpPath .. 'hiro_laser_cannon_hit_03_emit.bp',
    EmtBpPath .. 'hiro_laser_cannon_hit_04_emit.bp',
}

CybranT3BattleTankHit = {
	EmtBpPathAlt .. 'hvyproton_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_03_emit.bp',
    EmtBpPathAlt .. 'hvyproton_cannon_hit_04_emit.bp',
    EmtBpPathAlt .. 'hvyproton_cannon_hit_05_emit.bp',
    EmtBpPathAlt .. 'hvyproton_cannon_hit_07_emit.bp',
    EmtBpPathAlt .. 'hvyproton_cannon_hit_09_emit.bp',
    EmtBpPathAlt .. 'hvyproton_cannon_hit_10_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhit_distort_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletank3_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletank2_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletank_emit.bp',
	EmtBpPathAlt .. 'tm_kamibomb_hit_09a_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant3battletankhitunit_emit.bp',
	EmtBpPathAlt .. 'tmcybrant2battletankhit_08_emit.bp', ## white exploding glow in middle
	EmtBpPathAlt .. 'tmcybrant2battletankhit_09_emit.bp', ## black exploding dots in middle
    EmtBpPathAlt .. 'battletankt3flames_emit.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
}

CybranT3BattleTankRocketHit = {
	EmtBpPathAlt .. 'hvyproton_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_03_emit.bp',
    EmtBpPathAlt .. 'hvyproton_cannon_hit_04_emit.bp',
    EmtBpPathAlt .. 'hvyproton_cannon_hit_10_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletank3_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletank_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhit_distort_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhitunit_02_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhitunit_01_emit.bp',
}

CybranT3PdroHit = {
	EmtBpPathAlt .. 'cybranheavyrocket_hit_01_emit.bp',
	EmtBpPathAlt .. 'cybranheavyrocket_hit_02_emit.bp',
	EmtBpPathAlt .. 'cybranheavyrocket_hit_03_emit.bp',
	EmtBpPathAlt .. 'cybranheavyrocket_hit_04_emit.bp',
	EmtBpPathAlt .. 'cybranheavyrocket_hit_05_emit.bp',
	EmtBpPathAlt .. 'cybranheavyrocket_hit_06_emit.bp',
	EmtBpPathAlt .. 'cybranheavyrocket_hit_07_emit.bp',
	EmtBpPathAlt .. 'cybranheavyrocket_hit_08_emit.bp',
	EmtBpPathAlt .. 'cybranheavyrocket_hit_09_emit.bp',
	EmtBpPathAlt .. 'cybranheavyrocket_hit_distort_emit.bp',
	EmtBpPathAlt .. 'tm_kamibomb_hit_05a_emit.bp', ## Red glow
}

CybranT3MadCatRocketsHit = {
	EmtBpPathAlt .. 'hvyproton_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_03_emit.bp',
    EmtBpPathAlt .. 'hvyproton_cannon_hit_04_emit.bp',
    EmtBpPathAlt .. 'hvyproton_cannon_hit_10_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletank3_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletank_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhit_distort_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhitunit_02_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhitunit_01_emit.bp',
	EmtBpPathAlt .. 'tmcybrant2battletankhit_08_emit.bp', ## white exploding glow in middle
	EmtBpPathAlt .. 'tmcybrant2battletankhit_09_emit.bp', ## black exploding dots in middle
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
}

Madcatmk2hit = {
    EmtBpPath .. 'hvyproton_cannon_hit_06_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_08_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhit_distort_emit.bp',
	EmtBpPath .. 'shipgauss_cannon_hit_03_emit.bp',
    EmtBpPath .. 'hiro_laser_cannon_hit_01_emit.bp',
    EmtBpPath .. 'hiro_laser_cannon_hit_02_emit.bp',
    EmtBpPath .. 'hiro_laser_cannon_hit_03_emit.bp',
    EmtBpPath .. 'hiro_laser_cannon_hit_04_emit.bp',
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
    EmtBpPathAlt .. 'tmcybrant3battletankhitunit_02_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhitunit_01_emit.bp',
	EmtBpPathAlt .. 'tmcybrant2battletankhit_04_emit.bp', ## dirt flying
	EmtBpPathAlt .. 'tmcybrant2battletankhit_05_emit.bp', ## ring
	EmtBpPathAlt .. 'tm_kamibomb_hit_05_emit.bp', ## Red glow
	EmtBpPathAlt .. 'tmcybrant2battletankhit_06_emit.bp', ## white glow in middle
	EmtBpPathAlt .. 'tmcybrant2battletankhit_07_emit.bp', ## black dots on ground
}

BattleMech2RocketHit = {
    EmtBpPathAlt .. 'bm2rockethit_01_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_02_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_03_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_04_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_05_emit.bp',
	EmtBpPathAlt .. 'tm_kamibomb_hit_05_emit.bp', ## Red glow
	EmtBpPathAlt .. 'tmcybrant2battletankhit_07_emit.bp', ## black dots on ground
	EmtBpPathAlt .. 'bm2rockethit_06_emit.bp', ## ring
	EmtBpPathAlt .. 'hvyproton_cannon_hit_02_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_10_emit.bp', ## Exploding flames
    EmtBpPathAlt .. 'tmcybrant3battletankhit_distort_emit.bp',
	EmtBpPathAlt .. 'bm2rockethit_07_emit.bp', ## Ring effect
	EmtBpPathAlt .. 'tm_kamibomb_hit_08_emit.bp', ## White inner ring
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
	EmtBpPathAlt .. 'bm2rockethit_09_emit.bp', ## Red glow explosion with smoke
    EmtBpPathAlt .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
}

CybranHeavyProtonGunHit = {
	EmtBpPathAlt .. 'tm_kamibomb_hit_01_emit.bp', ## Flames rising
	EmtBpPathAlt .. 'tm_kamibomb_hit_04_emit.bp', ## 
	EmtBpPathAlt .. 'tm_kamibomb_hit_03_emit.bp', ## Exploding flames
	EmtBpPathAlt .. 'tm_kamibomb_hit_05_emit.bp', ## Red glow
	EmtBpPathAlt .. 'tm_kamibomb_hit_06_emit.bp', ## Ring effect
	EmtBpPathAlt .. 'tm_kamibomb_hit_07_emit.bp', ## Sparks flying out
	EmtBpPathAlt .. 'tm_kamibomb_hit_08_emit.bp', ## White inner ring
	EmtBpPathAlt .. 'tm_kamibomb_hit_09_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant3battletank3_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletank2_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhit_distort_emit.bp',
}

Beetleprojectilehit01 = {
	EmtBpPathAlt .. 'tm_kamibomb_hit_05_emit.bp', ## Red glow
	EmtBpPathAlt .. 'tm_kamibomb_hit_06_emit.bp', ## Ring effect
	EmtBpPathAlt .. 'tm_kamibomb_hit_07_emit.bp', ## Sparks flying out
	EmtBpPathAlt .. 'tm_kamibomb_hit_08_emit.bp', ## White inner ring
	EmtBpPathAlt .. 'tm_kamibomb_hit_09_emit.bp', ## Yellow Afterglow
	EmtBpPathAlt .. 'tmredglowbig_emit.bp',
	EmtBpPathAlt .. 'bm2rockethit_07_emit.bp', ## Ring effect
	EmtBpPathAlt .. 'tm_kamibomb_hit_08_emit.bp', ## White inner ring
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
}

CybranHeavyProtonRocketHit = {
	EmtBpPathAlt .. 'tm_kamibomb_hit_01_emit.bp', ## glow
	EmtBpPathAlt .. 'tm_kamibomb_hit_03_emit.bp', ## Exploding flames
	EmtBpPathAlt .. 'tm_kamibomb_hit_05_emit.bp', ## Red glow
	EmtBpPathAlt .. 'tm_kamibomb_hit_06_emit.bp', ## Ring effect
	EmtBpPathAlt .. 'tm_kamibomb_hit_07_emit.bp', ## Sparks flying out
	EmtBpPathAlt .. 'tm_kamibomb_hit_08_emit.bp', ## White inner ring
	EmtBpPathAlt .. 'tm_kamibomb_hit_09_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'tmcybrant3battletank3_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletank2_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhit_distort_emit.bp',
    EmtBpPathAlt .. 'tmcybrant3battletankhitunit_emit.bp',
}

UEFHeavyMechHit01 = {
	EmtBpPathAlt .. 'uefepd_cannon_hit_01a_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_03_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_04_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_05_emit.bp',

	EmtBpPathAlt .. 'uefepd_cannon_hit_07_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_08_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_09_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_10_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_11_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_12_emit.bp',
	EmtBpPath .. 'seraphim_expnuke_prelaunch_09_emit.bp',	## blueish glow
}

AeonNocaCatBlueLaserHit = {
    EmtBpPath .. 'oblivion_cannon_hit_05_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_06_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_07_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_08_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_09_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_10_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_11_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_12_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_13_emit.bp',
    EmtBpPath .. 'cybran_corsair_missile_hit_ring.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_02_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_03_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_04_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_05_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_06_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_07_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_08_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_09_emit.bp',
	EmtBpPath .. 'seraphim_heavyquarnon_cannon_frontal_glow_01_emit.bp',
}

AeonCougarBlueLaserHit = {
    EmtBpPath .. 'oblivion_cannon_hit_05_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_06_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_07_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_08_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_09_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_10_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_11_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_12_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_13_emit.bp',
    EmtBpPath .. 'cybran_corsair_missile_hit_ring.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_02_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_03_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_04_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_05_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_06_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_07_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_08_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_09_emit.bp',
	EmtBpPath .. 'seraphim_heavyquarnon_cannon_frontal_glow_01_emit.bp',
}

AeonClawHit01 = {
    EmtBpPath .. 'oblivion_cannon_hit_05_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_06_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_07_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_08_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_09_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_10_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_11_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_12_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_13_emit.bp',
    EmtBpPath .. 'cybran_corsair_missile_hit_ring.bp',
}

AeonT1EXM1MainHit01 = {
    EmtBpPath .. 'oblivion_cannon_hit_02_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_sparks_01_emit.bp',
    EmtBpPath .. 'aeon_mortar02_shell_01_emit.bp',
    EmtBpPath .. 'aeon_mortar02_shell_02_emit.bp',
    EmtBpPath .. 'aeon_mortar02_shell_03_emit.bp',
    EmtBpPath .. 'aeon_mortar02_shell_04_emit.bp',
    EmtBpPath .. 'cybran_corsair_missile_hit_ring.bp',
}

AeonHvyClawHit01 = {
    EmtBpPath .. 'oblivion_cannon_hit_05_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_06_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_07_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_08_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_09_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_10_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_11_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_12_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_13_emit.bp',
    EmtBpPath .. 'antimatter_ring_02_emit.bp',	##	ring11	
    EmtBpPath .. 'napalm_hvy_flash_emit.bp',
    EmtBpPath .. 'napalm_hvy_thick_smoke_emit.bp',
    #EmtBpPath .. 'napalm_hvy_fire_emit.bp',
    EmtBpPath .. 'napalm_hvy_thin_smoke_emit.bp',
    EmtBpPath .. 'napalm_hvy_01_emit.bp',
    EmtBpPath .. 'napalm_hvy_02_emit.bp',
    EmtBpPath .. 'napalm_hvy_03_emit.bp',
}

UefT2EPDPlasmaHit01 = {
	EmtBpPathAlt .. 'uefepd_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_03_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_04_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_05_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_06_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_07_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_08_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_09_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_10_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_11_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_12_emit.bp',
}

UefT3SHPDGaussHit01 = {
	EmtBpPathAlt .. 'tm_kamibomb_hit_06_emit.bp', ## Ring effect
	EmtBpPathAlt .. 'uefepd_cannon_hit_01b_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'shpd_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'shpd_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'shpd_cannon_hit_03_emit.bp',
	EmtBpPathAlt .. 'shpd_cannon_hit_04_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_10_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_11_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_12_emit.bp',
}

AeonT3HeavyRocketHit01 = {
    EmtBpPath .. 'quantum_hit_flash_04_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_05_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_06_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_07_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_08_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_09_emit.bp',
    EmtBpPath .. 'antimatter_ring_02_emit.bp',	##	ring11
    EmtBpPath .. 'antimatter_hit_01_emit.bp',	##	glow	
    EmtBpPath .. 'antimatter_hit_02_emit.bp',	##	flash	     
    EmtBpPath .. 'antimatter_hit_03_emit.bp', 	##	sparks
    EmtBpPath .. 'napalm_hvy_flash_emit.bp',
    EmtBpPath .. 'napalm_hvy_thick_smoke_emit.bp',
    #EmtBpPath .. 'napalm_hvy_fire_emit.bp',
    EmtBpPath .. 'napalm_hvy_thin_smoke_emit.bp',
    EmtBpPath .. 'napalm_hvy_01_emit.bp',
    EmtBpPath .. 'napalm_hvy_02_emit.bp',
    EmtBpPath .. 'napalm_hvy_03_emit.bp',
}

AeonT3RocketHit01 = { 
    EmtBpPath .. 'antimatter_hit_03_emit.bp', 	##	sparks
    EmtBpPath .. 'napalm_hvy_flash_emit.bp',
    EmtBpPath .. 'aeon_sonance_hit_01_emit.bp',
    EmtBpPath .. 'aeon_sonance_hit_02_emit.bp',
    EmtBpPath .. 'aeon_sonance_hit_03_emit.bp',
    EmtBpPath .. 'aeon_sonance_hit_04_emit.bp',
    EmtBpPath .. 'quark_bomb_explosion_08_emit.bp',
    EmtBpPath .. 'quark_bomb_explosion_03_emit.bp',
    EmtBpPath .. 'quark_bomb_explosion_06_emit.bp',
}

CLaserBotHit01 = {
    EmtBpPath .. 'disintegratorhvy_hit_flash_flat_02_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_flat_03_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_04_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_05_emit.bp',
    EmtBpPath .. 'electron_bolter_hit_02_emit.bp',
    EmtBpPath .. 'electron_bolter_hit_03_emit.bp',
    EmtBpPath .. 'molecular_resonance_cannon_ring_02_emit.bp',
}

CybranT1BattleTankDeath = {
    EmtBpPath .. 'disintegratorhvy_hit_flash_flat_02_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_flat_03_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_04_emit.bp',
    EmtBpPath .. 'disintegratorhvy_hit_flash_05_emit.bp',
    EmtBpPath .. 'electron_bolter_hit_02_emit.bp',
    EmtBpPath .. 'electron_bolter_hit_03_emit.bp',
    EmtBpPath .. 'molecular_resonance_cannon_ring_02_emit.bp',
}

UEFHighExplosiveShellHit01 = {
	EmtBpPathAlt .. 'uefexmgauss_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'uefexmgauss_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'uefexmgauss_cannon_hit_03_emit.bp',
	EmtBpPathAlt .. 'uefexmgauss_cannon_hit_04_emit.bp',
	EmtBpPathAlt .. 'uefexmgauss_cannon_hit_05_emit.bp',
	EmtBpPathAlt .. 'uefexm_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'uefexm_cannon_hit_02_emit.bp',
}

UEFHighExplosiveShellHit02 = {
	EmtBpPathAlt .. 'uefepd_cannon_hit_01a_emit.bp',
	EmtBpPath .. 'shipgauss_cannon_hit_01_emit.bp',
	EmtBpPath .. 'shipgauss_cannon_hit_02_emit.bp',
	EmtBpPath .. 'shipgauss_cannon_hit_03_emit.bp',
	EmtBpPath .. 'shipgauss_cannon_hit_10_emit.bp',
	EmtBpPath .. 'shipgauss_cannon_hit_11_emit.bp',
	EmtBpPath .. 'shipgauss_cannon_hit_06_emit.bp',
	EmtBpPath .. 'shipgauss_cannon_hit_07_emit.bp',
	#EmtBpPath .. 'shipgauss_cannon_hit_08_emit.bp',
	EmtBpPath .. 'shipgauss_cannon_hit_09_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_distort_emit.bp',
    EmtBpPath .. 'antimatter_hit_02_emit.bp',	##	flash	     
    EmtBpPath .. 'antimatter_hit_03_emit.bp', 	##	sparks
    EmtBpPath .. 'antimatter_hit_04_emit.bp',	##	plume fire
    EmtBpPath .. 'antimatter_hit_05_emit.bp',	##	plume dark 
    EmtBpPath .. 'antimatter_hit_06_emit.bp',	##	base fire
    EmtBpPath .. 'antimatter_hit_07_emit.bp',	##	base dark 
    EmtBpPath .. 'antimatter_hit_08_emit.bp',	##	plume smoke
    EmtBpPath .. 'antimatter_hit_09_emit.bp',	##	base smoke
    EmtBpPath .. 'antimatter_hit_10_emit.bp',	##	plume highlights
    EmtBpPath .. 'antimatter_hit_11_emit.bp',	##	base highlights
    EmtBpPath .. 'seraphim_inaino_hit_03_emit.bp',			## long glow
}

AeonQuantumChargeHit01 = {
    EmtBpPath .. 'quantum_hit_flash_04_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_05_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_06_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_07_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_08_emit.bp',
    EmtBpPath .. 'antimatter_hit_02_emit.bp',	##	flash	     
    EmtBpPath .. 'antimatter_hit_03_emit.bp', 	##	sparks
    EmtBpPath .. 'quantum_hit_flash_09_emit.bp',
    EmtBpPath .. 'aeon_commander_disruptor_hit_01_emit.bp', 
    EmtBpPath .. 'aeon_commander_disruptor_hit_02_emit.bp', 
    EmtBpPath .. 'aeon_commander_disruptor_hit_03_emit.bp',  
    EmtBpPath .. 'quark_bomb_explosion_03_emit.bp',
    EmtBpPath .. 'quark_bomb_explosion_04_emit.bp',
    EmtBpPath .. 'quark_bomb_explosion_05_emit.bp',
    EmtBpPath .. 'quark_bomb_explosion_07_emit.bp',
    EmtBpPath .. 'quark_bomb_explosion_08_emit.bp',
    EmtBpPath .. 'molecular_resonance_cannon_ring_02_emit.bp',
    EmtBpPath .. 'napalm_hvy_flash_emit.bp',
}

AeonEnforcerMainGuns = {
    EmtBpPath .. 'aeon_bomber_hit_01_emit.bp',
    EmtBpPath .. 'aeon_bomber_hit_02_emit.bp',
    EmtBpPath .. 'aeon_bomber_hit_03_emit.bp',
    EmtBpPath .. 'aeon_bomber_hit_04_emit.bp',
    EmtBpPath .. 'phalanx_muzzle_glow_01_emit.bp',
}

AeonQuantumChargeMuzzle01 = {
    EmtBpPath .. 'quantum_hit_flash_04_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_05_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_06_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_07_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_08_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_09_emit.bp',
    EmtBpPath .. 'aeon_commander_disruptor_hit_01_emit.bp', 
    EmtBpPath .. 'aeon_commander_disruptor_hit_02_emit.bp', 
    EmtBpPath .. 'aeon_commander_disruptor_hit_03_emit.bp',  
    EmtBpPath .. 'quark_bomb_explosion_03_emit.bp',
    EmtBpPath .. 'quark_bomb_explosion_04_emit.bp',
    EmtBpPath .. 'quark_bomb_explosion_05_emit.bp',
    EmtBpPath .. 'quark_bomb_explosion_07_emit.bp',
    EmtBpPath .. 'quark_bomb_explosion_08_emit.bp',
}

AeonNovaCatFireEffect01 = {
    EmtBpPath .. 'disintegratorhvy_hit_sparks_01_emit.bp',
    EmtBpPath .. 'cybran_corsair_missile_hit_ring.bp',
}

AeonCougarMainGuns = {
    EmtBpPath .. 'disintegratorhvy_hit_sparks_01_emit.bp',
    EmtBpPath .. 'cybran_corsair_missile_hit_ring.bp',
    EmtBpPath .. 'disruptor_hitunit_01_emit.bp',
    EmtBpPath .. 'disruptor_hitunit_02_emit.bp',
    EmtBpPath .. 'disruptor_hitunit_03_emit.bp',
    EmtBpPath .. 'disruptor_hitunit_04_emit.bp',	
}

AeonT3EMPburst = {
    EmtBpPath .. 'shockwave_01_emit.bp',  
    EmtBpPath .. 'proton_bomb_hit_02_emit.bp',
}

CybranT3BattleTankDeath = {
    EmtBpPath .. 'cybran_corsair_missile_hit_ring.bp',
	EmtBpPathAlt .. 'tm_kamibomb_hit_05_emit.bp', ## Red glow
}

CybranT3BattleBotDeath = {
    EmtBpPath .. 'molecular_resonance_cannon_ring_02_emit.bp',
    EmtBpPath .. 'phalanx_muzzle_glow_01_emit.bp',
	EmtBpPathAlt .. 'tm_kamibomb_hit_05_emit.bp', ## Red glow
    EmtBpPath .. 'cybran_corsair_missile_hit_ring.bp',
}


UefT1BattleTankHit = {
	EmtBpPathAlt .. 'landgauss_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_03_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_04_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_05_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02_emit.bp',
}

UefT2BattleTankHit = {
	EmtBpPathAlt .. 'landgauss_cannon_hit_01a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_02a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_03a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_04a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_05a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_01a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02b_emit.bp',
}

UefT2BattleTankHit2 = {

	EmtBpPathAlt .. 'landgauss_cannon_hit_02c_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_03b_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_04b_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_05b_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_01fa_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02f_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02fa_emit.bp',
}

UefT1MedTankHit = {
	EmtBpPathAlt .. 'landgauss_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_03_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_04_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_05_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_01_emit.bp',
}

UefT3BattletankHit = {
	EmtBpPathAlt .. 'gauss_cannon_hit_01a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02b_emit.bp',
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
	EmtBpPathAlt .. 'landgauss_cannon_hit_02a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_03a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_04a_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_01_emit.bp',
}

UefT3BattletankRocketHit = {
	EmtBpPathAlt .. 'gauss_cannon_hit_01a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02b_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_02a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_03a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_04a_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_01_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_02_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_03_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_04_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_05_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_06_emit.bp',
}

UEFHighExplosiveRocketHit = {
	EmtBpPathAlt .. 'gauss_cannon_hit_01a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02b_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_02a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_03a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_04a_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_01_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_02_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_03_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_04_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_05_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_06a_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_01a_emit.bp',
}

AeonT3BattleBotHit01 = {
	EmtBpPathAlt .. 'aeont3armoredbattlebot_hit_01_emit.bp',
	EmtBpPathAlt .. 'aeont3armoredbattlebot_hit_02_emit.bp',
	EmtBpPathAlt .. 'aeont3armoredbattlebot_hit_03_emit.bp',
	EmtBpPathAlt .. 'aeont3armoredbattlebot_hit_04_emit.bp',
	EmtBpPathAlt .. 'aeont3armoredbattlebot_hit_05_emit.bp',
	EmtBpPathAlt .. 'aeont3armoredbattlebot_hit_06_emit.bp',
	EmtBpPathAlt .. 'aeont3armoredbattlebot_hit_07_emit.bp',
	EmtBpPathAlt .. 'aeont3armoredbattlebot_hit_08_emit.bp',
}

AeonT1ExperimentalLaserHit = {
	EmtBpPathAlt .. 'aeont1exlaser_hit_01_emit.bp',
	EmtBpPathAlt .. 'aeont1exlaser_hit_02_emit.bp',
	EmtBpPathAlt .. 'aeont1exlaser_hit_03_emit.bp',
	EmtBpPathAlt .. 'aeont1exlaser_hit_04_emit.bp',
	EmtBpPathAlt .. 'aeont1exlaser_hit_05_emit.bp',
	EmtBpPathAlt .. 'aeont1exlaser_hit_06_emit.bp',
	EmtBpPathAlt .. 'aeont1exlaser_hit_07_emit.bp',
	EmtBpPathAlt .. 'aeont1exlaser_hit_08_emit.bp',
}

AeonMainBattleTankHit01 = {
	EmtBpPathAlt .. 'aeonMainbattletank_hit_emit01.bp',
	EmtBpPathAlt .. 'aeonMainbattletank_hit_emit02.bp',
	EmtBpPathAlt .. 'aeonMainbattletank_hit_emit03.bp',
	EmtBpPathAlt .. 'aeonMainbattletank_hit_emit04.bp',
	EmtBpPathAlt .. 'aeonMainbattletank_hit_emit05.bp',
	EmtBpPathAlt .. 'aeonMainbattletank_hit_emit06.bp',
	EmtBpPathAlt .. 'aeonMainbattletank_hit_emit08.bp',
	EmtBpPathAlt .. 'aeonMainbattletank_hit_emit09.bp',
	EmtBpPathAlt .. 'aeonMainbattletank_hit_emit10.bp',
	EmtBpPathAlt .. 'aeonMainbattletank_hit_emit11.bp',
	EmtBpPathAlt .. 'aeonMainbattletank_hit_emit12.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_01b_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_02_emit.bp',
}

PrideFlyingEmitter = {
    EmtBpPathAlt .. 'prideflying_emit.bp',
    EmtBpPathAlt .. 'prideflying_emit2.bp',
    EmtBpPathAlt .. 'prideflying_emit3.bp',
}

PrideHit01 = {
    EmtBpPathAlt .. 'pridehit01.bp',
    EmtBpPathAlt .. 'pridehit02.bp',
    EmtBpPathAlt .. 'pridehit03.bp',
    EmtBpPathAlt .. 'pridehit04.bp',
    EmtBpPathAlt .. 'pridehit05.bp',
    EmtBpPathAlt .. 'pridehit06.bp',
    EmtBpPathAlt .. 'pridehit07.bp',
    EmtBpPathAlt .. 'pridehit09.bp',
    EmtBpPathAlt .. 'pridehit10.bp',
    EmtBpPathAlt .. 'pridehit11.bp',
    EmtBpPathAlt .. 'pridehit12.bp',
    EmtBpPathAlt .. 'pridehit13.bp',
    EmtBpPathAlt .. 'pridehit14.bp',
    EmtBpPathAlt .. 'pridehit16.bp',
    EmtBpPathAlt .. 'pridehitglow.bp',
    EmtBpPathAlt .. 'pridehitglow2.bp',
    EmtBpPathAlt .. 'pridehitflames.bp',
    EmtBpPathAlt .. 'pridehitflames2.bp',
    EmtBpPathAlt .. 'pridehitsmoke.bp',
    EmtBpPathAlt .. 'pridehitsmoke2.bp',
    EmtBpPathAlt .. 'pridehitring.bp',
    EmtBpPathAlt .. 'pridehitring2.bp',
    EmtBpPathAlt .. 'mayhemmk4blueglow_emit.bp',	##	
    EmtBpPathAlt .. 'mayhemmk4blueglowlong_emit.bp',	##
}

ValiantHit = {
    EmtBpPathAlt .. 'aeon_valianthit_01.bp',
    EmtBpPathAlt .. 'aeon_valianthit_02.bp',
    EmtBpPathAlt .. 'aeon_valianthit_03.bp',
    EmtBpPathAlt .. 'aeon_valianthit_04.bp',
    EmtBpPathAlt .. 'aeon_valianthit_05.bp',
    EmtBpPathAlt .. 'aeon_valianthit_06.bp',
    EmtBpPathAlt .. 'aeon_valianthit_07.bp',
    EmtBpPathAlt .. 'aeon_valianthit_08.bp',
    EmtBpPathAlt .. 'aeon_valianthit_09.bp',
    EmtBpPathAlt .. 'aeon_valianthit_10.bp',
    EmtBpPathAlt .. 'aeon_valianthit_11.bp',
    EmtBpPathAlt .. 'aeon_valianthit_12.bp',
    EmtBpPathAlt .. 'aeon_valianthit_13.bp',
}


HadesHit01 = {
    EmtBpPathAlt .. 'aeon_hadeshit01.bp',
    EmtBpPathAlt .. 'aeon_hadeshit02.bp',
    EmtBpPathAlt .. 'aeon_hadeshit03.bp',
    EmtBpPathAlt .. 'aeon_hadeshit04.bp',
    EmtBpPathAlt .. 'aeon_hadeshit04a.bp',
    EmtBpPathAlt .. 'aeon_hadeshit05.bp',
    EmtBpPathAlt .. 'aeon_hadeshit06.bp',
    EmtBpPathAlt .. 'aeon_hadeshit07.bp',
    EmtBpPathAlt .. 'aeon_hadeshit09.bp',
    EmtBpPathAlt .. 'aeon_hadeshit08.bp',
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
	EmtBpPathAlt .. 'Hades_smoke_emit.bp',

}

PrideSmallHit01 = {
    EmtBpPathAlt .. 'aeon_hadeshit01.bp',
    EmtBpPathAlt .. 'aeon_hadeshit02.bp',
    EmtBpPathAlt .. 'aeon_hadeshit03.bp',
    EmtBpPathAlt .. 'aeon_hadeshit04.bp',
    EmtBpPathAlt .. 'aeon_hadeshit04a.bp',
    EmtBpPathAlt .. 'aeon_hadeshit05.bp',
    EmtBpPathAlt .. 'aeon_hadeshit06.bp',
    EmtBpPathAlt .. 'aeon_hadeshit07.bp',
    EmtBpPathAlt .. 'aeon_hadeshit09.bp',
    EmtBpPathAlt .. 'aeon_hadeshit08.bp',
    EmtBpPathAlt .. 'pridehitflames3.bp',
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
	EmtBpPathAlt .. 'Hades_smoke_emit.bp',

}

AvalancheRocketHit = {
    EmtBpPathAlt .. 'bigdistort_emit.bp',
    EmtBpPathAlt .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'comedred_darkfire_emit.bp',	##	
    EmtBpPathAlt .. 'comedred_fire_emit.bp',	##
    EmtBpPathAlt .. 'comedred_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'madcatdeathring.bp',	##
    EmtBpPathAlt .. 'madcatredglow_02_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_01_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_02_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_03_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_04_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_05_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_06_emit.bp',
	EmtBpPathAlt .. 'cybran_t2beetle_07_emit.bp',
}

UEFMayhemMK4hit1 = {
    EmtBpPathTM .. 'bigdistort_emit.bp',
    EmtBpPathTM .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathTM .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathAlt .. 'mayhemmk4blue_01_emit.bp', ## Exploding flames
    EmtBpPathAlt .. 'mayhemmk4blue_02_emit.bp', ## Cool exploding flames!!!
    EmtBpPathTM .. 'co_smoke_emit.bp',	##	
    EmtBpPathAlt .. 'darkfireblue_emit.bp',	##
    EmtBpPathAlt .. 'fireblue_emit.bp',	##	
    EmtBpPath .. 'antimatter_ring_01_emit.bp',	##	ring14
    EmtBpPathAlt .. 'mayhemmk4blueglow_emit.bp',	##	
    EmtBpPathAlt .. 'mayhemmk4blueglowlong_emit.bp',	##	
}

UEFmayhemRocketHitA = {
    EmtBpPathTM .. 'bigdistort_emit.bp',
    EmtBpPathTM .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathTM .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathTM .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
    EmtBpPathTM .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPathTM .. 'comed_smoke_emit.bp',	##	
    EmtBpPathTM .. 'comed_darkfire_emit.bp',	##
    EmtBpPathTM .. 'comed_fire_emit.bp',	##	
	EmtBpPathTM .. 'ueft2experimental_missile_07_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_08_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_09_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_10_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_11_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_12_emit.bp',
	EmtBpPathTM .. 'ueft2experimental_missile_13_emit.bp',
    EmtBpPathAlt .. 'mayhemmk4blueglow2_emit.bp',	##	
}

UEFmayhemRocketHit2A = {
    EmtBpPathTM .. 'bigdistort_emit.bp',
    EmtBpPathTM .. 'bm2rockethit_12_emit.bp', ## white glow
	EmtBpPathTM .. 'bm2rockethit_08_emit.bp', ## Yellow Afterglow
    EmtBpPathTM .. 'tmcybrant2battletankhit_01_emit.bp', ## Exploding flames
    EmtBpPathTM .. 'bm2rockethit_11_emit.bp', ## Cool exploding flames!!!
    EmtBpPathTM .. 'cosml_smoke_emit.bp',	##	
    EmtBpPathTM .. 'cosml_darkfire_emit.bp',	##
    EmtBpPathTM .. 'cosml_fire_emit.bp',	##	
    EmtBpPathAlt .. 'mayhemmk4blueglow2_emit.bp',	##	
}

Mayhemmk4EMPeffect = {
    EmtBpPath .. 'shockwave_01_emit.bp', 
    EmtBpPathTM .. 'bigdistort_emit.bp',
    EmtBpPathAlt .. 'mayhemmk4blueglow_emit.bp',	##	
}

WeaponSteam01 = {
    EmtBpPath .. 'weapon_mist_01_emit.bp',
}
FireCloudSml01 = {
    EmtBpPath .. 'fire_cloud_05_emit.bp',
    EmtBpPath .. 'fire_cloud_04_emit.bp',
}
FlashSml01 = { EmtBpPath .. 'flash_01_emit.bp',}
FlareSml01 = { EmtBpPath .. 'flare_01_emit.bp',}


#---------------------------------------------------------------
# Default Projectile Impact Effects
#---------------------------------------------------------------
DefaultMissileHit01 = TableCat( FireCloudSml01, FlashSml01, FlareSml01 )
DefaultProjectileAirUnitImpact = {
    EmtBpPath .. 'destruction_unit_hit_flash_01_emit.bp',
    EmtBpPath .. 'destruction_unit_hit_shrapnel_01_emit.bp',
}
DefaultProjectileLandImpact = {
    EmtBpPath .. 'projectile_dirt_impact_small_01_emit.bp',
    EmtBpPath .. 'projectile_dirt_impact_small_02_emit.bp',
    EmtBpPath .. 'projectile_dirt_impact_small_03_emit.bp',
    EmtBpPath .. 'projectile_dirt_impact_small_04_emit.bp',
}
DefaultProjectileLandUnitImpact = {
    EmtBpPath .. 'destruction_unit_hit_flash_01_emit.bp',
    EmtBpPath .. 'destruction_unit_hit_shrapnel_01_emit.bp',
}
DefaultProjectileWaterImpact = {
    EmtBpPath .. 'destruction_water_splash_ripples_01_emit.bp',
    EmtBpPath .. 'destruction_water_splash_wash_01_emit.bp',
    EmtBpPath .. 'destruction_water_splash_plume_01_emit.bp',
}
DefaultProjectileUnderWaterImpact = {
    EmtBpPath .. 'destruction_underwater_explosion_flash_01_emit.bp',
    EmtBpPath .. 'destruction_underwater_explosion_flash_02_emit.bp',
    EmtBpPath .. 'destruction_underwater_explosion_splash_01_emit.bp',
}
DustDebrisLand01 = {
    EmtBpPath .. 'dust_cloud_02_emit.bp',
    EmtBpPath .. 'dust_cloud_04_emit.bp',
    EmtBpPath .. 'destruction_explosion_debris_04_emit.bp',
    EmtBpPath .. 'destruction_explosion_debris_05_emit.bp',
}
GenericDebrisLandImpact01 = {
    EmtBpPath .. 'dirtchunks_01_emit.bp',
    EmtBpPath .. 'dust_cloud_05_emit.bp',
}
GenericDebrisTrails01 = { EmtBpPath .. 'destruction_explosion_debris_trail_01_emit.bp',}
UnitHitShrapnel01 = { EmtBpPath .. 'destruction_unit_hit_shrapnel_01_emit.bp',}
WaterSplash01 = { 
    EmtBpPath .. 'water_splash_ripples_ring_01_emit.bp',
    EmtBpPath .. 'water_splash_plume_01_emit.bp',
}




#------------------------------------------------------------------------
#  TERRAN MAGMA CANNON EMITTERS:  Hacked by Ebola Soup for Magma Cannon from Ionized Plasma Gatling Cannon
#------------------------------------------------------------------------
TMagmaCannonHit01 = { # for all hits..ground and units

	# -- Below: borrowed from Heavy Napalm weapon.
	-- EmtBpPath .. 'napalm_hvy_flash_emit.bp',
    EmtBpPath .. 'napalm_hvy_thick_smoke_emit.bp',
    -- EmtBpPath .. 'napalm_hvy_thin_smoke_emit.bp',
    EmtBpPath .. 'napalm_hvy_01_emit.bp',
    -- EmtBpPath .. 'napalm_hvy_02_emit.bp',
    -- EmtBpPath .. 'napalm_hvy_03_emit.bp',
	# --------------
	# Ground hit effect borrowed from Cybran Artillery:
    EmtBpPathAlt .. 'balrog_proton_bomb_hit_01_emit.bp',
    -- EmtBpPathAlt .. 'balrog_proton_bomb_hit_02_emit.bp',
	# ----------------------
	# Impact frome Mavor shell:
    EmtBpPathAlt .. 'balrog_antimatter_hit_01_emit.bp',	##	glow	
    EmtBpPath .. 'antimatter_hit_02_emit.bp',	##	flash	     

    -- EmtBpPath .. 'antimatter_hit_04_emit.bp',	##	plume fire
    -- EmtBpPath .. 'antimatter_hit_05_emit.bp',	##	plume dark 
    -- EmtBpPath .. 'antimatter_hit_08_emit.bp',	##	plume smoke
    EmtBpPathAlt .. 'balrog_antimatter_hit_06_emit.bp',	##	base fire
    EmtBpPath .. 'antimatter_hit_07_emit.bp',	##	base dark 
    EmtBpPath .. 'antimatter_hit_09_emit.bp',	##	base smoke
    -- EmtBpPath .. 'antimatter_hit_10_emit.bp',	##	plume highlights
    EmtBpPath .. 'antimatter_hit_11_emit.bp',	##	base highlights
	-- EmtBpPath .. 'antimatter_hit_14_emit.bp',	##	base black stuff
    -- EmtBpPath .. 'antimatter_ring_02_emit.bp',	##	ring11
	EmtBpPath .. 'antimatter_ring_04_emit.bp',	##	black ring	
	#	----------------------------------------
	
}
TMagmaCannonHit02 = { # for Ground hits
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_land_hit_01_emit.bp',
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_land_hit_02_emit.bp',
    -- EmtBpPath .. 'antimatter_ring_01_emit.bp',	##	ring14
    EmtBpPath .. 'antimatter_hit_09_emit.bp',	##	base smoke

}

TMagmaCannonHit03 = { # for Unit hits
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_hitunit_01_emit.bp',
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_hitunit_03_emit.bp',
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_hitunit_06_emit.bp',
    EmtBpPath .. 'antimatter_hit_03_emit.bp', 	##	sparks
    #  Additional fire:
    EmtBpPath .. 'explosion_fire_sparks_01_emit.bp',
    EmtBpPath .. 'flash_01_emit.bp', # Unit hit from Napalm bomb
}
TMagmaCannonUnitHit = TableCat( TMagmaCannonHit01, TMagmaCannonHit03, UnitHitShrapnel01 )
TMagmaCannonHit = TableCat( TMagmaCannonHit01, TMagmaCannonHit02 )
TMagmaCannonMuzzleFlash = {
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_muzzle_flash_01_emit.bp',
    EmtBpPathAlt .. 'balrog_magma_cannon_muzzle_flash_01_emit.bp',
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_muzzle_flash_02_emit.bp',
    EmtBpPathAlt .. 'balrog_magma_cannon_muzzle_flash_02_emit.bp',
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_muzzle_flash_03_emit.bp',
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_muzzle_flash_04_emit.bp',
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_muzzle_flash_05_emit.bp',
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_muzzle_flash_06_emit.bp',
	-- EmtBpPath .. 'fire_emit.bp',
	
}
TMagmaCannonFxTrails = {
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_fxtrail_01_emit.bp',
    -- EmtBpPath .. 'ionized_plasma_gatling_cannon_laser_fxtrail_02_emit.bp', # faint tendrils around trail in original
    EmtBpPathAlt .. 'balrog_magma_projectile_fxtrail_01_emit.bp', # main orange/yellow glowing blob

}


TMagmaCannonPolyTrails = {
    EmtBpPathAlt .. 'balrog_missile_smoke_polytrail_01_emit.bp', # for dark black smoke around edges of fireball trail..transparent in center
    EmtBpPathAlt .. 'balrog_missile_smoke_polytrail_02_emit.bp', # narrower black/red trail following behind
}
